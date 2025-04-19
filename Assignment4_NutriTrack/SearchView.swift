//
//  SearchView.swift
//  Assignment4_NutriTrack
//
//  Created by user on 2025-04-18.
//

import SwiftUI

struct SearchView: View {
    @State private var query = ""
    @State private var foodItems: [FoodItem] = []
    @State private var isLoading = false
    @State private var errorMessage: String?

    let apiKey = "9492eb03ca4b4d8886cc315432d1aa5b"

    var body: some View {
        NavigationView {
            VStack {
                TextField("Search food...", text: $query, onCommit: fetchFood)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                if isLoading {
                    ProgressView("Loading...")
                } else if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)").foregroundColor(.red)
                } else {
                    List(foodItems) { item in
                        NavigationLink(destination: FoodDetailView(foodItem: item)) {
                            HStack {
                                AsyncImage(url: URL(string: "https://spoonacular.com/recipeImages/\(item.id)-312x231.jpg")) { phase in
                                    if let image = phase.image {
                                        image.resizable().frame(width: 60, height: 60).cornerRadius(8)
                                    } else {
                                        Color.gray.frame(width: 60, height: 60).cornerRadius(8)
                                    }
                                }
                                Text(item.title)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Search")
        }
    }

    func fetchFood() {
        guard !query.isEmpty else { return }
        isLoading = true
        errorMessage = nil

        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://api.spoonacular.com/recipes/complexSearch?query=\(encodedQuery)&number=10&apiKey=\(apiKey)"

        guard let url = URL(string: urlString) else {
            self.errorMessage = "Invalid URL"
            self.isLoading = false
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false

                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }

                guard let data = data else {
                    self.errorMessage = "No data"
                    return
                }

                do {
                    let result = try JSONDecoder().decode(SearchResponse.self, from: data)
                    self.foodItems = result.results
                } catch {
                    self.errorMessage = "Failed to decode: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}
