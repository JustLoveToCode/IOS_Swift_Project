import UIKit

// Creating the struct RMSettingsCellViewModel Here with the Identifiable and Hashable Keyword
struct RMSettingsCellViewModel: Identifiable{
    
    // This will create Unique id for each RMSettingsCellViewModel Instance
    // Invoke the UUID() Instance to create Unique id for each RMSettingsCellViewModel Here
    let id = UUID()
    public let type:RMSettingsOption
    public let onTapHandler: (RMSettingsOption)->Void
    
    // Mark - Init
    init(type: RMSettingsOption, onTapHandler:@escaping(RMSettingsOption)->Void){
        self.type = type
        self.onTapHandler = onTapHandler
    }
    
    // Mark - Public
    public var image: UIImage?{
        // Returning the type.iconImage Property
        return type.iconImage
    }
    public var title:String {
        // Returning the type.displayTitle Property
        return type.displayTitle
    }
    public var iconContainerColor:UIColor{
        // Returning the type.iconContainerColor Property
        return type.iconContainerColor
    }
    
}
