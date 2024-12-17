import UIKit

final class RMCharacterDetailViewViewModel{
    private let character: RMCharacter
    
    public var episodes:[String]{
        character.episode
    }
    
    init(character:RMCharacter) {
        self.character = character
        setUpSections()
    }
    private func setUpSections(){
      
        sections = [
            .photo(viewModel:.init(imageUrl:URL(string:character.image))),
            .information(viewModels:[
                // Taking the properties from the RMCharacter Here
                .init(type:.status, value:character.status.text),
                .init(type:.gender, value:character.gender.rawValue),
                .init(type:.type, value:character.type),
                .init(type:.species,value:character.species),
                .init(type:.origin, value:character.origin.name),
                .init(type:.location,value:character.location.name),
                .init(type:.created,value:character.created),
                .init(type:.episodeCount,value:"\(character.episode.count)"),
            ]),
            
            // Using the compactMap method here
            .episodes(viewModels:character.episode.compactMap({
                return RMCharacterEpisodeCollectionViewCellViewModel(episodeDataUrl:URL(string:$0))
            }))
     ]
    }
    // Creating the enum of SectionType Here
    enum SectionType {
        case photo(viewModel:RMCharacterPhotoCollectionViewCellViewModel)
        case information(viewModels:[RMCharacterInfoCollectionViewCellViewModel])
        case episodes(viewModels:[RMCharacterEpisodeCollectionViewCellViewModel])
    }
    
    public var sections:[SectionType] = []
    
    private var requestUrl: URL? {
        // Getting the character.url in the Form of String Format
        return URL(string:character.url)
    }
    public var title: String{
        character.name.uppercased()
    }
    
    // Mark: Layouts:
    // Create Photo Section Layout Here
    public func createPhotoSectionLayout()-> NSCollectionLayoutSection{
        // Creating the NSCollectionLayoutItem Here
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),  // Take Up the Full Width
                heightDimension: .fractionalHeight(1.0) // Take Up the Full Height
            )
        )
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
        // Vertical View Of the Layout Settings
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),  // Full Width for the Group
                heightDimension: .fractionalHeight(0.5)
                // which is 150
            ),
            // The Group CONSIST of the Item
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group:group)
        
        // Return the section here
        return section
        
        
    }
    
    // Create the createInfoSectionLayout Layout Here
    public func createInfoSectionLayout()-> NSCollectionLayoutSection{
        // Creating the NSCollectionLayoutItem Here
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                // If the UIDevice.isiPhone it will be 0.5, Otherwise
                // it will be 0.25 Here
                widthDimension: .fractionalWidth(UIDevice.isiPhone ? 0.5 : 0.25),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        // Vertical View Of the Layout
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),  // Full Width for the Group using fractionalWidth
                heightDimension: .absolute(150)         // Fixed Height for the Group using absolute
                // which is 150
            ),
            // The Group CONSIST of the Item
            // If it is isiPhone, show [item,item], otherwise show [item, item, item, item]
            // How the Items will be displayed in the Iphone vs OTHER DEVICES
            subitems: UIDevice.isiPhone ? [item, item] : [item, item, item, item]
        )
        let section = NSCollectionLayoutSection(group:group)
        
        // Return the section here
        return section
        
        
    }
    // Create the Episode Section
    public func createEpisodeSectionLayout()-> NSCollectionLayoutSection{
        // Creating the NSCollectionLayoutItem Here
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),  // Take Up the Full Width
                heightDimension: .fractionalHeight(1.0) // Take Up the Full Height
            )
        )
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 8)
        // Vertical View Of the Layout
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                // Creating the Variation of Width Based on the UIDevice Specification
                widthDimension: .fractionalWidth(UIDevice.isiPhone ? 0.8 : 0.4),
                heightDimension: .absolute(150)         // Fixed Height for the Group
                // which is 150
            ),
            // The Group CONSIST of the Item
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group:group)
        // Creating the Horizontal Scrolling Behavior Here
        section.orthogonalScrollingBehavior = .groupPaging
        
        // Return the section here
        return section
    }
}
