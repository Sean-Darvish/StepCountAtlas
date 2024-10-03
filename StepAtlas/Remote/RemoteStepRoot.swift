//
//  RemoteStepRoot.swift
//  StepAtlas
//
//  Created by Shahab Darvish   on 10/1/24.
//

import Foundation

struct RemoteStepRoot: Codable,Hashable {
    let id: Int
    let username: String
    let stepsDate, stepsDatetime: String
    let stepsCount: Int
    let stepsTotal: Int?
    let createdDatetime: String?
    let createdAt, updatedAt: String
    let stepsTotalByDay: Int

    enum CodingKeys: String, CodingKey {
        case id, username
        case stepsDate = "steps_date"
        case stepsDatetime = "steps_datetime"
        case stepsCount = "steps_count"
        case stepsTotal = "steps_total"
        case createdDatetime = "created_datetime"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case stepsTotalByDay = "steps_total_by_day"
    }
}

