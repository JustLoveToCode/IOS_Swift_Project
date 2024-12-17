import UIKit

// Controllers to show and search for Episodes
final class RMEpisodeViewController: UIViewController, RMEpisodeListViewDelegate {

    private let episodeListView = RMEpisodeListView()

    override func viewDidLoad() {
        // Override the viewDidLoad() Functionality
        super.viewDidLoad()
        // Creating the backgroundColor to be systemBackground Color
        view.backgroundColor = .systemBackground
        // Creating the title "Episodes"
        title = "Episodes"
        // Invoking the setUpView() Here
        setUpView()
        // Invoking the addSearchButton Functionality
        addSearchButton()
        
    }
    
    private func addSearchButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }
    
    @objc
    private func didTapSearch(){
        let vc = RMSearchViewController(config:.init(type:.episode))
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // Creating the function setUpView Here
    private func setUpView(){
        episodeListView.delegate = self
        view.addSubview(episodeListView)
        NSLayoutConstraint.activate([
            episodeListView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor),
            episodeListView.leftAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leftAnchor),
            episodeListView.rightAnchor.constraint(equalTo:view.safeAreaLayoutGuide.rightAnchor),
            episodeListView.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    // RMEpisodeListViewDelegate Functionality
    // Create the func rmEpisodeListView here
    func rmEpisodeListView(_ characterListView: RMEpisodeListView, didSelectEpisode episode: RMEpisode) {
        // Open Detail Controller for that Episode
        let detailVC = RMEpisodeDetailViewController(url:URL(string:episode.url))
        detailVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailVC, animated:true)
        
    }
  
}



