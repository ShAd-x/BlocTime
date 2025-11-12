//
//  TimeInterval.swift
//  TimeTracker
//
//  Created by Alexis Tatarkovic on 12/11/2025.
//

import Foundation

/// Represents the duration interval for time blocks
enum BlockInterval: Int, Codable, CaseIterable {
    case fifteenMinutes = 15
    case thirtyMinutes = 30
    case sixtyMinutes = 60
    
    var displayName: String {
        switch self {
        case .fifteenMinutes: return "15 minutes"
        case .thirtyMinutes: return "30 minutes"
        case .sixtyMinutes: return "60 minutes"
        }
    }
    
    var emoji: String {
        switch self {
        case .fifteenMinutes: return "⚡️"
        case .thirtyMinutes: return "⏱️"
        case .sixtyMinutes: return "⏰"
        }
    }
    
    var blocksPerDay: Int {
        return (24 * 60) / self.rawValue
    }
    
    /// Generate all minute values for a day based on this interval
    func minutesInHour() -> [Int] {
        var minutes: [Int] = []
        var currentMinute = 0
        while currentMinute < 60 {
            minutes.append(currentMinute)
            currentMinute += self.rawValue
        }
        return minutes
    }
}
