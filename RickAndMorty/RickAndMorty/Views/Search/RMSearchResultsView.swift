import UIKit

// Creating the protocol RMSearchResultsViewDelegate of AnyObject
protocol RMSearchResultsViewDelegate:AnyObject {
    func rmSearchResultsView(_ resultsView:RMSearchResultsView, didTapLocationAt index:Int)
    func rmSearchResultsView(_ resultsView:RMSearchResultsView, didTapCharacterAt index:Int)
    func rmSearchResultsView(_ resultsView:RMSearchResultsView, didTapEpisodeAt index:Int)
}


// Show Search Result UI(Table or Collection as Needed)
// This is creating RMSearchResultsView of type UIView Here
final class RMSearchResultsView: UIView {
    
    // This is from the protocol RMSearchResultsViewDelegate
    weak var delegate: RMSearchResultsViewDelegate?
    
    // Create private var viewModel of type RMSearchResultViewModel?
    private var viewModel:RMSearchResultViewModel?{
        // Using the didSet Method HERE
        didSet{
            self.processViewModel()
        }
    }
    
    
    // Create the tableView of type UITableView Here
    private let tableView:UITableView = {
        let table = UITableView()
        table.register(RMLocationTableViewCell.self,
                       forCellReuseIdentifier:RMLocationTableViewCell.cellIdentifier)
        table.isHidden = true
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    
    private let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        // This is the Spacing For the Layout for the Search Result HERE
        layout.sectionInset = UIEdgeInsets(top:10, left:10, bottom:10, right:10)
        
        let collectionView = UICollectionView(frame:.zero, collectionViewLayout: layout)
        collectionView.isHidden = true
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        // Using collectionView.register Here
        collectionView.register(RMCharacterCollectionViewCell.self,
                                forCellWithReuseIdentifier:
                                 RMCharacterCollectionViewCell.cellIdentifier)
        
        // Using collectionView.register Here
        collectionView.register(RMCharacterEpisodeCollectionViewCell.self,
                                forCellWithReuseIdentifier:RMCharacterEpisodeCollectionViewCell.cellIdentifier)
        
        // Using collectionView.register Here
        // Footer for Loading
        collectionView.register(RMFooterLoadingCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier)
        // return collectionView Here
        return collectionView
        
    }()
    
    // TableView viewModels
    private var locationCellViewModels:[RMLocationTableViewCellViewModel] = []
    
    // CollectionView ViewModels
    private var collectionViewCellViewModels:[any Hashable] = []
    
  
    
    // Mark - Init
    // Using the override init method here
    override init(frame: CGRect){
        super.init(frame:frame)
        isHidden = true
        translatesAutoresizingMaskIntoConstraints = false
        // Creating the addSubviews(tableView, collectionView) Here
        addSubviews(tableView,collectionView)
        // Using the addConstraints() Method Here
        addConstraints()
    }
    
    // Using the required init? METHOD HERE
    required init?(coder:NSCoder){
        fatalError()
    }
    
    // Create the private func processViewModel
    private func processViewModel(){
        // Using the guard method for the viewModel Here
        guard let viewModel = viewModel else {
            return
        }
        // Using the switch method for viewModel
        // let viewModels stored inside the Different case
        switch viewModel.results {
        // Using the Different case Here
        case .characters(let viewModels):
            self.collectionViewCellViewModels = viewModels
            // Invoking the func setUpCollectionView() Here
            setUpCollectionView()
        case .locations(let viewModels):
            setUpTableView(viewModels:viewModels)
        case .episodes(let viewModels):
            self.collectionViewCellViewModels = viewModels
            setUpCollectionView()
        }
    }
    // Create private func setUpCollectionView Here
    private func setUpCollectionView(){
        self.tableView.isHidden = true
        self.collectionView.isHidden = false
        // Setting up the delegate and dataSource which is
        // equal to self.
        collectionView.delegate = self
        collectionView.dataSource = self
        // Reload the Data Here
        collectionView.reloadData()
    }
    
    // Create private func setUpTableView Here
    private func setUpTableView(viewModels:[RMLocationTableViewCellViewModel]){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = false
        collectionView.isHidden = true
        self.locationCellViewModels = viewModels
        tableView.reloadData()
        
    }
    
