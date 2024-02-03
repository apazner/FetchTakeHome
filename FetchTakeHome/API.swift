//
//  API.swift
//  FetchTakeHome
//
//  Created by Adam on 2/2/24.
//

import Foundation

// dummy struct, api responses are nested in an object
struct MealsData: Decodable {
    var meals: [Meal]
}

struct Meal: Decodable {
    let idMeal: String
    let strMeal: String
    let strMealThumb: String
    
    // empty string if not present
    let strInstructions: String
    
    // dictionary of ingredients with corresponding measurement
    var ingredients: [String: String] = [:]
    
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

// custom decoding function - particularly for parsing ingredients/measurements
extension Meal {
    init(from decoder: Decoder) throws {
        
        // handle basic keys
        let values = try decoder.container(keyedBy: CodingKeys.self)
        idMeal = try values.decode(String.self, forKey: .idMeal)
        strMeal = try values.decode(String.self, forKey: .strMeal)
        strMealThumb = try values.decode(String.self, forKey: .strMealThumb)
        
        strInstructions = try values.decodeIfPresent(String.self, forKey: .strInstructions) ?? ""
        
        // decode ingredients and measurements
        
        // ingredient prefix
        let ingredientPrefix = "strIngredient"
        
        // measurment prefix
        let measurmentPrefix = "strMeasure"
        
        let dynamicValues = try decoder.container(keyedBy: DynamicCodingKeys.self)
        for key in dynamicValues.allKeys {
            
            // check if key is an ingredient
            if (!key.stringValue.contains(ingredientPrefix)) {
                continue
            }
            
            var ingredient = try dynamicValues.decodeIfPresent(String.self, forKey: key) ?? ""
            ingredient = ingredient.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // ingredient is null or empty, skip
            if (ingredient == "") {
                continue
            }
            
            // associated ingredient number
            let num = key.stringValue.suffix(key.stringValue.count - ingredientPrefix.count)
            
            // get the corresponding measurements key
            guard let measKey = DynamicCodingKeys(stringValue: measurmentPrefix + num) else {
                print("Ingredient does not have associated measurement.")
                continue
            }
            
            var measurement = try dynamicValues.decodeIfPresent(String.self, forKey: measKey) ?? ""
            measurement = measurement.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // measurement being null/empty at this point would be an error on the api side, but check just in case
            if (measurement != "") {
                // add pair to dictionary
                ingredients[ingredient] = measurement
            } else {
                print("Measurement value is empty.")
            }
        }
        
    }
}

// generic function to perform api fetch requests
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
