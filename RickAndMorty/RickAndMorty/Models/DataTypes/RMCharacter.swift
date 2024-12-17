import Foundation


// Codable: Decode and Deserialize the JSON Data
struct RMCharacter: Codable{
    let id: Int
    let name: String
    let species: String
    let status: RMCharacterStatus
    let type: String
    let gender: RMCharacterGender
    let origin: RMOrigin
    let location: RMSingleLocation
    let image: String
    let episode: [String]
    let url: String
    let created: String
}


