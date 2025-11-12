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
    let duration: Int // Duration in minutes (15, 30, or 60)
    
    init(id: UUID = UUID(), hour: Int, minute: Int, categoryId: UUID? = nil, date: Date = Date(), duration: Int = 30) {
        self.id = id
        self.hour = hour
        self.minute = minute
        self.categoryId = categoryId
        self.date = date
        self.duration = duration
    }
    
    var timeString: String {
        String(format: "%02d:%02d", hour, minute)
    }
    
    var displayText: String {
        let totalMinutes = hour * 60 + minute
        let endTotalMinutes = totalMinutes + duration
        let endHour = (endTotalMinutes / 60) % 24
        let endMinute = endTotalMinutes % 60
        return String(format: "%02d:%02d - %02d:%02d", hour, minute, endHour, endMinute)
    }
}
