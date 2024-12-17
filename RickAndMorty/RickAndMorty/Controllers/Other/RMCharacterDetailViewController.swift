import UIKit


/// Controllers to show info about the Single Character
final class RMCharacterDetailViewController: UIViewController {
    private let viewModel: RMCharacterDetailViewViewModel
    
    // Invoking the RMCharacterDetailView Functionality Here:
    private let detailView: RMCharacterDetailView
    
    // Mark: - Init 
    
    init(viewModel:RMCharacterDetailViewViewModel){
        self.viewModel = viewModel
        self.detailView = RMCharacterDetailView(frame:.zero, viewModel:viewModel)
        super.init(nibName:nil, bundle:nil)
    }
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    // Mark: Lifecycle Function
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = viewModel.title
        view.addSubview(detailView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem:.action,
                                                            target: self,
                                                            action: #selector(didTapShare))
        addConstraints()
        detailView.collectionView?.delegate = self
        detailView.collectionView?.dataSource = self
     
    }

    @objc
    private func didTapShare(){
        // Share Characters Info
        
    }
    
    private func addConstraints(){
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor),
            detailView.leftAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leftAnchor),
            detailView.rightAnchor.constraint(equalTo:view.safeAreaLayoutGuide.rightAnchor),
            detailView.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

// Mark: CollectionView
extension RMCharacterDetailViewController:UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = viewModel.sections[section]
        switch sectionType {
        case .photo:
            return 1
        case .information(let viewModels):
            return viewModels.count
        case .episodes(let viewModels):
            return viewModels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = viewModel.sections[indexPath.section]
        switch sectionType{
        case .photo(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:RMCharacterPhotoCollectionViewCell.cellIdentifier,for: indexPath) as? RMCharacterPhotoCollectionViewCell else{
                fatalError()
            }
            // Using the cell.configure to configure the viewModels
            cell.configure(with:viewModel)
            return cell
        case .information(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:RMCharacterInfoCollectionViewCell.cellIdentifier,for: indexPath) as? RMCharacterInfoCollectionViewCell else{
                fatalError()
            }
            // Using the cell.configure to configure the viewModels
            cell.configure(with:viewModels[indexPath.row])
            return cell
        case .episodes(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:RMCharacterEpisodeCollectionViewCell.cellIdentifier,for: indexPath) as? RMCharacterEpisodeCollectionViewCell else{
                fatalError()
            }
            let viewModel = viewModels[indexPath.row]
            // Using the cell.configure to configure the viewModels
            cell.configure(with:viewModel)
            return cell
        }
    }
    
    func collectionView(_ collectionView:UICollectionView,didSelectItemAt indexPath:IndexPath){
        let sectionType = viewModel.sections[indexPath.section]
        // Using the switch statement to Create Different Cases here
        switch sectionType{
        case .photo,.information:
            break
        case .episodes:
            let episodes = self.viewModel.episodes
            let selection = episodes[indexPath.row]
            let vc = RMEpisodeDetailViewController(url:URL(string:selection))
            navigationController?.pushViewController(vc, animated:true)
        }
    }
}