import Foundation

struct RMGetAllCharactersResponse: Codable {
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
        
    }
    // Info has the count, pages, next and prev Here
    let info: Info
    let results: [RMCharacter]
}
