//
//  API.swift
//  FetchTakeHome
//
//  Created by Adam on 2/2/24.
//

import Foundation

/// Dummy upper level struct, api responses are nested in an object
struct MealsData: Decodable {
    var meals: [Meal]
}

/// Encodes a meal object
struct Meal: Decodable, Hashable, Identifiable {
    let id: String
    let strMeal: String
    let strMealThumb: String
    
    /// Meal recipe string, empty string if not present
    let strInstructions: String
    
    /// Dictionary of ingredients with corresponding measurement
    var ingredients: [String: String] = [:]
    
    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case strMeal, strMealThumb, strInstructions
    }
    
    /// Dynamic coding key for ingredients and measurements, so we don't have to write a bunch of individual keys
    struct DynamicCodingKeys: CodingKey {
        
        // not using this
        var intValue: Int?
        init?(intValue: Int) {
            return nil
        }

        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
    }
}
