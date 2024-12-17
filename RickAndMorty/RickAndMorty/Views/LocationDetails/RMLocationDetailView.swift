import UIKit

protocol RMLocationDetailViewDelegate:AnyObject {
    func rmEpisodeDetailView(
        _ detailView: RMLocationDetailView, didSelect character:RMCharacter
    )
}


final class RMLocationDetailView:UIView {
    
public weak var delegate:RMLocationDetailViewDelegate?

// Create the var viewModel of type RMLocationDetailViewViewModel
private var viewModel: RMLocationDetailViewViewModel? {
    didSet {
        spinner.stopAnimating()
        self.collectionView?.reloadData()
        self.collectionView?.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.collectionView?.alpha = 1
        }
    }
}

// Create the var collectionView of type UICollectionView
private var collectionView: UICollectionView?

// It is used to show that SOMETHING IS LOADING or SPINNING
// or PROCESSING in the Background Environment
private let spinner: UIActivityIndicatorView = {
    let spinner = UIActivityIndicatorView()
    spinner.translatesAutoresizingMaskIntoConstraints = false
    spinner.hidesWhenStopped = true
    // Returning the spinner here
    return spinner
}()

// Mark: - Init
// Creating the override init keyword
override init(frame: CGRect) {
    super.init(frame: frame)
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = .systemBackground
    // Invoking the func createCollectionView and STORING IT
    // into the Variable collectionView
    let collectionView = createCollectionView()
    // Creating the addSubViews called collectionview and spinner
    addSubviews(collectionView, spinner)
    self.collectionView = collectionView
    // Invoking the addConstraints() Functionality
    addConstraints()
    // The spinner will startAnimating() Here Itself
    spinner.startAnimating()
}

// Using the required init keyword
required init?(coder: NSCoder) {
   fatalError("Unsupported")
}
// Mark as private func here
// Creating addConstraints func here
private func addConstraints(){
    guard let collectionView = collectionView else {
        return
    }
    NSLayoutConstraint.activate([
        spinner.heightAnchor.constraint(equalToConstant:100),
        spinner.widthAnchor.constraint(equalToConstant:100),
        spinner.centerXAnchor.constraint(equalTo:centerXAnchor),
        spinner.centerYAnchor.constraint(equalTo:centerYAnchor),
        
        collectionView.topAnchor.constraint(equalTo:topAnchor),
        collectionView.leftAnchor.constraint(equalTo:leftAnchor),
        collectionView.rightAnchor.constraint(equalTo:rightAnchor),
        collectionView.bottomAnchor.constraint(equalTo:bottomAnchor)
        
    ])
}

private func createCollectionView()-> UICollectionView{
    let layout = UICollectionViewCompositionalLayout{section, _ in
        return self.layout(for:section)
    }
    let collectionView = UICollectionView(frame:.zero, collectionViewLayout:layout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.isHidden = true
    collectionView.alpha = 0
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(RMEpisodeInfoCollectionViewCell.self, forCellWithReuseIdentifier:RMEpisodeInfoCollectionViewCell.cellIdentifier)
    collectionView.register(RMCharacterCollectionViewCell.self, forCellWithReuseIdentifier:RMCharacterCollectionViewCell.cellIdentifier)
    return collectionView
}

// Create the public func configure method
public func configure(with viewModel:RMLocationDetailViewViewModel){
    self.viewModel = viewModel
    
}

}

extension RMLocationDetailView: UICollectionViewDelegate, UICollectionViewDataSource{
func numberOfSections(in collectionView: UICollectionView) -> Int {
    return viewModel?.cellViewModels.count ?? 0
}
// This will allowed you to have Partial or Full View by returning either 1 or 10:
func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let sections = viewModel?.cellViewModels else {
        return 0
    }
    let sectionType = sections[section]
    
    // Using the switch method for sectionType Here
    switch sectionType{
    // There are 2 DIFFERENT CASES: .information and .characters
    case .information(let viewModels):
        return viewModels.count
    case .characters(let viewModels):
        return viewModels.count
    }
}

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    guard let sections = viewModel?.cellViewModels else {
        fatalError("No viewModel")
    }
    let sectionType = sections[indexPath.section]
    
    // Using the switch method for sectionType Here
    switch sectionType{
        
    // There are 2 DIFFERENT CASES: .information and .characters
    case .information(let viewModels):
        // Creating the Variable called cellViewModel here
        let cellViewModel = viewModels[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:RMEpisodeInfoCollectionViewCell.cellIdentifier,for:indexPath) as? RMEpisodeInfoCollectionViewCell else {
            fatalError()
        }
        cell.configure(with:cellViewModel)
        return cell
        
    case .characters(let viewModels):
        let cellViewModel = viewModels[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:RMCharacterCollectionViewCell.cellIdentifier,for:indexPath) as? RMCharacterCollectionViewCell else {
            fatalError()
        }
        cell.configure(with:cellViewModel)
        return cell
    }
    
}

func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
    guard let viewModel = viewModel else {
        return
    }
    
    let sections = viewModel.cellViewModels
        
    let sectionType = sections[indexPath.section]
    
    // Using the switch method for sectionType Here
    switch sectionType{
        
    // There are 2 DIFFERENT CASES: .information and .characters
    case .information:
       break
        
    case .characters:
        guard let character = viewModel.character(at:indexPath.row) else {
            return
        }
        delegate?.rmEpisodeDetailView(self, didSelect: character)
    }
}
}

// Create the extension RMLocationDetailView Here
extension RMLocationDetailView {

func layout(for section: Int)->NSCollectionLayoutSection {
    guard let sections = viewModel?.cellViewModels else {
        return createInfoLayout()
    }
    
    switch sections[section] {
    case .information:
        return createInfoLayout()
    case .characters:
        return createCharacterLayout()
    }
    
}
func createInfoLayout()->NSCollectionLayoutSection{
    // Create item Variable Here
    let item = NSCollectionLayoutItem(layoutSize:.init(widthDimension:.fractionalWidth(1), heightDimension: .fractionalHeight(1)))
    
    // CREATE Gap In Between the Section for the top, leading, bottom and trailing properties
    // using the contentInsets Properties
    item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
    
    // Create group Variable Here
    // Creating the widthDimension and heightDimension Here
    let group = NSCollectionLayoutGroup.vertical(layoutSize:.init(widthDimension:.fractionalWidth(1), heightDimension:.absolute(80)), subitems:[item])
    
    // Create section Variable Here
    let section = NSCollectionLayoutSection(group: group)
    
    return section
}


func createCharacterLayout()->NSCollectionLayoutSection{
    // Creating the NSCollectionLayoutItem Here
    let item = NSCollectionLayoutItem(
        layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(UIDevice.isiPhone ? 0.5:0.25),
            heightDimension: .fractionalHeight(1.0) // Taking Up the Full Height
        )
    )
    
    item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
    // Vertical View Of the Layout
    let group = NSCollectionLayoutGroup.horizontal(
        layoutSize: NSCollectionLayoutSize(
            // Dynamically Changing the Width Dimension HERE
            widthDimension: .fractionalWidth(1.0),  // Full Width for the Group using fractionalWidth
            // Setting the heightDimension HERE
            heightDimension: .absolute(UIDevice.isiPhone ? 260:320)
            // which is 150
        ),
        // Using the Ternary Conditional Operator for Iphone Device and also for Other Devices
        subitems: UIDevice.isiPhone ? [item,item] : [item, item, item, item]
    )
    let section = NSCollectionLayoutSection(group:group)
    
    // Return the section here
    return section
}
}