    // Create the private func addConstraints here for the tableView
    private func addConstraints(){
        // Creating the NSLayoutConstraint.activate
        NSLayoutConstraint.activate([
            // Getting the topAnchor, leftAnchor, bottomAnchor, rightAnchor HERE
            tableView.topAnchor.constraint(equalTo:topAnchor),
            tableView.leftAnchor.constraint(equalTo:leftAnchor),
            tableView.bottomAnchor.constraint(equalTo:bottomAnchor),
            tableView.rightAnchor.constraint(equalTo:rightAnchor),
            
            collectionView.topAnchor.constraint(equalTo:topAnchor),
            collectionView.leftAnchor.constraint(equalTo:leftAnchor),
            collectionView.rightAnchor.constraint(equalTo:rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo:bottomAnchor)
        ])
    }
    // Create the public func configure here
    public func configure(with viewModel:RMSearchResultViewModel){
        // Using self.viewModel = viewModel
        self.viewModel = viewModel
    }

}

// Mark - TableView using the EXTENSION RMSearchResultsView Here
extension RMSearchResultsView: UITableViewDataSource, UITableViewDelegate {
    
    // Using numberOfRowsInSection for func tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationCellViewModels.count
    }
    
    // Using cellForRowAt for func tableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:RMLocationTableViewCell.cellIdentifier,
                                                       for:indexPath) as? RMLocationTableViewCell else {
            fatalError("Failed to Dequeue RMLocationTableViewCell")
        }
        // Using the cell.configure method here
        cell.configure(with:locationCellViewModels[indexPath.row])
        return cell
    }
    
    // Using didSelectRowAt for func tableView here
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.rmSearchResultsView(self, didTapLocationAt:indexPath.row)
    }
}


// Mark - CollectionView, Using the extension of RMSearchResultsView Here
extension RMSearchResultsView: UICollectionViewDelegate, UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout{
    // Creating the Properties called numberOfItemsInSection Here
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewCellViewModels.count
    }
    // Using the cellForItemAt Properties Here
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let currentViewModel = collectionViewCellViewModels[indexPath.row]
        
        if let characterVM = currentViewModel as? RMCharacterCollectionViewCellViewModel {
            // Character Cell
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier, for: indexPath
            ) as? RMCharacterCollectionViewCell else {
                fatalError()
            }
            // Using the configure keyword Here
            cell.configure(with:characterVM)
            return cell
            
        }
        // Episode Cell
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier, for: indexPath) as?
                RMCharacterEpisodeCollectionViewCell else{
            fatalError()
        }
        if let episodeVM = currentViewModel as? RMCharacterEpisodeCollectionViewCellViewModel{
            cell.configure(with:episodeVM)
        }
        return cell
    }
    
    // Using the didSelectItemAt Properties Here
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        // Handling the Cell Tap
        guard let viewModel = viewModel else {
            return
        }
        // Using the switch method for viewModel
        // let viewModels stored inside the Different case
        switch viewModel.results {
        // Using the Different case Here
        case .characters:
            delegate?.rmSearchResultsView(self, didTapCharacterAt: indexPath.row)
        case .episodes(let viewModels):
            delegate?.rmSearchResultsView(self, didTapEpisodeAt: indexPath.row)
        case .locations:
            break
        }
        
    }
        
        
        func collectionView(_ collectionView:UICollectionView,layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath:IndexPath)->CGSize{
            let currentViewModel = collectionViewCellViewModels[indexPath.row]
            // Create the bounds Variable which is equal to collectionView.bounds Here
            let bounds = collectionView.bounds
            // If it is getting the RMCharacterCollectionViewCellViewModel
            if currentViewModel is RMCharacterCollectionViewCellViewModel {
                // Character Size: Setting the Size Here
                // Setting the UIDevice Settings Here
                let width = UIDevice.isiPhone ? (bounds.width - 30)/2:(bounds.width-50)/4
                return CGSize(width:width, height:width*1.5)
                
            }
            
            // Episode Size: Setting the Size Here
            // This will Create 2 Columns on the Episode Search Result
            let width = UIDevice.isiPhone ? bounds.width - 20 : (bounds.width-50)/4
            return CGSize(width:width, height:100
            )
        }
    // Using the viewForSupplementaryElementOfKind Properties
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter,
              let footer = collectionView.dequeueReusableSupplementaryView(ofKind:kind, withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier, for: indexPath) as? RMFooterLoadingCollectionReusableView else
                {
                  fatalError("UnSupported")
                }
        if let viewModel = viewModel, viewModel.shouldShowLoadMoreIndicator{
            footer.startAnimating()
        }
       
        return footer
    }
    
    
    // Using the referenceSizeForFooterInSection Properties
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard let viewModel = viewModel,
                viewModel.shouldShowLoadMoreIndicator else {
            return .zero
        }
        return CGSize(width:collectionView.frame.width,height:100)
    }
    
}



