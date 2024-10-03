//
//  TodayView.swift
//  StepAtlas
//
//  Created by Shahab Darvish   on 10/2/24.
//

import SwiftUI
import Charts

struct TodayView: View {
    @StateObject var viewModel = StepViewModel()
    @ObservedObject var viewModelHealth = HealthStoreViewModel()
    
    var body: some View {
        VStack{
            VStack {
                Text("\(viewModel.stepCount)")
                    .font(.system(size: 72, weight: .bold))
                Text("Steps")
                    .font(.headline)
                
                ProgressView(value: Float(viewModel.stepCount), total: 10000)
                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                    .frame(height: 20)
                    .padding()
                
                Text("10,000 Steps")
                    .font(.caption)
                    .padding(.bottom)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                  
                Chart {
                    ForEach(0..<viewModelHealth.stepCounts.count, id: \.self) { hour in
                        BarMark(
                            x: .value("Hour", hour),
                            y: .value("Steps", viewModelHealth.stepCounts[hour])
                        )
                        .foregroundStyle(Color.blue)
                    }
                }
                .frame(height: 300)
                .padding()
            }
            .onAppear {
                Task {
                    await viewModel.updateStepData()
                     
                    viewModelHealth.fetchStepCountsHourly()
                    viewModel.startAutoRefresh()
                }
            }
        }
        .padding()
   
    }
}

