//
//  APIManager.swift
//  MyContacts
//
//  Created by mmt5885 on 08/08/19.
//  Copyright © 2019 Santosh Tewari. All rights reserved.
//

import Foundation

final class APIManager {
    class func getContactList(complition: @escaping (Result<([Contact]), Error>) -> Void) {
        let url = URL.init(string: Constant.URL.contactsURL)!
        let task = URLSession.shared.dataTask(with: url) { (result) in
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
}


extension URLSession {
    func dataTask(with url: URL, result: @escaping (Result<(URLResponse, Data), Error>) -> Void) -> URLSessionDataTask {
        return dataTask(with: url) { (data, response, error) in
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
