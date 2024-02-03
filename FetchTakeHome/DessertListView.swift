//
//  ContentView.swift
//  FetchTakeHome
//
//  Created by Adam on 2/2/24.
//

import SwiftUI

struct DessertListView: View {
    
    @StateObject var mealModel: MealModel = MealModel()
    
    var body: some View {
        NavigationStack {
            List(mealModel.filteredMealData) { meal in
                NavigationLink {
                    DessertDetailView(id: meal.id)
                } label: {
                    DessertListRow(imageURL: meal.strMealThumb, title: meal.strMeal)
                }
            }
            .searchable(text: $mealModel.search)
            // Note that an odd error (this application... passed an invalid numeric...)
            // comes up when holding down on the search bar, seems to be a bug on apple's side
            // https://forums.developer.apple.com/forums/thread/738726
            .navigationTitle("Desserts")
        }
        .onAppear() {
            mealModel.getMealData()
        }
        .environmentObject(mealModel)
        
    }
    
}

#Preview {
    DessertListView()
}
