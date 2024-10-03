//
//  HistoryView.swift
//  StepAtlas
//
//  Created by Shahab Darvish   on 10/1/24.
//

import SwiftUI

struct HistoryView: View {
    @StateObject var viewModel = StepViewModel()
    
    var body: some View {
        VStack{
            VStack {
                HStack {
                    Button(action: {
                        Task {
                            await viewModel.updateHistoryData(days: 7)
                        }
                    }) {
                        Text("7 Days")
                            .padding()
                            .background(viewModel.historyData.count == 7 ? Color.blue : Color.clear)
                            .foregroundColor(viewModel.historyData.count == 7 ? Color.white : Color.black)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        Task {
                            await viewModel.updateHistoryData(days: 30)
                        }
                    }) {
                        Text("30 Days")
                            .padding()
                            .background(viewModel.historyData.count == 30 ? Color.blue : Color.clear)
                            .foregroundColor(viewModel.historyData.count == 30 ? Color.white : Color.black)
                            .cornerRadius(10)
                    }
                }
                .padding()
                
         
            }
            .fixedSize()
            
            HStack(spacing: 4) {
                ForEach(viewModel.historyData, id: \.self) { steps in
                    VStack {
                        Spacer()
                        Rectangle()
                            .fill(Color.blue)
                            .frame(width: 20, height: CGFloat(steps.stepsCount) / 1000)
                    }
                }
            }
            .frame(height: 250)
            .padding()
        }
        .padding()
        .onAppear {
            Task {
                await viewModel.updateHistoryData(days: 7)
            }
        }
    }
}

