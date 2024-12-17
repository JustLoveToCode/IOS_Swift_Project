import UIKit

final class RMSearchOptionPickerViewController: UIViewController {
    
    // Creating the var option which is of type RMSearchInputViewViewModel.DynamicOption Here
    private let option:RMSearchInputViewViewModel.DynamicOption
    
    private let selectionBlock:((String)->Void)
    
    // Putting the tableView which is of UITableView
    private let tableView:UITableView = {
        // Invoking the UITableView() and Stored inside var table here
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier:"cell")
        return table
    }()
    
    // Mark - Init
    init(option:RMSearchInputViewViewModel.DynamicOption,selection:@escaping(String)->Void){
        self.option = option
        self.selectionBlock = selection
        super.init(nibName:nil, bundle:nil)
    }
    // Using the required init method here
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // Mark - LifeCycle Here
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        // Invoking the func for setUpTable Here
        setUpTable()
    }
    // Create private func setUpTable()
    private func setUpTable(){
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        // Using the NSLayoutConstraint.activate()
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo:view.safeAreaLayoutGuide.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
    }
}

// RMSearchOptionPickerViewController, UITableViewDelegate and UITableViewDataSource Here
extension RMSearchOptionPickerViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return option.choices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let choice = option.choices[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for:indexPath)
        // Getting the textLabel Text Here which is IOS Academy
        cell.textLabel?.text = choice.uppercased()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at:indexPath,animated:true)
        let choice = option.choices[indexPath.row]
        self.selectionBlock(choice)
        // Inform Caller Of Choice
        dismiss(animated:true)
        
    }
}
