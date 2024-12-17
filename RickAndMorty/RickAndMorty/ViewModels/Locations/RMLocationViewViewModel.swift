import Foundation


protocol RMLocationViewViewModelDelegate: AnyObject{
    func didFetchInitialLocations()
}

// Create the final class called RMLocationViewViewModel
final class RMLocationViewViewModel {
    // Create the weak var delegate of type RMLocationViewViewModelDelegate?
    weak var delegate: RMLocationViewViewModelDelegate?
    
    // This is the private var locations here
    private var locations:[RMLocation] = [] {
        // Using the didSet method Here
        didSet {
            // Using the for loop to Loop through the locations Here
            for location in locations{
                let cellViewModel = RMLocationTableViewCellViewModel(location:location)
                // If the cellViewModel Does Not Already Exist
                if !cellViewModels.contains(cellViewModel){
                    cellViewModels.append(cellViewModel)
                }
            }
        }
    }
    // This is the private var apiInfo here
    private var apiInfo: RMGetAllLocationsResponse.Info?
    
    
    // Location Response Info
    // Will Contain Next URL, If it is Present
    // This will contain the RMLocationTableViewCellViewModel
    public private(set) var cellViewModels:[RMLocationTableViewCellViewModel] = []
    
    // Create public var shouldShowLoadMoreIndicator Here
    public var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }
    // Create public var isLoadingMoreLocations which is false
    public var isLoadingMoreLocations = false
    
    // Create private var didFinishPagination which return Void
    private var didFinishPagination:(()->Void)?
    
    // Create the init Method Here
    // Mark - Init
    init(){}
    
    // Create public func registerDidFinishPaginationBlock Here
    public func registerDidFinishPaginationBlock(_ block:@escaping()->Void) {
        self.didFinishPagination = block
    }
    
    // Paginate if ADDITIONAL CHARACTERS are needed
    // FETCH Additional Locations If Required
    public func fetchAdditionalLocations(){
        
        guard !isLoadingMoreLocations else {
            return
        }
        
        // Get the Next Object of apiInfo Here
        guard let nextUrlString = apiInfo?.next,
              let url = URL(string:nextUrlString) else {
              return
        }
        
        // Using isLoadingMoreLocations to be true
        isLoadingMoreLocations = true
        
        
        guard let request = RMRequest(url:url) else {
            isLoadingMoreLocations = false
            print("Failed to Create Request")
            return
        }
        // Using the RMService.shared.execute method
        RMService.shared.execute(request:request, expecting: RMGetAllLocationsResponse.self) {[weak self] result in
            // Using the guard for strongSelf
            guard let strongSelf = self else {
                return
            }
            // Using the switch result
            switch result {
                
            // Using the case .success
            case .success(let responseModel):
                    let moreResults = responseModel.results
                    let info = responseModel.info
                    strongSelf.apiInfo = info
                // Using the compactMap method Here
                strongSelf.cellViewModels.append(contentsOf:moreResults.compactMap({
                    return RMLocationTableViewCellViewModel(location:$0)
                }))
                   // Using the disPatchQueue Method Here
                   DispatchQueue.main.async{
                    strongSelf.isLoadingMoreLocations = false
                    // Notify via callback
                    strongSelf.didFinishPagination?()
                   }
                
            // Using case .failure
            case .failure(let failure):
                print(String(describing: failure))
                self?.isLoadingMoreLocations = false
            }
        }
    }
    
    public func location(at index:Int) -> RMLocation?{
        guard index < locations.count, index>=0 else {
            return nil
        }
        
        return self.locations[index]
    }
    
    // Using the public func fetchLocations Here
    public func fetchLocations(){
        RMService.shared.execute(request:.listLocationsRequest,expecting: RMGetAllLocationsResponse.self){[weak self] result in
            // Using the switch for 2 Different Cases which is either success or failure
            switch result{
            case .success(let model):
                self?.apiInfo = model.info
                self?.locations = model.results
                DispatchQueue.main.async{
                    self?.delegate?.didFetchInitialLocations()
                }
            case .failure:
                // Handling the Errors
                break
            }
            
        }
    }
    // Creating the Boolean Value of hasMoreResults Variable
    private var hasMoreResults: Bool{
        return false
    }
}
