//
//  ContentView.swift
//  FetchTakeHome
//
//  Created by Adam on 2/2/24.
//

import SwiftUI

struct ContentView: View {
    
    @State var data: MealsData?
    
    var body: some View {
        NavigationSplitView {
            List {
                if let data = data {
                    let meals = data.meals
                    ForEach(meals, id: \.idMeal) { meal in
                        NavigationLink {
                            DessertDetailView(id: meal.idMeal)
                            //DessertDetailView(id: "52768") - has nulls, good for testing
                        } label: {
                            DessertListRow(imageURL: meal.strMealThumb, title: meal.strMeal)
                        }
                    }
                } else {
                    ProgressView()
                        .controlSize(.large)
                }
            }
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
        } detail: {
            Text("Select a Dessert")
        }
        
    }
}

#Preview {
    ContentView()
}
