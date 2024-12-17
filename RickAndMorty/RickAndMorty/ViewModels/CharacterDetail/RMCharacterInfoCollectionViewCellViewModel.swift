import UIKit

final class RMCharacterInfoCollectionViewCellViewModel {
    private let type: `Type`
    private let value: String
    
    static let dateFormatter:DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSZ"
        formatter.timeZone = .current
        return formatter
    }()
    
    static let shortDateFormatter:DateFormatter = {
        // Format: Invoking the DateFormatter() Here
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.timeZone = .current
        return formatter
    }()
    
    
    
    // Creating the title Variable Here
    public var title: String {
        type.displayTitle
    }
    
    // Creating the variable displayValue of type String Format:
    public var displayValue: String {
        if value.isEmpty{
            return "None"
        }

        if let date = Self.dateFormatter.date(from:value), type == .created {
            return Self.shortDateFormatter.string(from:date)
        }
        return value
    }
    
    public var iconImage:UIImage?{
        return type.iconImage
    }
    
    public var tintColor: UIColor {
        return type.tintColor
    }
    
    
    
    // Creating the enum of Type
    enum `Type`:String {
        case status
        case gender
        case type
        case species
        case origin
        case created
        case location
        case episodeCount
        

        // Creating the tintColor which is of the type UIColor
        var tintColor: UIColor{
            switch self {
            case .status:
                return .systemBlue
            case .gender:
                return .systemRed
            case .type:
                return .systemPurple
            case .species:
                return .systemGreen
            case .origin:
                return .systemOrange
            case .created:
                return .systemPink
            case .location:
                return .systemYellow
            case .episodeCount:
                return .systemMint
            }
            
        }
        // Creating the iconImage which is of the type UIImage
        var iconImage: UIImage?{
            switch self {
            case .status:
                return UIImage(systemName:"bell")
            case .gender:
                return UIImage(systemName:"bell")
            case .type:
                return UIImage(systemName:"bell")
            case .species:
                return UIImage(systemName:"bell")
            case .origin:
                return UIImage(systemName:"bell")
            case .created:
                return UIImage(systemName:"bell")
            case .location:
                return UIImage(systemName:"bell")
            case .episodeCount:
                return UIImage(systemName:"bell")
            }
            
        }
        
        var displayTitle:String{
            switch self {
            case .status,.gender,.type,.species,.origin,.created,.location:
                return rawValue.uppercased()
            case .episodeCount:
                return "EPISODE COUNT"
            }
        }
        
    }
    
    
    
    init(type: `Type`, value: String
    ) {
        self.value = value
        self.type = type
    }
    
}
