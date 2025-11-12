//
//  TimeBlock.swift
//  TimeTracker
//
//  Created by Alexis Tatarkovic on 12/11/2025.
//

import Foundation

struct TimeBlock: Identifiable, Codable {
    let id: UUID
    let hour: Int
    let minute: Int
    var categoryId: UUID?
    let date: Date
    
    init(id: UUID = UUID(), hour: Int, minute: Int, categoryId: UUID? = nil, date: Date = Date()) {
        self.id = id
        self.hour = hour
        self.minute = minute
        self.categoryId = categoryId
        self.date = date
    }
    
    var timeString: String {
        String(format: "%02d:%02d", hour, minute)
    }
    
    var displayText: String {
        let endMinute = minute == 30 ? 0 : 30
        let endHour = minute == 30 ? hour + 1 : hour
        let displayEndHour = endHour == 24 ? 0 : endHour
        return String(format: "%02d:%02d - %02d:%02d", hour, minute, displayEndHour, endMinute)
    }
}
