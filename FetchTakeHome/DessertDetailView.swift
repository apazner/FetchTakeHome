//
//  DessertDetailView.swift
//  FetchTakeHome
//
//  Created by Adam on 2/2/24.
//

import SwiftUI

struct DessertDetailView: View {
    let id: String
    @EnvironmentObject var mealModel: MealModel
    
    var body: some View {
        ScrollView {
            if let meal = mealModel.detailedMeal {
                VStack(alignment: .leading) {
                    
                    AsyncImage(url: URL(string: meal.strMealThumb)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                            .cornerRadius(20)
                            .shadow(radius: 15)
                    } placeholder: {
                        ProgressView()
                    }
                    .padding(.bottom)
                    
                    Divider()
                        .padding(.vertical)
                    
                    Text("Ingredients")
                        .font(.title2)
                        .padding(.bottom)
                    
                    ForEach(Array(meal.ingredients.keys), id: \.self) { i in
                        if let m = meal.ingredients[i] {
                            Text(" - \(m) \(i)")
                        }
                    }
                    
                    Divider()
                        .padding(.top)
                    
                    Text("Instructions")
                        .font(.title2)
                        .padding(.vertical)
                    
                    Text(meal.strInstructions)
                }
                .padding()
                .navigationTitle(meal.strMeal)
                .navigationBarTitleDisplayMode(.automatic)
                // currently long titles get cut off, converting this to normal text
                // loses the fade to inline effect - not sure which is prefered, leaving
                // as is.
            } else {
                ProgressView()
                    .controlSize(.large)
            }
        }
        .onAppear() {
            mealModel.getDetailedMealData(id: id)
        }
        .onDisappear() {
            // prevents prev meal from flashing on the screen before update occurs
            mealModel.detailedMeal = nil
        }
    }
}

#Preview {
    DessertDetailView(id: "52768")
        .environmentObject(MealModel())
}
