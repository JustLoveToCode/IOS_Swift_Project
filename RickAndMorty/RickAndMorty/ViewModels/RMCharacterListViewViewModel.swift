import UIKit


protocol RMCharacterListViewViewModelDelegate: AnyObject {
    // Invoke the Functionality didLoadInitialCharacters Here
    func didLoadInitialCharacters()
    // Invoke the Functionality didSelectCharacter Here
    func didSelectCharacter(_ character:RMCharacter)
    
    func didLoadMoreCharacters(with newIndexPaths:[IndexPath])
}

// View Model to Handle Character List View Logic
final class RMCharacterListViewViewModel: NSObject {
    // Creating the delegate function here
    // Using the public class make the delegate Accessible
    public weak var delegate: RMCharacterListViewViewModelDelegate?
    
    private var isLoadingMoreCharacters = false
    
    
    // Collection of RMCharacter Here In the Array
    private var characters: [RMCharacter] = [] {
        didSet {
            // Looping using the for loop in characters where the viewModels Does not Exist
            // Using the for loop to loop through characters
            for character in characters{
                // Creating the viewModel Variables
                let viewModel = RMCharacterCollectionViewCellViewModel(characterName: character.name, characterStatus: character.status, characterImageUrl: URL(string: character.image)
                )
                if !cellViewModels.contains(viewModel){
                    cellViewModels.append(viewModel)
                }
            }
        }
    }
    
    
    // Creating the Groups of Characters Collections using the private variable
    // called the cellViewModels and initiate to be Empty Array
    private var cellViewModels: [RMCharacterCollectionViewCellViewModel] = []
    
    private var apiInfo: RMGetAllCharactersResponse.Info? = nil
    
    // Creating the public function fetchCharacters Here
    // Fetch Initial Set Of Characters(20) using public func fetchCharacters
    public func fetchCharacters(){
        RMService.shared.execute(request:.listCharactersRequest,
                                 expecting:RMGetAllCharactersResponse.self
        ){[weak self] result in
            switch result {
            case .success(let responseModel):
                let results = responseModel.results
                let info = responseModel.info
                self?.characters = results
                self?.apiInfo = info
                DispatchQueue.main.async{
                    self?.delegate?.didLoadInitialCharacters()
                }
                
            case .failure(let error):
                print(String(describing:error))
                
            }
        }
        
    }
    
    // PAGINATE if ADDITIONAL CHARACTERS are needed
    // Fetch Additional Characters using fetchAdditionalCharacters func Here
    public func fetchAdditionalCharacters(url: URL){
        
        guard !isLoadingMoreCharacters else {
            return
        }
      
        isLoadingMoreCharacters = true
        print("Fetching More Characters")
        guard let request = RMRequest(url:url) else {
            isLoadingMoreCharacters = false
            print("Failed to Create Request")
            return
        }
        
        RMService.shared.execute(request:request, expecting: RMGetAllCharactersResponse.self) {[weak self] result in
            guard let strongSelf = self else {
                return
            }
            // Using switch result METHOD Here
            switch result {
            case .success(let responseModel):
                    let moreResults = responseModel.results
                    let info = responseModel.info
                    
                    strongSelf.apiInfo = info
                
                    let originalCount = strongSelf.characters.count
                    let newCount = moreResults.count
                    let total = originalCount + newCount
                    let startingIndex = total - newCount
                    let indexPathsToAdd: [IndexPath] = Array(startingIndex..<(startingIndex + newCount)).compactMap({
                    return IndexPath(row:$0, section:0)
                    })
                    
                    strongSelf.characters.append(contentsOf: moreResults)
                
                    // Using the disPatchQueue METHOD Here
                    DispatchQueue.main.async{
                        strongSelf.delegate?.didLoadMoreCharacters(with:indexPathsToAdd
                        )
                        strongSelf.isLoadingMoreCharacters = false
                    }
                    
            case .failure(let failure):
                print(String(describing: failure))
                self?.isLoadingMoreCharacters = false
            }
        }
    }
    // Boolean to shouldShowLoadMoreIndicator: true or false Here
    public var shouldShowLoadMoreIndicator: Bool {
        // Optional Chaining in Swift Programming Here
        return apiInfo?.next != nil
    }
    
}
              
    


// This is the CollectionView
extension RMCharacterListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    // Using the numberOfItemsInSection Properties
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    // Using the cellForItemAt Properties
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Configure the cells with data from the Character Array
        guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier,
        for: indexPath
        ) as? RMCharacterCollectionViewCell else {
            fatalError("Unsupported Cell")
        }
        cell.configure(with:cellViewModels[indexPath.row])
        return cell
    }
    // Using the viewForSupplementaryElementOfKind Properties
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter, shouldShowLoadMoreIndicator else {
            fatalError("Unsupported")
        }
        guard let footer = collectionView.dequeueReusableSupplementaryView(
            ofKind:kind, withReuseIdentifier:RMFooterLoadingCollectionReusableView.identifier, for: indexPath
        ) as? RMFooterLoadingCollectionReusableView else {
            fatalError("Unsupported")
        }
        footer.startAnimating()
        return footer
    }
    
    
    // Using the referenceSizeForFooterInSection Properties
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard shouldShowLoadMoreIndicator else {
            return .zero
        }
        return CGSize(width:collectionView.frame.width,height:100)
    }
    
    
    // Using the sizeForItemAt Properties
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // TODO: Abstract this to extension
        // let isIphone = UIDevice.current.userInterfaceIdiom == .phone
        
        let bounds = collectionView.bounds
        let width: CGFloat
        // Dynamically Displaying Based on Different Devices Sizes
        // If UIDevice.isIPhone Here
        // Accessing the isIPhone Property INSIDE UIDevice
        if UIDevice.isiPhone {
            width = (bounds.width-30)/2
        } else {
            // mac | ipad
            // Creating 4 Columns
            width = (bounds.width-50)/4
            
        }
        
        return CGSize(width:width , height: width * 1.5
        )
    }
    // Using the didSelectItemAt Properties
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let character = characters[indexPath.row]
        delegate?.didSelectCharacter(character)
    }
}


// Mark - ScrollView
extension RMCharacterListViewViewModel: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldShowLoadMoreIndicator,!isLoadingMoreCharacters,!cellViewModels.isEmpty,
              let nextUrlString = apiInfo?.next,
              let url = URL(string:nextUrlString)  else {
            return
        }
        // The Timer will wait 0.2s before Executing the Code
        Timer.scheduledTimer(withTimeInterval:0.2, repeats: false) {[weak self] t in
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height
            
            if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120){
                self?.fetchAdditionalCharacters(url:url)
            }
            t.invalidate()
        }
    }
}

