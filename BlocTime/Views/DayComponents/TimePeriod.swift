//
//  TimePeriod.swift
//  TimeTracker
//
//  Created by Alexis Tatarkovic on 12/11/2025.
//

import Foundation

/// Represents time periods within a day for grouping time blocks
enum TimePeriod: String, CaseIterable {
    case night = "🌙 NUIT"
    case morning = "☀️ MATIN"
    case afternoon = "🌤️ APRÈS-MIDI"
    case evening = "🌆 SOIR"
    
    /// Hour range for this period
    var hourRange: ClosedRange<Int> {
        switch self {
        case .night: return 0...5
        case .morning: return 6...11
        case .afternoon: return 12...17
        case .evening: return 18...23
        }
    }
    
    /// Formatted time range string
    var timeRange: String {
        switch self {
        case .night: return "00:00 - 06:00"
        case .morning: return "06:00 - 12:00"
        case .afternoon: return "12:00 - 18:00"
        case .evening: return "18:00 - 00:00"
        }
    }
}
