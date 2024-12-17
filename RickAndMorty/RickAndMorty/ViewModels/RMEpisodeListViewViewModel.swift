import UIKit

protocol RMEpisodeListViewViewModelDelegate: AnyObject {
    func didLoadInitialEpisodes()
    func didLoadMoreEpisodes(with newIndexPaths:[IndexPath])
    func didSelectEpisode(_ episode:RMEpisode)
}

//ViewModel to Handle the Episode List View Logic
final class RMEpisodeListViewViewModel: NSObject {
    // Creating the delegate function here
    // Using the public class make the delegate Accessible
    public weak var delegate: RMEpisodeListViewViewModelDelegate?
    
    private var isLoadingMoreCharacters = false
    
    private let borderColors:[UIColor] = [
        .systemGreen,.systemBlue,.systemOrange,.systemPink,.systemPurple,.systemRed,
        .systemYellow,.systemIndigo,.systemMint
    ]
    
    
    // Collection of RMEpisode Here In the Array
    private var episodes: [RMEpisode] = [] {
        didSet {
            // Looping using the for loop in characters where the viewModels Does not Exist
            for episode in episodes{
                let viewModel = RMCharacterEpisodeCollectionViewCellViewModel(
                    episodeDataUrl:URL(string:episode.url),
                    // Creating the Random Colors Here using randomElement() Function
                    borderColor:borderColors.randomElement() ?? .systemBlue
                    )
                    
                    
                if !cellViewModels.contains(viewModel){
                    cellViewModels.append(viewModel)
                }
            }
        }
    }
    
    
    // Creating the Groups of Characters Collections using the private variable
    // called the cellViewModels and initiate to be Empty Array
    private var cellViewModels: [RMCharacterEpisodeCollectionViewCellViewModel] = []
    
    private var apiInfo: RMGetAllEpisodesResponse.Info? = nil
    
    // Creating the public function fetchEpisodes Here
    // Fetch Initial Set Of Episodes(20) using public func fetchEpisodes
    public func fetchEpisodes(){
        // This will allowed you to fetch the requests
        RMService.shared.execute(request:.listEpisodesRequest,
                                 expecting:RMGetAllEpisodesResponse.self
        ){[weak self] result in
            switch result {
            case .success(let responseModel):
                let results = responseModel.results
                let info = responseModel.info
                self?.episodes = results
                self?.apiInfo = info
                DispatchQueue.main.async{
                    self?.delegate?.didLoadInitialEpisodes()
                }
                
            case .failure(let error):
                print(String(describing:error))
                
            }
        }
        
    }
    
    // Paginate if ADDITIONAL CHARACTERS are needed
    // FETCH Additional Episodes If Required
    public func fetchAdditionalEpisodes(url: URL){
        
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
        
        RMService.shared.execute(request:request, expecting: RMGetAllEpisodesResponse.self) {[weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .success(let responseModel):
                    let moreResults = responseModel.results
                    let info = responseModel.info
                    
                    strongSelf.apiInfo = info
                
                    let originalCount = strongSelf.episodes.count
                    let newCount = moreResults.count
                    let total = originalCount + newCount
                    let startingIndex = total - newCount
                    let indexPathsToAdd: [IndexPath] = Array(startingIndex..<(startingIndex + newCount)).compactMap({
                    return IndexPath(row:$0, section:0)
                    })
                    
                    strongSelf.episodes.append(contentsOf: moreResults)
                    // Using the disPatchQueue Method Here
                    DispatchQueue.main.async{
                        strongSelf.delegate?.didLoadMoreEpisodes(with:indexPathsToAdd
                        )
                        strongSelf.isLoadingMoreCharacters = false
                    }
                    
            case .failure(let failure):
                print(String(describing: failure))
                self?.isLoadingMoreCharacters = false
            }
        }
    }
    
    
    // Boolean to shouldShowLoadMoreIndicator: true or false
    public var shouldShowLoadMoreIndicator: Bool {
        // Optional Chaining in Swift Programming Here
        return apiInfo?.next != nil
    }
    
}
              
    


// This is the CollectionView
extension RMEpisodeListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Configure the cells with data from the Character Array
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier,
        for: indexPath
        ) as? RMCharacterEpisodeCollectionViewCell else {
            fatalError("Unsupported Cell")
        }
        cell.configure(with:cellViewModels[indexPath.row])
        return cell
    }
    
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
    
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard shouldShowLoadMoreIndicator else {
            return .zero
        }
        return CGSize(width:collectionView.frame.width,height:100)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = collectionView.bounds
        let width = bounds.width-20
        return CGSize(width:width , height: 100
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let selection = episodes[indexPath.row]
        delegate?.didSelectEpisode(selection)
    }
}


// Mark - ScrollView
extension RMEpisodeListViewViewModel: UIScrollViewDelegate {
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
                self?.fetchAdditionalEpisodes(url:url)
            }
            t.invalidate()
            
        }
        
    }
}
