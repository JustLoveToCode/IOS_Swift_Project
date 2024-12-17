import UIKit

// Characters to show and search for characters
final class RMCharacterViewController: UIViewController, RMCharacterListViewDelegate {
    
    private let characterListView = RMCharacterListView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Characters"
        // Invoking the setUpView Functionality Here
        setUpView()
        // Invoking the addSearchButton Functionality Here
        addSearchButton()
        
    }
    private func addSearchButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }
    
    @objc
    private func didTapSearch(){
        // Invoking the RMSearchViewController Here
        let vc = RMSearchViewController(config: RMSearchViewController.Config(type:.character))
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated:true)
    }
    // Creating the function setUpView Here
    private func setUpView(){
        characterListView.delegate = self
        view.addSubview(characterListView)
        NSLayoutConstraint.activate([
            characterListView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor),
            characterListView.leftAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leftAnchor),
            characterListView.rightAnchor.constraint(equalTo:view.safeAreaLayoutGuide.rightAnchor),
            characterListView.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    // RMCharacterListViewDelegate Functionality
    func rmCharacterListView(_ characterListView: RMCharacterListView, didSelectCharacter character: RMCharacter) {
         
        // Open Details Controller for that Character Here
        let viewModel = RMCharacterDetailViewViewModel(character: character)
        let detailVC = RMCharacterDetailViewController(viewModel: viewModel)
        detailVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailVC,animated:true)
    }
}