// Mark - ScrollViewDelegate
// Using extension RMLocationView of type UIScrollViewDelegate Here
extension RMSearchResultsView:UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView:UIScrollView){
        if !locationCellViewModels.isEmpty{
            handleLocationPagination(scrollView:scrollView)
        } else {
            // CollectionView
            handleCharacterOrEpisodePagination(scrollView:scrollView)
        }
 }
    
    // Create private func handleCharacterEpisodePagination with the UIScrollView Here
    private func handleCharacterOrEpisodePagination(scrollView:UIScrollView){
        
        guard let viewModel = viewModel,
              !collectionViewCellViewModels.isEmpty,
              viewModel.shouldShowLoadMoreIndicator,
              !viewModel.isLoadingMoreResults else {
            return
        }
            // The Timer will wait 0.2s before EXECUTING the CODE
            // Using the Timer.scheduledTimer HERE
                    Timer.scheduledTimer(withTimeInterval:0.2, repeats: false) {[weak self] t in
                        let offset = scrollView.contentOffset.y
                        let totalContentHeight = scrollView.contentSize.height
                        let totalScrollViewFixedHeight = scrollView.frame.size.height
        
                        if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120){
                            viewModel.fetchAdditionalResults{[weak self] newResults in
                                
                                // Using Unwrapping METHOD Here
                                guard let strongSelf = self else {
                                    return
                                }
                                
                                // Using the DispatchQueue.main.async Method Here
                                DispatchQueue.main.async {
                                    
                                    //Setting the Spinner to NIL
                                    strongSelf.tableView.tableFooterView = nil

                                    
                                    let originalCount = strongSelf.collectionViewCellViewModels.count
                                    let newCount = (newResults.count - originalCount)
                                    let total = originalCount + newCount
                                    let startingIndex = total - newCount
                                     // We CREATE the Range from our Starting Index with the
                                     // startingIndex + newCount HERE
                                     let indexPathsToAdd:[IndexPath] = Array(startingIndex..<(startingIndex+newCount)).compactMap({
                                     // This is the IndexPath to be Returned HERE
                                     return IndexPath(row:$0, section:0)
                                     })

                                    
                                    // Setting the collectionViewCellViewModels to be newResults
                                    strongSelf.collectionViewCellViewModels = newResults
                                    
                                    // Using the Insert Method to insert the items into the collectionView
                                    strongSelf.collectionView.insertItems(at: indexPathsToAdd)
                                }
//                                let moreResults = responseModel.results
//                                let info = responseModel.info
//                                
//                                strongSelf.apiInfo = info
                            }
                        }
            // Using the t.invalidate()
            t.invalidate()
    }
}
    

    

// Creating private func handleLocationPagination
private func handleLocationPagination(scrollView: UIScrollView){
        guard let viewModel = viewModel,
              !locationCellViewModels.isEmpty,
              viewModel.shouldShowLoadMoreIndicator,
              !viewModel.isLoadingMoreResults else {
            return
        }
                    // The Timer will wait 0.2s before Executing the Code
                    // Using the Timer.scheduledTimer HERE
                    Timer.scheduledTimer(withTimeInterval:0.2, repeats: false) {[weak self] t in
                        let offset = scrollView.contentOffset.y
                        let totalContentHeight = scrollView.contentSize.height
                        let totalScrollViewFixedHeight = scrollView.frame.size.height
        
                        if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120){
                            // Using DispatchQueue.main.async METHOD HERE
                            DispatchQueue.main.async{
                                self?.showTableLoadingIndicator()
                            }
                            
                            viewModel.fetchAdditionalLocations{[weak self] newResults in
                                //Setting the Spinner to nil
                                self?.tableView.tableFooterView = nil
                                self?.locationCellViewModels = newResults
                                //Reload the Data
                                self?.tableView.reloadData()
                            }
                        }
            t.invalidate()
    }
}
    
    
    // Create private func showLoadingIndicator() Here
    private func showTableLoadingIndicator(){
    // Using RMTableLoadingFooterView Here
    let footer = RMTableLoadingFooterView(frame:CGRect(x:0, y: 0, width: frame.size.width, height: 100))
    tableView.tableFooterView = footer
    }
    
}



