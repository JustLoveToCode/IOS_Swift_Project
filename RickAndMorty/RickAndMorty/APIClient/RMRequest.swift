import Foundation

// Object that represent the Single API Call
final class RMRequest{
    // API Constants
    private struct Constants {
        // Creating a private struct with the static keyword, tied to the class
        // and not to the instance of the class, RMRequest.Constants.baseURL
        // this mean that baseURL can only be accessed inside the RMRequest
        // and not the outside, final keyword mean that it cannot be subclassed
        static let baseUrl = "https://rickandmortyapi.com/api"
        
    }
        // Desired Endpoint
        let endpoint:RMEndpoint
    
        // Path Components for API, if any
        private let pathComponents: [String]
    
        // Query Arguments for API, if any
        private let queryParameters: [URLQueryItem]
        
        // Constructed url for the API Request in String Format
        private var urlString:String{
            var string = Constants.baseUrl
            string += "/"
            string += endpoint.rawValue
            
            if !pathComponents.isEmpty {
            pathComponents.forEach({
            string += "/\($0)"
              })
            }
            
            if !queryParameters.isEmpty{
            string+="?"
                let argumentString = queryParameters.compactMap({
                // Using the guard keyword to actually skip it if it is nil
                    guard let value = $0.value else {return nil}
                    return "\($0.name)=\(value)"
                // Using the joined method to join the separator
                }).joined(separator:"&")
                // argumentString that will be returned here once the separator is used
                // on the string
                string += argumentString
            }
            // This is what will be returned eventually: Final result
            return string
        }
        // Computed and Constructed API Url
        // The final URL is stored in the Variable url Here
        public var url:URL?{
            return URL(string:urlString)
        }
        // Desired HTTP Method
        public let httpMethod = "GET"
    
        // Construct Request
        public init(
            // Creating the init method for the Different Properties
            endpoint:RMEndpoint, // Target endpoint
            pathComponents: [String] = [], // Collection of pathComponents
            queryParameters:[URLQueryItem] = [] // Collection of queryParameters
        ){
            // Initiating the properties to the result
            self.endpoint = endpoint
            self.pathComponents = pathComponents
            self.queryParameters = queryParameters
        }
    // Attempt to create request
    // Parameter url: URL to Parse
    convenience init?(url:URL){
        let string = url.absoluteString
        if !string.contains(Constants.baseUrl){
            return nil
        }
        let trimmed = string.replacingOccurrences(of: Constants.baseUrl + "/", with: "")
        if  trimmed.contains("/"){
            let components = trimmed.components(separatedBy: "/")
            if !components.isEmpty {
                let endpointString = components[0] // Endpoints
                var pathComponents:[String] = []
                if components.count > 1 {
                    pathComponents = components
                    pathComponents.removeFirst()
                    
                }
                if let rmEndpoint = RMEndpoint(rawValue: endpointString
                                               ){
                    self.init(endpoint:rmEndpoint, pathComponents: pathComponents)
                    return
                }
            }
            
        } else if trimmed.contains("?") {
            let components = trimmed.components(separatedBy: "?")
            if !components.isEmpty, components.count>=2 {
                let endpointString = components[0]
                let queryItemsString = components[1]
                let queryItems:[URLQueryItem] = queryItemsString.components(separatedBy: "&").compactMap{
                    guard $0.contains("=") else {
                        return nil
                    }
                    let parts = $0.components(separatedBy: "=")
                    return URLQueryItem(
                        name:parts[0],
                        value:parts[1])
                    
                }
                
                //value = name & value = name
                if let rmEndpoint = RMEndpoint(rawValue: endpointString){
                    self.init(endpoint:rmEndpoint, queryParameters: queryItems)
                    return
                }
            }
            
        }
        return nil
    }
}

extension RMRequest{
    static let listCharactersRequest = RMRequest(endpoint:.character)
    static let listEpisodesRequest = RMRequest(endpoint:.episode)
    static let listLocationsRequest = RMRequest(endpoint: .location)
}
    

