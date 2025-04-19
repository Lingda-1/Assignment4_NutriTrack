//
//  FoodDetailView.swift
//  Assignment4_NutriTrack
//
//  Created by user on 2025-04-18.
//

import SwiftUI
import CoreData

struct NutritionInfo: Decodable {
    let calories: String
    let fat: String
    let protein: String
    let carbs: String
}

struct FoodDetailView: View {
    let foodItem: FoodItem
    @State private var nutrition: NutritionInfo?
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showSuccess = false

    @Environment(\.managedObjectContext) private var viewContext

    let apiKey = "9492eb03ca4b4d8886cc315432d1aa5b"

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: URL(string: "https://spoonacular.com/recipeImages/\(foodItem.id)-312x231.jpg")) { image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    Color.gray.frame(height: 200)
                }

                Text(foodItem.title)
                    .font(.title)
                    .bold()

                if isLoading {
                    ProgressView("Loading nutrition...")
                } else if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                } else if let nutrition = nutrition {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Calories: \(nutrition.calories)")
                        Text("Protein: \(nutrition.protein)")
                        Text("Fat: \(nutrition.fat)")
                        Text("Carbs: \(nutrition.carbs)")
                    }

                    Button(action: {
                        if let calValue = Double(nutrition.calories.replacingOccurrences(of: "kcal", with: "").trimmingCharacters(in: .whitespaces)) {
                            saveMeal(title: foodItem.title, calories: calValue)
                        } else {
                            errorMessage = "Calories format error"
                        }
                    }) {
                        Text("Add to My Meals")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    if showSuccess {
                        Text("Saved!")
                            .foregroundColor(.green)
                            .font(.caption)
                    }
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Details")
            .onAppear(perform: fetchNutrition)
        }
    }

    func fetchNutrition() {
        isLoading = true
        errorMessage = nil
        nutrition = nil

        let urlString = "https://api.spoonacular.com/recipes/\(foodItem.id)/nutritionWidget.json?apiKey=\(apiKey)"
        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                isLoading = false

                if let error = error {
                    errorMessage = error.localizedDescription
                    return
                }

                guard let data = data else {
                    errorMessage = "No data received"
                    return
                }

                do {
                    nutrition = try JSONDecoder().decode(NutritionInfo.self, from: data)
                } catch {
                    errorMessage = "No nutrition info available for this item."
                }
            }
        }.resume()
    }

    func saveMeal(title: String, calories: Double) {
        let newMeal = Meal(context: viewContext)
        newMeal.id = UUID()
        newMeal.title = title
        newMeal.calories = calories
        newMeal.dateAdded = Date()

        do {
            try viewContext.save()
            showSuccess = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showSuccess = false
            }
        } catch {
            print("Error saving meal: \(error.localizedDescription)")
        }
    }
}
