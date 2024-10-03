//
//  StepAtlasApp.swift
//  StepAtlas
//
//  Created by Shahab Darvish   on 10/1/24.
//

import SwiftUI

@main
struct StepAtlasApp: App {
    var healthVM = HealthStoreViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(healthVM)
        }
    }
}
