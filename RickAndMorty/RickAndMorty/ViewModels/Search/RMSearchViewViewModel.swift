import Foundation


// The Different Responsibilities
// Show Search Results
// Show No Result View
// Kick Off API Request

// Create the class RMSearchViewViewModel Here
final class RMSearchViewViewModel{
    let config:RMSearchViewController.Config
    
    // Create private variable optionMap Here
    // class RMSearchInputViewViewModel class with DynamicOption of type enum Here
    private var optionMap:[RMSearchInputViewViewModel.DynamicOption:String] = [:]
    
    // Let searchText to be Empty String INITIALLY
    private var searchText = ""
    
    // Create private variable optionMapUpdateBlock Here
    private var optionMapUpdateBlock:(((RMSearchInputViewViewModel.DynamicOption, String))->Void)?
    
    // Create private variable searchResultHandler to be of Void Type
    private var searchResultHandler:((RMSearchResultViewModel)->Void)?
    
    // Create the private variable noResultsHandler to be of Void Type
    private var noResultsHandler:(()->Void)?
    
    // Create the private variable searchResultModel which is of the Codable Type
    private var searchResultModel:Codable?
    
    
    
    // Mark: - Init
    init(config:RMSearchViewController.Config){
        self.config = config
    }

    // Mark: - Public
    // Create public func registerSearchResultHandler
    public func registerSearchResultHandler(_ block:@escaping (RMSearchResultViewModel)->Void){
        self.searchResultHandler = block
    }
    
    // Create public func registerNoResultsHandler Here
    public func registerNoResultsHandler(_ block:@escaping()->Void){
        self.noResultsHandler = block
    }
    // Create public func executeSearch
    public func executeSearch(){
        // Using the trimmingCharacters to Trim Out the WhiteSpaces
        // If there is No Search Text in the Search using ! Operator,
        // DO NOT SHOW any Results
        guard !searchText.trimmingCharacters(in:.whitespaces).isEmpty else {
            return
        }
        // Test Search Text
        // print("Search Text:\(searchText)")
        
        // The Query Params is of the Empty Array [] Here
        // Building the Arguments Here
        var queryParams:[URLQueryItem] = [
            URLQueryItem(name:"name", value:searchText.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed))
        ]
        
        // Create Request Based on Filter
        // https://rickandmortyapi.com/api/character/?name=rick&status=alive
        
        
        // Using the append method here and Add Options Here
        // Add Options Here
        queryParams.append(contentsOf:optionMap.enumerated().compactMap({_,element in
            let key:RMSearchInputViewViewModel.DynamicOption = element.key
            let value: String = element.value
            return URLQueryItem(name:key.queryArgument,value:value)
        }))
        
        // Creating the request called RMRequest
        let request = RMRequest(endpoint:config.type.endpoint,queryParameters: queryParams
        )
        // Using the switch config.type.endpoint Here
        // with the Different case HERE
        switch config.type.endpoint{
        // Using case .character
        case .character:
            makeSearchAPICall(RMGetAllCharactersResponse.self, request:request)
        // Using case .episode
        case .episode:
            makeSearchAPICall(RMGetAllEpisodesResponse.self, request:request)
        // Using case .location
        case .location:
            makeSearchAPICall(RMGetAllLocationsResponse.self, request:request)
            
        }
    }
    
    
    
    
    private func makeSearchAPICall<T:Codable>(_ type: T.Type, request:RMRequest){
        // Using RMService.shared.execute method here
        // Execute the request Here
        RMService.shared.execute(request:request, expecting:type){[weak self]result in
            // Notify View Of Results, No of Results or Error
            // Using the different switch case result method here
            switch result{
            // For case .success
            case .success(let model):
                self?.processSearchResults(model:model)
            // For case .failure
            case .failure:
                self?.handleNoResults()
                break
            }
        }
    }
    
    private func processSearchResults(model:Codable){
        var resultsVM:RMSearchResultType?
        var nextUrl: String?
        
        // Using if let, else if, and else Statement Here
        if let characterResults = model as? RMGetAllCharactersResponse{
            resultsVM = .characters(characterResults.results.compactMap({
                return RMCharacterCollectionViewCellViewModel(characterName: $0.name, characterStatus: $0.status, characterImageUrl: URL(string:$0.image))
            }))
            nextUrl = characterResults.info.next
        }
        
        else if let episodesResults = model as? RMGetAllEpisodesResponse{
            resultsVM = .episodes(episodesResults.results.compactMap({
                return RMCharacterEpisodeCollectionViewCellViewModel(episodeDataUrl:URL(string:$0.url))
            }))
            
            nextUrl = episodesResults.info.next
            
        }
        else if let locationsResults = model as? RMGetAllLocationsResponse {
            resultsVM = .locations(locationsResults.results.compactMap({
                return RMLocationTableViewCellViewModel(location:$0)
            }))
            nextUrl = locationsResults.info.next
           
        }
        if let results = resultsVM{
            self.searchResultModel = model
            let vm = RMSearchResultViewModel(results:results, next:nextUrl)
            self.searchResultHandler?(vm)
        } else{
            // FallBack Error
            handleNoResults()
        }
        
    }
    
    // Create private func handleNoResults
    private func handleNoResults(){
        print("No Result")
        noResultsHandler?()
    }
    // Creating the public func set here
    public func set(query text:String){
        self.searchText = text
    }
    // Creating the public func set here
    public func set(value:String, for option:RMSearchInputViewViewModel.DynamicOption){
        optionMap[option] = value
        let tuple = (option, value)
        optionMapUpdateBlock?(tuple)
    }
    
    // Create the public func registerOptionChangeBlock Here
    public func registerOptionChangeBlock(_ block:@escaping((RMSearchInputViewViewModel.DynamicOption, String))->Void){
        self.optionMapUpdateBlock = block
    }
    
    // Create the public func locationSearchResult Here
    public func locationSearchResult(at index:Int)->RMLocation?{
        // Create the guard let searchModel Here
        guard let searchModel = searchResultModel as? RMGetAllLocationsResponse else {
            return nil
        }
        return searchModel.results[index]
    }
    
    
    // Create the public func characterSearchResult Here
    public func characterSearchResult(at index:Int)->RMCharacter?{
        // Create the guard let searchModel Here
        guard let searchModel = searchResultModel as? RMGetAllCharactersResponse else {
            return nil
        }
        return searchModel.results[index]
    }
    
    // Create the public func episodeSearchResult Here
    public func episodeSearchResult(at index:Int)->RMEpisode?{
        // Create the guard let searchModel Here
        guard let searchModel = searchResultModel as? RMGetAllEpisodesResponse else {
            return nil
        }
        return searchModel.results[index]
    }
}
