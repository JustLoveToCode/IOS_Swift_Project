import UIKit

// View for Single Character Info
final class RMCharacterDetailView: UIView {
    
    public var collectionView: UICollectionView?
    
    
    private let viewModel:RMCharacterDetailViewViewModel
    
    
    private let spinner:UIActivityIndicatorView = {
        // Creating the Spinner of the style:.large Here
        let spinner = UIActivityIndicatorView(style:.large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    // MARK: Init
    init(frame: CGRect,viewModel:RMCharacterDetailViewViewModel) {
        self.viewModel = viewModel
        super.init(frame:frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemPurple
        let collectionView = createCollectionView()
        self.collectionView = collectionView
        addSubviews(collectionView, spinner)
        addConstraints()
        
    }
    required init(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    private func addConstraints(){
        // the collectionView must be Unwrapped Before it is used in the Code Block Below
        // since it is Nullable
        guard let collectionView = collectionView else {
            return
        }
        
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant:100),
            spinner.centerXAnchor.constraint(equalTo:centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo:centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo:rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo:bottomAnchor)
        ])
        
    }
    private func createCollectionView()->UICollectionView {
        let layout = UICollectionViewCompositionalLayout{sectionIndex,_ in
            return self.createSection(for:sectionIndex)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(RMCharacterPhotoCollectionViewCell.self,
                                forCellWithReuseIdentifier:RMCharacterPhotoCollectionViewCell.cellIdentifier)
        collectionView.register(RMCharacterInfoCollectionViewCell.self,
                                forCellWithReuseIdentifier:RMCharacterInfoCollectionViewCell.cellIdentifier)
        collectionView.register(RMCharacterEpisodeCollectionViewCell.self,
                                forCellWithReuseIdentifier:RMCharacterEpisodeCollectionViewCell.cellIdentifier)
        
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
        
    }
    private func createSection(for sectionIndex: Int) -> NSCollectionLayoutSection {
        
        let sectionTypes = viewModel.sections
        // Create the switch statement with 3 Different Cases
        switch sectionTypes[sectionIndex]{
        case .photo:
            return viewModel.createPhotoSectionLayout()
        case .information:
            return viewModel.createInfoSectionLayout()
        case .episodes:
            return viewModel.createEpisodeSectionLayout()
        }
    }
}
