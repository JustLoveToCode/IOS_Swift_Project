import UIKit

// Controllers to search and show the Location
final class RMLocationViewController: UIViewController, RMLocationViewViewModelDelegate, RMLocationViewDelegate{
    
    // Invoking the primaryView Called RMLocationView() Here
    private let primaryView = RMLocationView()
    
    // Invoking the viewModel Variable called RMLocationViewViewModel() Here
    private let viewModel = RMLocationViewViewModel()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Adding the addSubview Here
        view.addSubview(primaryView)
        primaryView.delegate = self
        view.backgroundColor = .systemBackground
        title = "Location"
        addSearchButton()
        addConstraints()
        viewModel.delegate = self
        viewModel.fetchLocations()
    }
    
    private func addSearchButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }
    
    private func addConstraints(){
        NSLayoutConstraint.activate([
            primaryView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor),
            primaryView.leftAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leftAnchor),
            primaryView.rightAnchor.constraint(equalTo:view.safeAreaLayoutGuide.rightAnchor),
            primaryView.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    @objc
    private func didTapSearch(){
        let vc = RMSearchViewController(config: .init(type:.location))
        navigationController?.pushViewController(vc,animated:true)
    }
    // Mark: RMLocationViewDelegate
    func rmLocationView(_ locationView:RMLocationView, didSelect location:RMLocation){
        let vc = RMLocationDetailViewController(location:location)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    // Mark: LocationViewModel Delegate
    func didFetchInitialLocations(){
        primaryView.configure(with:viewModel)
    }
}
