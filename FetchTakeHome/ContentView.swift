//
//  ContentView.swift
//  FetchTakeHome
//
//  Created by Adam on 2/2/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var data: MealsData?
    @State private var search: String = ""
    
    // Note that an odd error (this application... passed an invalid numeric...)
    // comes up when holding down on the search bar, seems to be a bug on apple's side
    // https://forums.developer.apple.com/forums/thread/738726
    private var filteredData: [Meal] {
        if let data = data {
            if search.isEmpty {
                return data.meals
            } else {
                return data.meals.filter { $0.strMeal.localizedCaseInsensitiveContains(search) }
            }
        }
        
        return []
    }
    
    var body: some View {
        NavigationSplitView {
            List {
                if data != nil {
                    ForEach(filteredData, id: \.idMeal) { meal in
                        NavigationLink {
                            DessertDetailView(id: meal.idMeal)
                        } label: {
                            DessertListRow(imageURL: meal.strMealThumb, title: meal.strMeal)
                        }
                    }
                } else {
                    ProgressView()
                        .controlSize(.large)
                }
            }
            .searchable(text: $search)
            .onAppear {
                apiRequest()
            }
            .navigationTitle("Desserts")
        } detail: {
            Text("Select a Dessert")
        }
        
    }
    
    private func apiRequest() {
        let baseURL = "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert"
        guard let url = URL(string: baseURL) else {
            print("URL Error.")
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
}

#Preview {
    ContentView()
}
