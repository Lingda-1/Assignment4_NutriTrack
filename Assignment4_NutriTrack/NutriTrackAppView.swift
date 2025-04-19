//
//  NutriTrackAppView.swift
//  Assignment4_NutriTrack
//
//  Created by user on 2025-04-18.
//

import SwiftUI

struct NutriTrackAppView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }

            MealListView()
                .tabItem {
                    Label("Meals", systemImage: "fork.knife")
                }

            TrendView()
                .tabItem {
                    Label("Trends", systemImage: "chart.bar")
                }

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
    }
}
