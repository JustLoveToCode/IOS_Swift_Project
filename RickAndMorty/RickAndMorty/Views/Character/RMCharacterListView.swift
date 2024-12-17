import UIKit

protocol RMCharacterListViewDelegate: AnyObject {
    func rmCharacterListView(_ characterListView:RMCharacterListView,
    didSelectCharacter character: RMCharacter
    )
}

// View that Handle showing Lists of the Characters, Loader, etc
final class RMCharacterListView: UIView {
    
    public weak var delegate:RMCharacterListViewDelegate?
    
    private let viewModel = RMCharacterListViewViewModel()
    
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
        collectionView.register(RMCharacterCollectionViewCell.self,
                                forCellWithReuseIdentifier:
                                 RMCharacterCollectionViewCell.cellIdentifier)
        
        collectionView.register(RMFooterLoadingCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier)
        // return collectionView Here
        return collectionView
        
    }()
    // Using override init method Here
    override init(frame: CGRect){
        super.init(frame:frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(collectionView, spinner)
        // Adding the Constraints Here
        addConstraints()
        // Getting the Spinner to Start Animating
        spinner.startAnimating()
        viewModel.delegate = self
        viewModel.fetchCharacters()
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



extension RMCharacterListView: RMCharacterListViewViewModelDelegate {
    
    // Creating the func didSelectCharacter Here
    func didSelectCharacter(_ character:RMCharacter){
        delegate?.rmCharacterListView(self, didSelectCharacter: character)
    }
    
    // Creating the func didLoadInitialCharacters Here
    func didLoadInitialCharacters(){
        spinner.stopAnimating()
        collectionView.isHidden = false
        // Fetch the Initial Characters
        collectionView.reloadData()
        UIView.animate(withDuration:0.4){
            self.collectionView.alpha = 1
        }
    }
    
    // Create func didLoadMoreCharacters Here
    func didLoadMoreCharacters(with newIndexPaths:[IndexPath]){
        collectionView.performBatchUpdates{
            self.collectionView.insertItems(at:newIndexPaths)
        }
    }
    
    
}
    

