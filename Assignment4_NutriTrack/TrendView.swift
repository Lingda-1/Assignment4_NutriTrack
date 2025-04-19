//
//  TrendView.swift
//  Assignment4_NutriTrack
//
//  Created by user on 2025-04-18.
//

import SwiftUI
import CoreData
import Charts

struct DailyCalorie: Identifiable {
    let id = UUID()
    let date: Date
    let totalCalories: Double
}

struct TrendView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Meal.dateAdded, ascending: true)],
        animation: .default
    ) private var meals: FetchedResults<Meal>

    var dailyCalories: [DailyCalorie] {
        let grouped = Dictionary(grouping: meals) { meal in
            startOfDay(for: meal.dateAdded ?? Date())
        }

        let sortedDays = grouped.keys.sorted(by: >).prefix(7).sorted()

        var result: [DailyCalorie] = sortedDays.map { day in
            let total = grouped[day]?.reduce(0) { $0 + $1.calories } ?? 0
            return DailyCalorie(date: day, totalCalories: total)
        }

        if result.count == 1 {
            if let onlyDay = result.first?.date {
                let previousDay = Calendar.current.date(byAdding: .day, value: -1, to: onlyDay)!
                let dummy = DailyCalorie(date: previousDay, totalCalories: 0)
                result.insert(dummy, at: 0)
            }
        }

        return result
    }

    var body: some View {
        NavigationView {
            VStack {
                if dailyCalories.isEmpty {
                    Text("No data yet.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    Chart {
                        ForEach(dailyCalories) { data in
                            BarMark(
                                x: .value("Date", formattedDate(data.date)),
                                y: .value("Calories", data.totalCalories)
                            )
                            .foregroundStyle(Color.blue)
                        }
                    }
                    .frame(height: 300)
                    .padding()
                }
            }
            .navigationTitle("Calorie Trends")
        }
    }

    func startOfDay(for date: Date) -> Date {
        Calendar.current.startOfDay(for: date)
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        return formatter.string(from: date)
    }
}
