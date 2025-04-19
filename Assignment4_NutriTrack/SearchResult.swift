//
//  SearchResult.swift
//  Assignment4_NutriTrack
//
//  Created by user on 2025-04-18.
//

import Foundation

struct SearchResponse: Decodable {
    let results: [FoodItem]
}

struct FoodItem: Decodable, Identifiable {
    let id: Int
    let title: String
    let image: String
}
