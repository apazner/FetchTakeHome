//
//  ContentView.swift
//  FetchTakeHome
//
//  Created by Adam on 2/2/24.
//

import SwiftUI

struct MealsData: Codable {
    var meals: [Meal]
}

struct Meal: Codable {
    let strMeal: String
    let strMealThumb: String
    let idMeal: String
}

struct DessertItemRow: View {
    let imageURL: String
    let title: String
    var body: some View {
        return HStack {
            AsyncImage(url: URL(string: imageURL)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 100, height: 100)
            Text(title)
        }
    }
}

struct ContentView: View {
    
    @State var data: MealsData?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading) {
                    if let data = data {
                        let meals = data.meals
                        ForEach(meals, id: \.idMeal) { meal in
                            DessertItemRow(imageURL: meal.strMealThumb, title: meal.strMeal)
                        }
                    }
                }
            }
            .padding()
            .onAppear {
                let baseURL = "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert"
                guard let url = URL(string: baseURL) else {
                    return
                }
                URLSession.shared.getData(for: url) { (result: Result<MealsData, Error>) in
                    switch result {
                    case .success(let data):
                        self.data = data
                    case .failure(let error):
                        print(error)
                    }
                }
            }
            .navigationTitle("Desserts")
        }
        
    }
}

#Preview {
    ContentView()
}
