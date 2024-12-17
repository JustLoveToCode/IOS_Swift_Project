import Foundation


// Creating the class RMService Here
final class RMService{
    
    // Creating the Singleton Shared Instance
    static let shared = RMService()
    
    private let cacheManager = RMAPICacheManager()
    
    // Privatized Constructor
    private init() {}
    enum RMServiceError:Error {
        case failedToCreateRequest
        case failedToGetData
        
        
    }
    // Send the Rick and Morty API Calls
    // _request represent the Request Instance, type represent the
    // type of object we expect to get back, completion represent the Callback
    // either with the data or error
    // RMService.shared.execute Method here
    public func execute<T:Codable>(request:RMRequest,expecting type: T.Type,
                                   completion:@escaping(Result<T,Error>)->Void)
    {
        // cachedResponse is a public func here
        if let cachedData = cacheManager.cachedResponse(
            for:request.endpoint,
            url:request.url
        )
        // Creating the do catch Block here in the functionality
        // Decode the response
        {
            do{
                let result = try JSONDecoder().decode(type.self,from:cachedData)
                print("Using Cached API Response")
                completion(.success(result))
            }
            catch{
                completion(.failure(error))
            }
            return
        }
        
        guard let urlRequest = self.request(from:request) else {
            // Getting the enum here which is RMServiceError.failedToCreateRequest
            completion(.failure(RMServiceError.failedToCreateRequest))
            return
        }
        let task = URLSession.shared.dataTask(with:urlRequest){[weak self] data,_,error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? RMServiceError.failedToGetData))
                return
            }
            // Using the do and catch method here
            // there is jsonObject method related to JSONSerialization Method
            do{
                // Creating the JSON Object with the Data
                let result = try JSONDecoder().decode(type.self, from: data)
                self?.cacheManager.setCache(for: request.endpoint, url: request.url, data: data)
                completion(.success(result))
            
            }
            catch{
                completion(.failure(error))
                
            }
        }
        task.resume()
    }
    
    // Mark: Private URL
    // RMRequest is stored in the rmRequest Variable
    private func request(from rmRequest:RMRequest)->URLRequest?{
        // Using the guard keyword to end the closure early if there is no url
        // The url is actually from the rmRequest.url
        guard let url = rmRequest.url else {return nil}
        var request = URLRequest(url:url)
        request.httpMethod = rmRequest.httpMethod
        
        return request
    }
}
