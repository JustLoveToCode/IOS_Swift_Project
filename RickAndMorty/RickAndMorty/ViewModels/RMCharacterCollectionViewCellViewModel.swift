import Foundation

// Mark - Create the Hashable and Equatable Here
final class RMCharacterCollectionViewCellViewModel: Hashable, Equatable {
    // Public Properties representing Character name, Status and Image URL
    public let characterName:String
    private let characterStatus:RMCharacterStatus
    private let characterImageUrl:URL?
    

    
    init(
        // Initialising the Properties for the
        // characterName, characterStatus and characterImageUrl
        characterName: String,
        characterStatus:RMCharacterStatus,
        characterImageUrl:URL?
    ){
        // Assigning the values to properties using the self keyword
        self.characterName = characterName
        self.characterStatus = characterStatus
        self.characterImageUrl = characterImageUrl
        
    }
    
    public var characterStatusText: String{
        return "Status:\(characterStatus.text)"
    }
    
    public func fetchImage(completion:@escaping(Result<Data, Error>)->Void){
        // Abstract to Image Manager
        guard let url = characterImageUrl else {
            completion(.failure(URLError(.badURL)))
            return
        }

        RMImageLoader.shared.downloadImage(url, completion:completion)
         
    }
   // Hashable: Ensure that it will not repeat itself
    static func == (lhs:RMCharacterCollectionViewCellViewModel, rhs:RMCharacterCollectionViewCellViewModel)->
    Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher){
        hasher.combine(characterName)
        hasher.combine(characterStatus)
        hasher.combine(characterImageUrl)
    }
  
}
