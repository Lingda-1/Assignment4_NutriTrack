//
//  HomeView.swift
//  Assignment4_NutriTrack
//
//  Created by user on 2025-04-18.
//

import SwiftUI
import CoreData

struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Meal.dateAdded, ascending: false)],
        animation: .default
    ) private var meals: FetchedResults<Meal>

    var totalTodayCalories: Int {
        let today = Calendar.current.startOfDay(for: Date())
        return meals.filter { ($0.dateAdded ?? Date()) >= today }
            .reduce(0) { $0 + Int($1.calories) }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("Today's Calorie Intake")
                    .font(.title2)
                    .bold()

                Text("\(totalTodayCalories) kcal")
                    .font(.system(size: 40, weight: .semibold))
                    .foregroundColor(.green)

                Divider()

                VStack(spacing: 16) {
                    NavigationLink(destination: SearchView()) {
                        HomeButton(label: "Add Food", icon: "plus.circle.fill", color: .blue)
                    }

                    NavigationLink(destination: MealListView()) {
                        HomeButton(label: "Meal History", icon: "list.bullet", color: .orange)
                    }

                    NavigationLink(destination: ProfileView()) {
                        HomeButton(label: "Settings", icon: "gearshape.fill", color: .gray)
                    }
                }

                Spacer()
            }
            .padding()
            .navigationTitle("NutriTrack")
        }
    }
}

struct HomeButton: View {
    let label: String
    let icon: String
    let color: Color

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.white)
                .frame(width: 30, height: 30)

            Text(label)
                .foregroundColor(.white)
                .font(.headline)

            Spacer()
        }
        .padding()
        .background(color)
        .cornerRadius(12)
    }
}
