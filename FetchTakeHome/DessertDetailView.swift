//
//  DessertDetailView.swift
//  FetchTakeHome
//
//  Created by Adam on 2/2/24.
//

import SwiftUI

struct DessertDetailView: View {
    let id: String
    @State private var data: Meal?
    
    var body: some View {
        ScrollView {
            if let data = data {
                VStack(alignment: .leading) {
                    
                    AsyncImage(url: URL(string: data.strMealThumb)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                            .cornerRadius(20)
                            .shadow(radius: 15)
                    } placeholder: {
                        ProgressView()
                    }
                    .padding(.bottom)
                    
                    Text("Ingredients")
                        .font(.title2)
                        .padding(.bottom)
                    
                    ForEach(Array(data.ingredients.keys), id: \.self) { i in
                        if let m = data.ingredients[i] {
                            Text(" - \(m) \(i)")
                        }
                    }
                    
                    Text("Instructions")
                        .font(.title2)
                        .padding(.vertical)
                    
                    Text(data.strInstructions)
                }
                .padding()
                .navigationTitle(data.strMeal)
                .navigationBarTitleDisplayMode(.automatic)
                // currently long titles get cut off, converting this to normal text
                // loses the fade to inline effect - not sure which is prefered, leaving
                // as is.
            } else {
                ProgressView()
                    .controlSize(.large)
            }
        }
        .onAppear {
            apiRequest()
        }
    }
    
    private func apiRequest() {
        let baseURL = "https://themealdb.com/api/json/v1/1/lookup.php?i=\(id)"
        guard let url = URL(string: baseURL) else {
            print("URL Error.")
            return
        }
        URLSession.shared.getData(for: url) { (result: Result<MealsData, Error>) in
            switch result {
            case .success(let data):
                self.data = data.meals[0]
            case .failure(let error):
                print(error)
            }
        }
    }
}

#Preview {
    DessertDetailView(id: "52768")
}
