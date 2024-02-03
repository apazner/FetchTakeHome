//
//  MealListModel.swift
//  FetchTakeHome
//
//  Created by Adam on 2/3/24.
//

import Foundation

class MealModel: ObservableObject {
    /// List of meals - simple, just id, thumburl, and name.
    @Published var meals: [Meal] = [Meal]()
    
    /// Current search term.
    @Published var search: String = ""
    
    /// Current detailed meal user is viewing - nil if detail view is closed.
    @Published var detailedMeal: Meal?
    
    /// Filter meal data for current search term.
    var filteredMealData: [Meal] {
        if search.isEmpty {
            return meals
        } else {
            return meals.filter { $0.strMeal.localizedCaseInsensitiveContains(search) }
        }
    }
    
    /// Retrieve basic meal data.
    /// Meals array will be populated with meals containing only id, thumburl, and name.
    func getMealData() {
        let baseURL = "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert"
        guard let url = URL(string: baseURL) else {
            print("URL Error.")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            do {
                if let data = data {
                    let result = try JSONDecoder().decode(MealsData.self, from: data)
                    DispatchQueue.main.async {
                        self.meals = result.meals
                    }
                }
            } catch (let error) {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    /// Retrieve detailed meal data.
    /// Detailed meal will be populated with additional detailed information.
    func getDetailedMealData(id: String) {
        let baseURL = "https://themealdb.com/api/json/v1/1/lookup.php?i=\(id)"
        guard let url = URL(string: baseURL) else {
            print("URL Error.")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            do {
                if let data = data {
                    let result = try JSONDecoder().decode(MealsData.self, from: data)
                    DispatchQueue.main.async {
                        self.detailedMeal = result.meals[0]
                    }
                }
            } catch (let error) {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
}
