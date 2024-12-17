import UIKit

// Dynamnic Search Option View
// Render Results
// Render No Results Zero State

//Searching through API Calls

/// Configurable Controller to Search Model
final class RMSearchViewController: UIViewController {
    
    // Creating the Constant viewModel which is INSTANTIATED with RMSearchViewViewModel() Here
    private let viewModel: RMSearchViewViewModel
    
    // Creating the Constant searchView which is INSTANTIATED with RMSearchView() Here
    private let searchView : RMSearchView
    
    
    // Creating the struct called Config Here
    // Configuration for Our Search Session
    struct Config {
        
        // Create the enum Type Here
        enum `Type` {
            case character // name | status | gender
            case episode // name
            case location // name | type
            
            var endpoint:RMEndpoint{
                switch self{
                case .character:
                    return .character
                case .episode:
                    return .episode
                case .location:
                    return .location
                }
            }
            
           
            
            // Create the var title of type String Format
            var title: String{
                // Using the switch self Method Here
                switch self{
                case .character:
                    return " Search Character"
                case .location:
                    return "Search Location"
                case .episode:
                    return "Search Episode"
                }
            }
        }
        let type:`Type`
    }
  
    // Mark - Init
    init(config:Config){
        let viewModel = RMSearchViewViewModel(config:config)
        self.viewModel = viewModel
        self.searchView = RMSearchView(frame:.zero, viewModel:viewModel)
        super.init(nibName:nil, bundle:nil)
        
    }
    // Using the required init?
    required init?(coder:NSCoder) {
        fatalError("Unsupported")
    }
    
    // Using the override func viewDidLoad() Here
    // Mark - LifeCycle
    // Using the selector(didTapExecuteSearch) Here
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.config.type.title
        view.backgroundColor = .systemBackground
        view.addSubview(searchView)
        addConstraints()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title:"Search", style:.done, target:self,
                                                            action:#selector(didTapExecuteSearch)
        )
        searchView.delegate = self
    }
    // Creating the func viewDidAppear Here
    override func viewDidAppear(_ animated: Bool){
        // Using the super keyword for viewDidDisappear(animated) Here
        super.viewDidDisappear(animated)
        searchView.presentKeyboard()
    }
    
    @objc
    // Create private func didTapExecuteSearch Here
    private func didTapExecuteSearch(){
        // viewModel.executeSearch()
    }
    
    private func addConstraints(){
        // Using the safeAreaLayoutGuide Here
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            searchView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            searchView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

}

// Mark - RMSearchViewDelegate using the extension keyword Here
extension RMSearchViewController: RMSearchViewDelegate{
    func rmSearchView(_ searchView: RMSearchView, didSelectOption option: RMSearchInputViewViewModel.DynamicOption) {
        // Using the weak self method here
        let vc = RMSearchOptionPickerViewController(option:option){[weak self] selection in
            // Using the DispatchQueue and async method: Make the Entire Operation Asynchronous
            DispatchQueue.main.async{
                self?.viewModel.set(value: selection, for:option)
            }
        }
        vc.sheetPresentationController?.detents = [.medium()]
        vc.sheetPresentationController?.prefersGrabberVisible = true
        present(vc, animated:true)
    }
    // Using the func rmSearchView Here
    func rmSearchView(_ searchView: RMSearchView, didSelectLocation location: RMLocation) {
        let vc = RMLocationDetailViewController(location:location)
        // Setting the Large Title Display Mode to .never Here
        vc.navigationItem.largeTitleDisplayMode = .never
        // Using the pushViewController Method Here
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func rmSearchView(_ searchView:RMSearchView, didSelectCharacter character:RMCharacter){
        let vc = RMCharacterDetailViewController(viewModel: .init(character:character))
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func rmSearchView(_ searchView: RMSearchView, didSelectEpisode episode: RMEpisode) {
        let vc = RMEpisodeDetailViewController(url:URL(string:episode.url))
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
