//
//  Assignment4_NutriTrackApp.swift
//  Assignment4_NutriTrack
//
//  Created by user on 2025-04-18.
//

import SwiftUI
import Firebase

@main
struct Assignment4_NutriTrackApp: App {
    
    init() {
            FirebaseApp.configure()
        }
    
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            NutriTrackAppView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
