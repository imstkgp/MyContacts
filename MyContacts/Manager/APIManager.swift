//
//  APIManager.swift
//  MyContacts
//
//  Created by mmt5885 on 08/08/19.
//  Copyright © 2019 Santosh Tewari. All rights reserved.
//

import Foundation

public enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
}

final class APIManager {
    class func getContactList(complition: @escaping (Result<([Contact]), Error>) -> Void) {
        var request = URLRequest.init(url: URL.init(string: Constant.URL.contactsURL)!)
        request.httpMethod = HTTPMethod.get.rawValue
        
        let task = URLSession.shared.dataTask(with: request) { (result) in
            switch result {
            case .success( _, let data):
                do {
                    let jsonDecoder = JSONDecoder()
                    let contactList = try jsonDecoder.decode([Contact].self, from: data)
                    complition(.success(contactList))
                }
                catch {
                    complition(.failure(error))
                }
                break
            case .failure(let error):
                complition(.failure(error))
                break
            }
        }
        task.resume()
    }
    
    class func getContactDetail(contactUrl:String, complition: @escaping (Result<(Contact), Error>) -> Void) {
        var request = URLRequest.init(url: URL.init(string: contactUrl)!)
        request.httpMethod = HTTPMethod.get.rawValue
        
        let task = URLSession.shared.dataTask(with: request) { (result) in
            switch result {
            case .success( _, let data):
                do {
                    let jsonDecoder = JSONDecoder()
                    let contactList = try jsonDecoder.decode(Contact.self, from: data)
                    complition(.success(contactList))
                }
                catch {
                    complition(.failure(error))
                }
                break
            case .failure(let error):
                complition(.failure(error))
                break
            }
        }
        task.resume()
    }
    
    class func updateContactDetail(contactUrl:String, parameters:[String: Any] ,complition: @escaping (Result<(Contact), Error>) -> Void) {
        var headers = [String:String] ()
        headers["content-type"] = "application/json"
    
        let body = try? JSONSerialization.data(withJSONObject: parameters, options: [])
    
        var request = URLRequest.init(url: URL.init(string: contactUrl)!)
        request.httpMethod = HTTPMethod.put.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        
        let task = URLSession.shared.dataTask(with: request) { (result) in
            switch result {
            case .success( _, let data):
                do {
                    let jsonDecoder = JSONDecoder()
                    let contactList = try jsonDecoder.decode(Contact.self, from: data)
                    complition(.success(contactList))
                }
                catch {
                    complition(.failure(error))
                }
                break
            case .failure(let error):
                complition(.failure(error))
                break
            }
        }
        task.resume()
    }
}


extension URLSession {
    func dataTask(with request: URLRequest, result: @escaping (Result<(URLResponse, Data), Error>) -> Void) -> URLSessionDataTask {
        return dataTask(with: request) { (data, response, error) in
            if let error = error {
                result(.failure(error))
                return
            }
            guard let response = response, let data = data else {
                let error = NSError(domain: "error", code: 0, userInfo: nil)
                result(.failure(error))
                return
            }
            result(.success((response, data)))
        }
    }
}
