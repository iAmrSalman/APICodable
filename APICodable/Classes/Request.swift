//
//  Request.swift
//  APICodable
//
//  Created by Amr Salman on 12/17/17.
//

import Foundation
import Dots

class Request<Base: APIBase, ReturnType: Returnable> {
    
    //MARK: - Aliases
    
    public typealias Success = (_ returnValue: ReturnType) -> Void
    public typealias Failure = (_ reason: String) -> Void
    
    //MARK: - Properties
    
    var success: Success?
    var failure: Failure?
    
    var requestMethod: HTTPMethod
    //FIXME: - Add your base url
    var path: String
    var parameters: [String: Any]?
    var completeURL: String {
        return Base.baseURL + path
    }
    
    //MARK: - Initiazlizers
    
    public init(_ method: HTTPMethod,
                path: String,
                parameters: [String : Any]? = nil) {
        self.requestMethod = method
        self.parameters = parameters
        self.path = path
    }
    
    //MARK: - Actions
    
    func perform(onSuccess: Success? = nil, onFaild: Failure? = nil) {
        
        self.success = onSuccess ?? self.success
        self.failure = onFaild ?? self.failure
        
        let rechability = Reachability()
        switch rechability.connectionStatus() {
        case .Unknown, .Offline:
            
            return
        case .Online(.WWAN), .Online(.WiFi):
            Dots.defualt.request(completeURL, method: requestMethod, parameters: parameters, encoding: .json, headers: Base.headers, concurrency: .sync, qualityOfService: .userInitiated, complitionHandler: { (dot: Dot) in
                
                if let error = dot.error {
                    if error._code == URLError.timedOut.rawValue {
                        
                    }
                    self.failure?(error.localizedDescription)
                    return
                }
                
                if let response = dot.response as? HTTPURLResponse, let data = dot.data {
                    if !(200..<300).contains(response.statusCode) {
                        self.failure?(HTTPURLResponse.localizedString(forStatusCode: response.statusCode))
                        return
                    }
                    
                    do {
                        let returnValue = try ReturnType.init(from: data)
                        self.success?(returnValue)
                        return
                    } catch {
                        self.failure?(error.localizedDescription)
                        return
                    }
                    
                }
                
            })
        }
    }
    
    //MARK: - Helpers
    
    @discardableResult
    open func onSuccess(_ success: Success?) -> Request {
        self.success = success
        return self
    }
    
    @discardableResult
    open func onFailure(_ failure: Failure?) -> Request {
        self.failure = failure
        return self
    }
    
    //MARK: - Alternative Initializers
    
    static func GET(_ path: String,
                    parameters: [String : Any]? = nil) -> Request {
        let request = Request<Base, ReturnType>(.get, path: path, parameters: parameters)
        request.perform()
        return request
    }
    
    static func POST(_ path: String,
                     parameters: [String : Any]? = nil) -> Request {
        let request = Request<Base, ReturnType>(.post, path: path, parameters: parameters)
        request.perform()
        return request
    }
    
    static func PUT(_ path: String,
                    parameters: [String : Any]? = nil) -> Request {
        let request = Request<Base, ReturnType>(.put, path: path, parameters: parameters)
        request.perform()
        return request
    }
    
    static func DELETE(_ path: String,
                       parameters: [String : Any]? = nil) -> Request {
        let request = Request<Base, ReturnType>(.get, path: path, parameters: parameters)
        request.perform()
        return request
    }
}
