//
//  API.swift
//  FetchTakeHome
//
//  Created by Adam on 2/2/24.
//

import Foundation

struct MealsData: Decodable {
    var meals: [Meal]
}

struct Meal: Decodable {
    let idMeal: String
    let strMeal: String
    let strMealThumb: String
    
    // empty string if not present
    let strInstructions: String
    
    var ingredients: [String] = []
    var measurements: [String] = []
    
    enum CodingKeys: String, CodingKey {
        case idMeal, strMeal, strMealThumb, strInstructions
        
    }
    
    // dynamic coding key for ingredients and measurements, so we don't have to write a bunch of individual keys
    // (additionally values may increase/decrease from 20 in the future, this handles that)
    private struct DynamicCodingKeys: CodingKey {

        // Use for string-keyed dictionary
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }

        // Use for integer-keyed dictionary
        var intValue: Int?
        init?(intValue: Int) {
            // We are not using this
            return nil
        }
    }
}

extension Meal {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        idMeal = try values.decode(String.self, forKey: .idMeal)
        strMeal = try values.decode(String.self, forKey: .strMeal)
        strMealThumb = try values.decode(String.self, forKey: .strMealThumb)
        
        strInstructions = try values.decodeIfPresent(String.self, forKey: .strInstructions) ?? ""
        
        // decode ingredients and measurements
        let dynamicValues = try decoder.container(keyedBy: DynamicCodingKeys.self)
        for key in dynamicValues.allKeys {
            if (key.stringValue.contains("strIngredient")) {
                
                if let key = DynamicCodingKeys(stringValue: key.stringValue) {
                    let ingredient = try dynamicValues.decodeIfPresent(String.self, forKey: key) ?? ""
                    
                    if (ingredient != "") {
                        ingredients.append(ingredient)
                    }
                }
                
            } else if (key.stringValue.contains("strMeasure")) {
                
                if let key = DynamicCodingKeys(stringValue: key.stringValue) {
                    let measurement = try dynamicValues.decodeIfPresent(String.self, forKey: key) ?? ""
                    
                    if (measurement != "") {
                        measurements.append(measurement)
                    }
                }
                
            }
        }
        
    }
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
