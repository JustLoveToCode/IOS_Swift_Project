import UIKit

// Making the enum CaseIterable
enum RMSettingsOption: CaseIterable{
    case rateApp
    case contactUs
    case terms
    case privacy
    case apiReference
    case viewSeries
    case viewCode
    
    var targetUrl: URL?{
        
        // Using the switch self Method here
        switch self {
        case .rateApp:
            return nil
        case .contactUs:
            return URL(string:"https://iosacademy.io")
        case .terms:
            return URL(string:"https://iosacademy.io/terms")
        case .privacy:
            return URL(string:"https://iosacademy.io/privacy")
        case .apiReference:
            return URL(string:"https://rickandmortyapi.com/documentation/#get-a-single-episode")
        case .viewSeries:
            return URL(string:"https://www.youtube.com")
        case .viewCode:
            return URL(string:"https://www.github.com")
        }
        
    }
    
    // Create the var displayTitle in the form of String Format
    // This is the String that will be DISPLAYED IN THE String Format
    var displayTitle:String{
        switch self {
        case .rateApp:
            return "Rate App"
        case .contactUs:
            return "Contact Us"
        case .terms:
            return "Terms Of Service"
        case .privacy:
            return "Privacy Policy"
        case .apiReference:
            return "API Reference"
        case .viewSeries:
            return "View Video Series"
        case .viewCode:
            return "View App Code"
        }
    }
    // Creating the UIColor Here
    // using the Variable iconContainerColor
    var iconContainerColor:UIColor {
        switch self {
        case .rateApp:
            return .systemBlue
        case .contactUs:
            return .systemGreen
        case .terms:
            return .systemRed
        case .privacy:
            return .systemYellow
        case .apiReference:
            return .systemOrange
        case .viewSeries:
            return .systemPurple
        case .viewCode:
            return .systemPink
        }
    }
    
    
    var iconImage:UIImage?{
        // Using the switch method
        switch self {
        case .rateApp:
            return UIImage(systemName:"star.fill")
        case .contactUs:
            return UIImage(systemName:"paperplane")
        case .terms:
            return UIImage(systemName:"doc")
        case .privacy:
            return UIImage(systemName:"lock")
        case .apiReference:
            return UIImage(systemName:"list.clipboard")
        case .viewSeries:
            return UIImage(systemName:"tv.fill")
        case .viewCode:
            return UIImage(systemName:"hammer.fill")
        }
    }
}
