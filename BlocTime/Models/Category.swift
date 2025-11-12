//
//  Category.swift
//  TimeTracker
//
//  Created by Alexis Tatarkovic on 12/11/2025.
//

import SwiftUI

enum Category: String, CaseIterable, Codable {
    case work = "Travail"
    case sleep = "Sommeil"
    case pause = "Pause"
    case family = "Famille"
    case leisure = "Loisirs"
    case other = "Autre"
    
    var color: Color {
        switch self {
        case .work: return .blue
        case .sleep: return Color(red: 0.2, green: 0.2, blue: 0.2)
        case .pause: return .green
        case .family: return .pink
        case .leisure: return .yellow
        case .other: return .gray
        }
    }
    
    var emoji: String {
        switch self {
        case .work: return "💼"
        case .sleep: return "😴"
        case .pause: return "☕️"
        case .family: return "👨‍👩‍👧‍👦"
        case .leisure: return "🎮"
        case .other: return "📌"
        }
    }
}
