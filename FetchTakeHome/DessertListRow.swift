//
//  DessertListRow.swift
//  FetchTakeHome
//
//  Created by Adam on 2/2/24.
//

import SwiftUI

struct DessertListRow: View {
    let imageURL: String
    let title: String
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: imageURL)) { image in
                image
                    .resizable()
                    .cornerRadius(10)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 75, height: 75)
            Text(title)
            Spacer()
        }
    }
}
