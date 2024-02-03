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
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onAppear {
                let baseURL = "https://themealdb.com/api/json/v1/1/lookup.php?i=" + id
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
