//
//  DessertDetailView.swift
//  FetchTakeHome
//
//  Created by Adam on 2/2/24.
//

import SwiftUI

struct DessertDetailView: View {
    let id: String
    
    @State var data: Meal?
    
    var body: some View {
        ScrollView {
            if let data = data {
                VStack (alignment: .leading){
                    Text(data.strMeal)
                        .font(.title)
                    AsyncImage(url: URL(string: data.strMealThumb)) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 150, height: 150)
                    
                    Text("Ingredients")
                        .font(.title2)
                    
                    ForEach(Array(data.ingredients.keys), id: \.self){ i in
                        if let m = data.ingredients[i] {
                            Text(" - \(m) \(i)")
                        }
                    }
                    
                    Text("Instructions")
                        .font(.title2)
                    Text(data.strInstructions)
                }
                .padding()
            } else {
                ProgressView()
                    .controlSize(.large)
            }
        }
        .onAppear {
            let baseURL = "https://themealdb.com/api/json/v1/1/lookup.php?i=\(id)"
            guard let url = URL(string: baseURL) else {
                return
            }
            URLSession.shared.getData(for: url) { (result: Result<MealsData, Error>) in
                switch result {
                case .success(let data):
                    self.data = data.meals[0]
                    print(data.meals[0])
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

#Preview {
    DessertDetailView(id: "52768")
}
