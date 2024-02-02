//
//  API.swift
//  FetchTakeHome
//
//  Created by Adam on 2/2/24.
//

import Foundation

struct Constants {
    static let baseURL = "www.themealdb.com/api/json/v1/1/"
    
}

extension URLSession {
    func getData<T: Decodable> (for url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        self.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            
            if let data = data {
                do {
                    let obj = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(obj))
                } catch let decoderError {
                    completion(.failure(decoderError))
                }
            }
        }.resume()
    }
}
