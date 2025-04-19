//
//  MealListView.swift
//  Assignment4_NutriTrack
//
//  Created by user on 2025-04-18.
//

import SwiftUI
import CoreData

struct MealListView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Meal.dateAdded, ascending: false)],
        animation: .default
    ) private var meals: FetchedResults<Meal>

    var totalCalories: Double {
        meals.reduce(0) { $0 + $1.calories }
    }

    var body: some View {
        NavigationView {
            VStack {
                if meals.isEmpty {
                    Text("No meals logged yet.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List {
                        Section(header: Text("Total Calories: \(Int(totalCalories))")) {
                            ForEach(meals) { meal in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(meal.title ?? "Unnamed")
                                        .font(.headline)
                                    Text("Calories: \(Int(meal.calories))")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    if let date = meal.dateAdded {
                                        Text("Added: \(formatted(date))")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                            .onDelete(perform: deleteMeal)
                        }
                    }
                }
            }
            .navigationTitle("My Meals")
            .toolbar {
                EditButton()
            }
        }
    }

    func deleteMeal(at offsets: IndexSet) {
        for index in offsets {
            viewContext.delete(meals[index])
        }

        do {
            try viewContext.save()
        } catch {
            print("Failed to delete meal: \(error.localizedDescription)")
        }
    }

    func formatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
