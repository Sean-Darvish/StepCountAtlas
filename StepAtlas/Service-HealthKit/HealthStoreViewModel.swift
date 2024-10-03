//
//  HealthStoreViewModel.swift
//  StepAtlas
//
//  Created by Shahab Darvish   on 10/2/24.
//

import Foundation
import HealthKit

class HealthStoreViewModel: ObservableObject {
    
    private var healthStore = HKHealthStore()
    private var healthStoreManager = HealthStoreManager()
    @Published var stepCounts: [Int] = Array(repeating: 0, count: 24)

    @Published var userStepCount = ""
    @Published var isAuthorized = false

    
    init() {
        changeAuthorizationStatus()
    }
    
    func healthRequest() {
        healthStoreManager.setUpHealthRequest(healthStore: healthStore) {
            self.changeAuthorizationStatus()
            self.readStepsTakenToday()
            self.fetchStepCountsHourly()
        }
    }
    
    func changeAuthorizationStatus() {
        guard let stepQtyType = HKObjectType.quantityType(forIdentifier: .stepCount) else { return }
        let status = self.healthStore.authorizationStatus(for: stepQtyType)
        
        switch status {
        case .notDetermined:
            isAuthorized = false
        case .sharingDenied:
            isAuthorized = false
        case .sharingAuthorized:
            DispatchQueue.main.async {
                self.isAuthorized = true
            }
        @unknown default:
            isAuthorized = false
        }
    }
    
    func readStepsTakenToday() {
        healthStoreManager.readStepCount(forToday: Date(), healthStore: healthStore) { step in
            if step != 0.0 {
                DispatchQueue.main.async {
                    self.userStepCount = String(format: "%.0f", step)
                }
            }
        }
    }
    
    func fetchStepCountsHourly() {
        
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        
        var interval = DateComponents()
        interval.hour = 1
        
        var anchorComponents = calendar.dateComponents([.day, .month, .year, .weekday], from: now)
        anchorComponents.hour = 0
        let anchorDate = calendar.date(from: anchorComponents)!
        
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        let query = HKStatisticsCollectionQuery(quantityType: stepType,
                                                quantitySamplePredicate: nil,
                                                options: .cumulativeSum,
                                                anchorDate: anchorDate,
                                                intervalComponents: interval)
        
        query.initialResultsHandler = { query, results, error in
            if let statsCollection = results {
                statsCollection.enumerateStatistics(from: startOfDay, to: now) { statistics, stop in
                    let hour = calendar.component(.hour, from: statistics.startDate)
                    if let sum = statistics.sumQuantity() {
                        let steps = sum.doubleValue(for: HKUnit.count())
                        DispatchQueue.main.async {
                            self.stepCounts[hour] = Int(steps)
                        }
                    }
                }
            }
        }
        
        self.healthStore.execute(query)
    }
    
}
