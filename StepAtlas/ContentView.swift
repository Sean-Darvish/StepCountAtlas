//
//  ContentView.swift
//  StepAtlas
//
//  Created by Shahab Darvish   on 10/1/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: HealthStoreViewModel
    
    var body: some View {
        
        TabView {
            if viewModel.isAuthorized {
                TodayView()
                    .tabItem {
                        Label("Today", systemImage: "house")
                    }
                
                HistoryView()
                    .tabItem {
                        Label("History", systemImage: "clock")
                    }
        
            } else {
                VStack {
                    Text("Please Authorize Health!")
                        .font(.title3)
                    
                    Button {
                        viewModel.healthRequest()
                    } label: {
                        Text("Authorize HealthKit")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .frame(width: 320, height: 55)
                    .background(Color(.orange))
                    .cornerRadius(10)
                }
            }
        }
        .onAppear {
            viewModel.readStepsTakenToday()
        }
    }
}
//
//#Preview {
//    ContentView()
//}
