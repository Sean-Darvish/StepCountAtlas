//
//  RemoteManager.swift
//  StepAtlas
//
//  Created by Shahab Darvish   on 10/2/24.
//

import Foundation

class RemoteManager {
    static let shared = RemoteManager()
    
    private init() {}
    
    private let baseURL = "https://testapi.mindware.us"

    func fetchBearerToken() async throws -> String {
        let authURL = URL(string: "\(baseURL)/auth/local")!
        var request = URLRequest(url: authURL)
        request.httpMethod = "POST"
        
        let body: [String: Any] = [
            "identifier": "user1@test.com",
            "password": "Test123!"
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        
        guard let token = json?["jwt"] as? String else {
            throw URLError(.badServerResponse)
        }
        
        return token
    }
    
    func postSteps(stepCount: Int, token: String) async throws {
        let stepsURL = URL(string: "\(baseURL)/steps")!
        var request = URLRequest(url: stepsURL)
        request.httpMethod = "POST"
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let stepsDate = dateFormatter.string(from: currentDate)

        let isoDateFormatter = ISO8601DateFormatter()
        let stepsDatetime = isoDateFormatter.string(from: currentDate)
        
        let body: [String: Any] = [
             "username": "qtrang",
             "steps_date": stepsDate,
             "steps_datetime": stepsDatetime,
             "steps_count": stepCount,
             "steps_total_by_day": 0
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let _ = try await URLSession.shared.data(for: request)
    }
    
    //MARK: historical
    func fetchHistory(token: String, days: Int) async throws -> [RemoteStepRoot] {
        let historyURL = URL(string: "\(baseURL)/steps?_limit=\(days)&_sort=steps_date")!
        var request = URLRequest(url: historyURL)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let stepsData = try JSONDecoder().decode([RemoteStepRoot].self, from: data)
        
        return stepsData
    }
    
    func fetchToday(token: String, days: Int) async throws -> [RemoteStepRoot] {
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let stepsDate = dateFormatter.string(from: currentDate)
        
        let historyURL = URL(string: "\(baseURL)/steps?_limit=\(days)&steps_date=\(stepsDate)&_sort=steps_date")!  
        var request = URLRequest(url: historyURL)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let stepsData = try JSONDecoder().decode([RemoteStepRoot].self, from: data)
    
        return stepsData
    }
}

