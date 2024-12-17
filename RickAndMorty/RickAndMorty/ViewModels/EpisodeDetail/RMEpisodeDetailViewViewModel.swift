import UIKit

// Introducing the Delegate Here
protocol RMEpisodeDetailViewViewModelDelegate:AnyObject{
    func didFetchEpisodeDetails()
}

// Creating the class called RMEpisodeDetailViewViewModel Here
final class RMEpisodeDetailViewViewModel{
    
    private let endpointUrl:URL?
    
    // Mark: Init
    private var dataTuple:(episode:RMEpisode,characters:[RMCharacter])? {
        // Using the didSet Method Here
        didSet {
            createCellViewModels()
            delegate?.didFetchEpisodeDetails()
        }
    }
    
    enum SectionType {
        case information(viewModels:[RMEpisodeInfoCollectionViewCellViewModel])
        case characters(viewModel:[RMCharacterCollectionViewCellViewModel])
    }
    
    public weak var delegate: RMEpisodeDetailViewViewModelDelegate?
    
    public private(set) var cellViewModels:[SectionType] = []
    
    
    // Creating the init functionality
    init(endpointUrl:URL?){
        self.endpointUrl = endpointUrl
    }
    
    public func character(at index:Int)->RMCharacter?{
        guard let dataTuple = dataTuple else {
            return nil
        }
        return dataTuple.characters[index]
    }
    
    
    // Mark as Private func createCellViewModels
    private func createCellViewModels(){
        guard let dataTuple = dataTuple else {
            return
        }
        
        let episode = dataTuple.episode
        let characters = dataTuple.characters
        
        // Create the variable called createdString with Empty String ""
        var createdString = episode.created
        
        // Created the variable called createdDate Here
        if let date = RMCharacterInfoCollectionViewCellViewModel.dateFormatter.date(from:episode.created){
            createdString = RMCharacterInfoCollectionViewCellViewModel.shortDateFormatter.string(from:date)
        }
        
        cellViewModels = [
            .information(viewModels:[
                .init(title:"Episode Name", value:episode.name),
                .init(title:"Air Date", value:episode.air_date),
                .init(title:"Episode", value:episode.episode),
                .init(title:"Created", value:createdString)
            ]),
            // Using the compactMap method, $0 is the FIRST ELEMENT
            .characters(viewModel:characters.compactMap({ character in
                return RMCharacterCollectionViewCellViewModel(characterName:character.name, characterStatus: character.status, characterImageUrl:URL(string:character.image)
                )
            }))
        ]
    }
    
    // Fetch Backing Episode Model using fetchEpisodeData private func
    public func fetchEpisodeData(){
        guard let url = endpointUrl,
        let request = RMRequest(url:url) else {
            return
        }
        RMService.shared.execute(request: request, expecting: RMEpisode.self){[weak self] result in
            // Using the switch method for result
            switch result{
            case .success(let model):
                // This is used to call the private func fetchRelatedCharacters
                self?.fetchRelatedCharacters(episode:model)
            case .failure:
                break
            }
            
        }
    }
    // func fetchRelatedCharacters function here
    private func fetchRelatedCharacters(episode:RMEpisode){
        // Using the compactMap method
        let requests:[RMRequest] = episode.characters.compactMap({
            return URL(string:$0)
        // Using the compactMap method here to return RMRequest Here
        }).compactMap({
            return RMRequest(url:$0)
        })
        // 10 of PARALLELS REQUESTS Simultaneously All At Once
        // Notified Once All is COMPLETED HERE
        let group = DispatchGroup()
        // This start off as an Empty Array
        var characters:[RMCharacter] = []
        // Looping through requests using for and getting each request
        // using the for loop to loop through the requests here
        for request in requests{
            // This will Increment the Operation by + 20 for Example
            group.enter()
            // Using RMService.shared.execute method
            RMService.shared.execute(
                request:request, expecting:RMCharacter.self){result in
                    // The defer keyword is telling us this is the Last Instance
                    // that the CodeBlock will Run Through
                    defer{
                    // This will Decrement by 20 or - 20 for Example
                        group.leave()
                    }
                    // Using the switch result here
                    // with the case of success or failure:
                    switch result{
                    case .success(let model):
                        // characters is initially Empty Array Here []
                        // using the Append method to append the model
                        characters.append(model)
                    case .failure:
                       break
                    }
            }
        }
        
        // Using the group.notify() method here
        group.notify(queue:.main){
            self.dataTuple = (
            // episode has the RMEpisode and characters has the RMCharacter
                episode:episode,characters:characters
            )
            
        }
    }
}
