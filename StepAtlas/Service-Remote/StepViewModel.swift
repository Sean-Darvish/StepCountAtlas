//
//  StepViewModel.swift
//  StepAtlas
//
//  Created by Shahab Darvish   on 10/2/24.
//

import Foundation

import HealthKit

class StepViewModel: ObservableObject {
    @Published var stepCount: Int = 0
    @Published var historyData: [RemoteStepRoot] = []
    
    private var healthStoreManager: HealthStoreManager
    private var healthStore: HKHealthStore
    private var apiManager: RemoteManager
    
    init() {
        self.healthStoreManager = HealthStoreManager()
        self.healthStore = HKHealthStore()
        self.apiManager = RemoteManager.shared
    }
    
    func updateStepData() async {
        do {
            let steps = try await fetchStepCountFromHealthStore()
            
            let token = try await apiManager.fetchBearerToken()
            try await apiManager.postSteps(stepCount: steps, token: token)
            
            DispatchQueue.main.async {
                self.stepCount = steps
            }
        } catch {
            print("Error updating step data: \(error)")
        }
    }
    
    private func fetchStepCountFromHealthStore() async throws -> Int {
        return try await withCheckedThrowingContinuation { continuation in
            healthStoreManager.readStepCount(forToday: Date(), healthStore: healthStore) { steps in
                continuation.resume(returning: Int(steps))
            }
        }
    }
    
    func updateHistoryData(days: Int) async {
        do {
            let token = try await apiManager.fetchBearerToken()
            let history = try await apiManager.fetchHistory(token: token, days: days)
            
            DispatchQueue.main.async {
                self.historyData = history
            }
        } catch {
            print("Error fetching history: \(error)")
        }
    }
    
    //MARK: Refresh every 5 minutes 
    func startAutoRefresh() {
        Timer.scheduledTimer(withTimeInterval: 300, repeats: true) { _ in
            Task {
                await self.updateStepData()
            }
        }
    }
}
