//
//  CustomCategory.swift
//  TimeTracker
//
//  Created by Alexis Tatarkovic on 12/11/2025.
//

import SwiftUI

/// Represents a customizable category for time tracking
struct CustomCategory: Identifiable, Codable, Hashable, Equatable {
    let id: UUID
    var name: String
    var emoji: String
    var colorHex: String
    var isDefault: Bool
    
    init(id: UUID = UUID(), name: String, emoji: String, colorHex: String, isDefault: Bool = false) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.colorHex = colorHex
        self.isDefault = isDefault
    }
    
    var color: Color {
        Color(hex: colorHex) ?? .gray
    }
    
    // Default categories
    static let defaultCategories: [CustomCategory] = [
        CustomCategory(name: "Travail", emoji: "💼", colorHex: "#007AFF", isDefault: true),
        CustomCategory(name: "Administration", emoji: "📋", colorHex: "#5856D6", isDefault: true),
        CustomCategory(name: "Email", emoji: "📧", colorHex: "#34C759", isDefault: true),
        CustomCategory(name: "Créatif", emoji: "🎨", colorHex: "#FF9500", isDefault: true),
        CustomCategory(name: "Déplacement", emoji: "🚗", colorHex: "#FF3B30", isDefault: true),
        CustomCategory(name: "Pause", emoji: "☕️", colorHex: "#8E8E93", isDefault: true),
        CustomCategory(name: "Dormir", emoji: "😴", colorHex: "#1C1C1E", isDefault: true),
        CustomCategory(name: "Santé", emoji: "❤️", colorHex: "#FF2D55", isDefault: true),
        CustomCategory(name: "Famille", emoji: "👨‍👩‍👧‍👦", colorHex: "#AF52DE", isDefault: true),
        CustomCategory(name: "Loisirs", emoji: "🎮", colorHex: "#5AC8FA", isDefault: true),
        CustomCategory(name: "Apprentissage", emoji: "📚", colorHex: "#FFCC00", isDefault: true),
        CustomCategory(name: "Ménage", emoji: "🧹", colorHex: "#32ADE6", isDefault: true),
        CustomCategory(name: "Urgence", emoji: "🚨", colorHex: "#FF3B30", isDefault: true),
        CustomCategory(name: "Procrastiner", emoji: "📱", colorHex: "#FF9500", isDefault: true),
        CustomCategory(name: "Manger/Faire à manger", emoji: "🍽️", colorHex: "#FF6B6B", isDefault: true),
        CustomCategory(name: "Social", emoji: "👥", colorHex: "#4ECDC4", isDefault: true),
        CustomCategory(name: "Jouer", emoji: "🎯", colorHex: "#95E1D3", isDefault: true),
        CustomCategory(name: "Dev.", emoji: "💻", colorHex: "#00D4AA", isDefault: true),
        CustomCategory(name: "Autre", emoji: "📌", colorHex: "#8E8E93", isDefault: true)
    ]
}

// MARK: - Color Extension for Hex Support
extension Color {
    init?(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return nil
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    func toHex() -> String? {
        guard let components = UIColor(self).cgColor.components, components.count >= 3 else {
            return nil
        }
        
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        
        return String(format: "#%02lX%02lX%02lX",
                     lroundf(r * 255),
                     lroundf(g * 255),
                     lroundf(b * 255))
    }
}
