//
//  Requester.swift
//  JavaKeywords
//
//  Created by Gabriel Conte on 28/02/20.
//  Copyright © 2020 Gabriel Conte. All rights reserved.
//

import Foundation

protocol RequestExecuter {
    static func execute<T: Codable>(router: Router, completion: @escaping (Result<T, Error>) -> ())
}

final class Requester: RequestExecuter {
    
    static func execute<T: Codable>(router: Router, completion: @escaping (Result<T, Error>) -> ()) {
        
        guard var url = URL(string: router.baseUrl) else {
            return
        }
        url.appendPathComponent(router.path)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = router.method
        
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: urlRequest) { data, response, error in
            
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            guard response != nil, let data = data else {
                return
            }
            
            do {
                let responseObject = try JSONDecoder().decode(T.self, from: data)
                completion(.success(responseObject))
            } catch let error {
                completion(.failure(error))
            }
        }
        dataTask.resume()
    }
}

