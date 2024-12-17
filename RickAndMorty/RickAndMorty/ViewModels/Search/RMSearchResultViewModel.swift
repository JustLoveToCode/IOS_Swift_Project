import Foundation

// Creating the class RMSearchResultViewModel Here
final class RMSearchResultViewModel {
    public private(set) var results: RMSearchResultType
    public var next: String?
    
    // Using the init method HERE
    init(results: RMSearchResultType,next:String?){
        self.results = results
        self.next = next
      
    }
    
    public private(set) var isLoadingMoreResults = false
    
    public var shouldShowLoadMoreIndicator:Bool{
        return next != nil
    }
    
    
    // Create public func fetchAdditionalLocations Here
    public func fetchAdditionalLocations(completion:@escaping([RMLocationTableViewCellViewModel])->Void){
        
        // Using !isLoadingMoreResults Method Here
        guard !isLoadingMoreResults else {
            return
        }
        
        // Get the Next Object of apiInfo Here
        guard let nextUrlString = next,
              let url = URL(string:nextUrlString) else {
              return
        }
        
        // Using isLoadingMoreLocations to be true
        isLoadingMoreResults = true
        
        
        guard let request = RMRequest(url:url) else {
        // If it is Not Loading More Result, set it back to false
            isLoadingMoreResults = false
            return
        }
        
        // Using the RMService.shared.execute method
        RMService.shared.execute(request:request, expecting: RMGetAllLocationsResponse.self) {[weak self] result in
            // Using the guard for strongSelf else return
            guard let strongSelf = self else {
                return
            }
            
            // Using the switch result HERE
            switch result {
                
            // Using the case .success
            case .success(let responseModel):
                 let moreResults = responseModel.results
                 let info = responseModel.info
                
                // Capture the new Pagination URLs
                strongSelf.next = info.next
                
                
                
                // Using the compactMap method HERE
                let additionalLocations = moreResults.compactMap({
                    return RMLocationTableViewCellViewModel(location:$0)
                })
                
                var newResults:[RMLocationTableViewCellViewModel] = []
                
                switch strongSelf.results{
                // Creating the 2 Different Cases
                // case .locations
                case .locations(let existingResults):
                    // You will need to append the additionalLocations to the existingResults
                    // Otherwise the Ordering of the Results will be INCORRECT:
                    newResults = existingResults + additionalLocations
                    strongSelf.results = .locations(newResults)
                    break
                    
                // case .characters and episodes
                case .characters,.episodes:
                    break
                }
                   // Using the DisPatchQueue Method Here
                   // Using DispatchQueue.main.async Method Here
                   DispatchQueue.main.async{
                    strongSelf.isLoadingMoreResults = false
                       
                    // Notify via callback, take in newResults
                    completion(newResults)
                   }
                
                
            // Using case .failure
            case .failure(let failure):
                print(String(describing: failure))
                self?.isLoadingMoreResults = false
            }
        }
    }
    
    
    
    
    
    
    
    
    
    // Create public func fetchAdditionalResults HERE
    public func fetchAdditionalResults(completion:@escaping([any Hashable])->Void){
        
        // Using !isLoadingMoreResults Method Here
        guard !isLoadingMoreResults else {
            return
        }
        
        // Get the Next Object of apiInfo Here
        // Get the Next URL Here
        guard let nextUrlString = next,
              let url = URL(string:nextUrlString) else {
              return
        }
        
        // Using isLoadingMoreLocations to be true
        isLoadingMoreResults = true
        
        // We tried to CREATE THE REQUEST with the url Here
        guard let request = RMRequest(url:url) else {
        // If it is Not Loading More Result, set it back to false
            isLoadingMoreResults = false
            return
        }
        
        switch results {
            
            
        // Using the case of characters
        case .characters(let existingResults):
            // Using the RMService.shared.execute METHOD
            RMService.shared.execute(request:request, expecting: RMGetAllCharactersResponse.self) {[weak self] result in
                // Using the guard for strongSelf else return
                guard let strongSelf = self else {
                    return
                }
                
                // Using the switch result
                switch result {
                // Using the case .success
                case .success(let responseModel):
                     let moreResults = responseModel.results
                     let info = responseModel.info
                    
                    // Capture the new Pagination URLs
                    strongSelf.next = info.next
                    
                    
                    // Using the compactMap method HERE and store
                    // inside the additionalResults
                    let additionalResults = moreResults.compactMap({
                        return RMCharacterCollectionViewCellViewModel(characterName:$0.name, characterStatus: $0.status, characterImageUrl: URL(string:$0.image))
                    })
                    // The RMCharacterCollectionViewCellViewModel is stored in the variable
                    // newResults and it is assigned Empty Array [ ]
                    var newResults:[RMCharacterCollectionViewCellViewModel] = []
                    
                    newResults = existingResults + additionalResults
                    strongSelf.results = .characters(newResults)
                    
                       // Using the disPatchQueue Method Here
                       // Using DispatchQueue.main.async Method Here
                       DispatchQueue.main.async{
                        strongSelf.isLoadingMoreResults = false
                           
                        // Notify via callback, take in newResults
                        completion(newResults)
                       }
                    
                // Using case .failure
                case .failure(let failure):
                    print(String(describing: failure))
                    self?.isLoadingMoreResults = false
                }
            }
            
            
        // Using the case of .episodes
        case .episodes(let existingResults):
            // Using the RMService.shared.execute METHOD
            RMService.shared.execute(request:request, expecting: RMGetAllEpisodesResponse.self) {[weak self] result in
                // Using the guard for strongSelf else return
                guard let strongSelf = self else {
                    return
                }
                
                // Using the switch result
                switch result {
                    
                // Using the case .success
                case .success(let responseModel):
                     let moreResults = responseModel.results
                     let info = responseModel.info
                    
                    // Capture the new Pagination URLs
                    strongSelf.next = info.next
                    
                    
                    
                    // Using the compactMap method HERE and store
                    // it into the additionalResults Variable
                    let additionalResults = moreResults.compactMap({
                        return RMCharacterEpisodeCollectionViewCellViewModel(episodeDataUrl:URL(string:$0.url))
                    })
                    
                    var newResults:[RMCharacterEpisodeCollectionViewCellViewModel] = []
                    // The additionalResults is added to the existingResults Here
                    newResults = existingResults + additionalResults
                    strongSelf.results = .episodes(newResults)
                    

                       // Using the disPatchQueue Method Here
                       // Using DispatchQueue.main.async Method Here
                       DispatchQueue.main.async{
                        strongSelf.isLoadingMoreResults = false
                           
                        // Notify via callback, take in newResults
                        completion(newResults)
                       }
                    
                // Using case .failure
                case .failure(let failure):
                    print(String(describing: failure))
                    self?.isLoadingMoreResults = false
                }
            }
        case .locations:
            // Tableview Case
            break
        }
        
    }
    
}
            







// Creating the enum RMSearchResultType Here
enum RMSearchResultType{
      case characters([RMCharacterCollectionViewCellViewModel])
      case episodes([RMCharacterEpisodeCollectionViewCellViewModel])
      case locations([RMLocationTableViewCellViewModel])
}
