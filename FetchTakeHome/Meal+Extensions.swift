//
//  Meal+Extensions.swift
//  FetchTakeHome
//
//  Created by Adam on 2/3/24.
//

import Foundation

extension Meal {
    
    /// Custom decoding function - particularly for parsing ingredients/measurements
    init(from decoder: Decoder) throws {
        
        // handle basic keys
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
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
