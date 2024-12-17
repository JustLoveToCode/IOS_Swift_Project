import UIKit

protocol RMSearchInputViewDelegate: AnyObject {
    func rmSearchInputView(_ inputView: RMSearchInputView,didSelectOption option:RMSearchInputViewViewModel.DynamicOption)
    
    func rmSearchInputView(_ inputView: RMSearchInputView,didChangeSearchText text:String)
    
    func rmSearchInputViewDidTapSearchKeyboardButton(_ inputView: RMSearchInputView)
}

// View for the Top Part of the Search Screen With Search Bar
final class RMSearchInputView: UIView {
    // Creating the var delegate of type RMSearchINputViewDelegate which is Optional
    weak var delegate:RMSearchInputViewDelegate?
    
    // Create the searchBar Variable of type UISearchBar Here
    private let searchBar: UISearchBar = {
        // Invoking the UISearchBar Here
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    // Creating the viewModel called RMSearchInputViewViewModel Here
    private var viewModel:RMSearchInputViewViewModel? {
        // Using the didSet Method
        didSet {
            guard let viewModel = viewModel, viewModel.hasDynamicOptions else {
                return
            }
            
            let options = viewModel.options
            createOptionSelectionViews(options: options)
        }
    }
    private var stackView: UIStackView?
    
    // Mark - Init() Here
    override init(frame:CGRect){
        super.init(frame:frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        addSubviews(searchBar)
        // Invoking the addConstraints() Functionality
        addConstraints()
        // Creating an extension here for RMSearchInputView
        searchBar.delegate = self
        
    }
    
    // Using the required init? method Here
    required init?(coder:NSCoder){
        fatalError()
    }
    
    // Create the private func addConstraints() Here
    private func addConstraints(){
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo:topAnchor),
            searchBar.leftAnchor.constraint(equalTo:leftAnchor), // |view |
            searchBar.rightAnchor.constraint(equalTo:rightAnchor),// | view-5|
            searchBar.heightAnchor.constraint(equalToConstant: 58)
            
        ])
    }
    
    // Create private func createOptionStackView of Type UIStackView Here
    private func createOptionStackView()->UIStackView{
        // Creating the UIStackView() Here and Storing it in the Variable called stackView Here
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        // Creating the stackView to be Horizontal in Nature
        stackView.axis = .horizontal
        // Adding the Spacing Between the Elements
        stackView.spacing = 6
        // Fill the Distribution Equally
        stackView.distribution = .fillEqually
        // Getting the Alignment to be Centered Here
        stackView.alignment = .center
        // Using the addSubview Here
        addSubview(stackView)
        
        // Using the NSLayoutConstraint.activate here
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            stackView.leftAnchor.constraint(equalTo: leftAnchor),
            stackView.rightAnchor.constraint(equalTo: rightAnchor),
            stackView.bottomAnchor.constraint(equalTo:bottomAnchor)
        ])
        return stackView
        
    }
    // Create the private func createOptionSelectionViews function
    private func createOptionSelectionViews(options:[RMSearchInputViewViewModel.DynamicOption]){
        let stackView = createOptionStackView()
        self.stackView = stackView
        
        // Using the for loop to loop through the Different options Here
        // Using the options.count here and Loop Through It
        for x in 0..<options.count {
            let option = options[x]
            let button = createButton(with:option, tag:x)
            // Using the method addArrangedSubview Method Here
            stackView.addArrangedSubview(button)
        }
    }
    // Create the private func of createButton func here
    private func createButton(with option:RMSearchInputViewViewModel.DynamicOption, tag:Int)->UIButton{
        // Creating a UIButton() Components Here
        let button = UIButton()
        // Setting the setAttributedTitle Properties Here
        // The state of the Button will be normal
        button.setAttributedTitle(NSAttributedString(string:option.rawValue,
                                                     attributes:[.font:UIFont.systemFont(ofSize: 18, weight:.medium),
                                                                 .foregroundColor: UIColor.label]),for:.normal)
        
        button.backgroundColor = .secondarySystemFill
        button.addTarget(self, action:#selector(didTapButton(_:)), for:.touchUpInside)
        // Creating the cornerRadius on the Button Component
        button.tag = tag
        // This is the cornerRadius for the Button Component
        button.layer.cornerRadius = 6
        // return the button Variable here
        return button
    }
    
    // Create the private func didTapButton
    @objc
    private func didTapButton(_ sender:UIButton){
        
        // Using the guard keyword on options here
        guard let options = viewModel?.options else {
            return
        }
        let tag = sender.tag
        let selected = options[tag]
        // rmSearchInputView Function Here
        delegate?.rmSearchInputView(self, didSelectOption:selected)
    }
    // Create the public func configure function
    public func configure(with viewModel:RMSearchInputViewViewModel){
        searchBar.placeholder = viewModel.searchPlaceholderText
        // Fix Height Of Input View for Episode With No Options
        self.viewModel = viewModel
    }
    
    // Create public func presentKeyboard Functionality
    public func presentKeyboard(){
        // It will Become the Focus Thing to the System Here
        searchBar.becomeFirstResponder()
    }
    public func update(
        option:RMSearchInputViewViewModel.DynamicOption,
        value:String){
            
        // Update the Different Options
        guard let buttons = stackView?.arrangedSubviews as? [UIButton],
              let allOptions = viewModel?.options,
              // Give me the Index of the Target Option
              let index=allOptions.firstIndex(of: option) else {
            return
        }
     
        buttons[index].setAttributedTitle(
        // Using the NSAttributedString Method
           NSAttributedString(
            string:value.uppercased(),
           attributes:[
          .font:UIFont.systemFont(ofSize: 18, weight:.medium),
          .foregroundColor: UIColor.link
        ]
          ),
        for:.normal
        )
    }
}

// Mark - UISearchBarDelegate
// This is used to capture the Changes in Text using RMSearchInputView of type
// UISearchBarDelegate HERE:

extension RMSearchInputView: UISearchBarDelegate{
    // func searchBar Here
    // Getting searchText as a form of String Format
    func searchBar(_ searchBar:UISearchBar, textDidChange searchText:String){
        print(searchText)
        // Notify Delegate Of Change Text
        delegate?.rmSearchInputView(self, didChangeSearchText: searchText)
        
    }
    // func searchBarSearchButtonClicked Here
    func searchBarSearchButtonClicked(_ searchBar:UISearchBar){
       // Notify that Search Button Was Tapped
        searchBar.resignFirstResponder()
        delegate?.rmSearchInputViewDidTapSearchKeyboardButton(self)
        
        
    }
}
