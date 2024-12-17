import Foundation

final class RMSearchInputViewViewModel{
    private let type: RMSearchViewController.Config.`Type`
    
    // Create the enum Type DynamicOption of type String Format
    enum DynamicOption:String{
        case status = "Status"
        case gender = "Gender"
        case locationType = "Location Type"
        
        var queryArgument:String{
            switch self{
            case .status: return "status"
            case .gender: return "gender"
            case .locationType: return "type"
            }
        }
        
        var choices: [String] {
            switch self {
            // Different case of status here
            case .status:
                return ["alive", "dead", "unknown"]
                
            // Different case of gender here
            case .gender:
                return ["male", "female", "genderless", "unknown"]
                
            // Different case of locationType here
            case .locationType:
                return ["cluster", "planet", "microverse"]
            }
        }
    }
    
    init(type: RMSearchViewController.Config.`Type`){
        self.type = type
    }
    
    // Mark - Public: Boolean Value of true or false
    public var hasDynamicOptions:Bool {
        switch self.type {
        case .character, .location:
            return true
        case .episode:
            return false
        }
    }
    
    public var options: [DynamicOption]{
        switch self.type{
        case .character:
            return[.status, .gender]
        case .location:
            return[.locationType]
        case .episode:
            return []
        }
    }
    // Creating the searchPlaceholderText which is of the String Type
    public var searchPlaceholderText: String {
        
        // Using the switch self.type Here Method
        switch self.type{
    
        // Creating the 3 Different Cases Here
        case .character:
            return "Character Name"
        case .location:
            return "Location Name"
        case .episode:
            return "Episode Title"
        }
    }
}


