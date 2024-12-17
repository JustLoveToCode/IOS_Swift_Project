

import UIKit

protocol RMEpisodeListViewDelegate: AnyObject {
    // Creating the func rmEpisodeListView Here
    func rmEpisodeListView(_ characterListView:RMEpisodeListView,
    didSelectEpisode episode: RMEpisode
    )
}

// View that Handle showing Lists of the Episodes, Loaders
// and it is of the type UIView Here
final class RMEpisodeListView: UIView {
    
    public weak var delegate:RMEpisodeListViewDelegate?
    
    private let viewModel = RMEpisodeListViewViewModel()
    
    // This is used to Create the Spinner Setting Here
    private let spinner:UIActivityIndicatorView = {
        // Creating the spinner here with the style of large
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    private let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top:0, left:10, bottom:10, right:10)
        
        let collectionView = UICollectionView(frame:.zero, collectionViewLayout: layout)
        collectionView.isHidden = true
        // This is the Opacity that is set to 0
        collectionView.alpha = 0
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(RMCharacterEpisodeCollectionViewCell.self,
                                forCellWithReuseIdentifier:
                                    RMCharacterEpisodeCollectionViewCell.cellIdentifier)
        
        collectionView.register(RMFooterLoadingCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier)
        // return collectionView Here
        return collectionView
        
    }()
    
    override init(frame: CGRect){
        super.init(frame:frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(collectionView, spinner)
        // Adding the Constraints Here
        addConstraints()
        // Getting the Spinner to Start Animating
        spinner.startAnimating()
        viewModel.delegate = self
        viewModel.fetchEpisodes()
        setUpCollectionView()
    }
    
    required init?(coder:NSCoder){
        fatalError("UnSupported")
    }
    
    // Creating the Visual Layout of the Spinner
    private func addConstraints(){
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo:centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo:centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo:topAnchor),
            collectionView.leftAnchor.constraint(equalTo:leftAnchor),
            collectionView.rightAnchor.constraint(equalTo:rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo:bottomAnchor),
            
        ])
    }
    // How Many Items should be Displayed
    // What contents should be Displayed
    private func setUpCollectionView(){
        collectionView.dataSource = viewModel
        collectionView.delegate = viewModel
    }
}



extension RMEpisodeListView: RMEpisodeListViewViewModelDelegate {
  
    // Creating the func didLoadInitialCharacters Here
    // with initially loading the data
    func didLoadInitialEpisodes(){
        spinner.stopAnimating()
        collectionView.isHidden = false
        // Fetch the Initial Characters
        collectionView.reloadData()
        UIView.animate(withDuration:0.4){
            self.collectionView.alpha = 1
        }
    }
    
    func didLoadMoreEpisodes(with newIndexPaths:[IndexPath]){
        collectionView.performBatchUpdates{
            self.collectionView.insertItems(at:newIndexPaths)
        }
    }
    
    func didSelectEpisode(_ episode: RMEpisode) {
        delegate?.rmEpisodeListView(self,didSelectEpisode:episode)
    }
    
}
