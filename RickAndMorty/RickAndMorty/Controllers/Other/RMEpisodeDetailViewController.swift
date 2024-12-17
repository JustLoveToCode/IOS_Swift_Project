import UIKit


// VC to Show Details About Single Episode Here
final class RMEpisodeDetailViewController: UIViewController,RMEpisodeDetailViewViewModelDelegate,RMEpisodeDetailViewDelegate{
    private let viewModel:RMEpisodeDetailViewViewModel
    
    private let detailView = RMEpisodeDetailView()
    
    // Creating the init Functionality Here
    init(url:URL?){
        self.viewModel = RMEpisodeDetailViewViewModel(endpointUrl:url)
        super.init(nibName:nil, bundle:nil)
    }
    
    // Using the required init Here
    required init(coder:NSCoder) {
        fatalError()
    }
    
    // MARK - LifeCycle Functionality
    
    // override the original Parent UIViewController Functionality
    // which is the func viewDidLoad Here which inherit from the parent UIViewController Functionality
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(detailView)
        // Invoking the func addConstraints here
        addConstraints()
        detailView.delegate = self
        // Creating the title called Episode
        title = "Episode"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem:.action, target:self, action:#selector(didTapShare))
        
        viewModel.delegate = self
        viewModel.fetchEpisodeData()
    
    }
    private func addConstraints(){
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor),
            detailView.leftAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leftAnchor),
            detailView.rightAnchor.constraint(equalTo:view.safeAreaLayoutGuide.rightAnchor),
            detailView.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    // Create the private func didTapShare
    @objc
    private func didTapShare(){
        
    }
    
    // Mark - View Delegate
    // Create the func rmEpisodeDetailView
    func rmEpisodeDetailView(_ detailView:RMEpisodeDetailView,
                             didSelect character:RMCharacter){
        let vc = RMCharacterDetailViewController(viewModel: .init(character: character))
        // Using the method pushViewController here
        // Setting the title to be character.name
        vc.title = character.name
        // Setting the largeTitleDisplayMode to never Here
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated:true)
    }
    
    // Mark - ViewModel Delegate
    func didFetchEpisodeDetails(){
        detailView.configure(with: viewModel)
    }
}
