//
//  CategoryManager.swift
//  TimeTracker
//
//  Created by Alexis Tatarkovic on 12/11/2025.
//

import Foundation
import Combine

/// Manages custom categories with persistence
class CategoryManager: ObservableObject {
    @Published var categories: [CustomCategory] = []
    
    private let userDefaultsKey = "customCategories"
    
    init() {
        loadCategories()
    }
    
    // MARK: - Public Methods
    
    /// Add a new category
    func addCategory(_ category: CustomCategory) {
        categories.append(category)
        saveCategories()
    }
    
    /// Update an existing category
    func updateCategory(_ category: CustomCategory) {
        if let index = categories.firstIndex(where: { $0.id == category.id }) {
            categories[index] = category
            saveCategories()
        }
    }
    
    /// Delete a category (only custom ones, not defaults)
    func deleteCategory(_ category: CustomCategory) {
        guard !category.isDefault else { return }
        categories.removeAll { $0.id == category.id }
        saveCategories()
    }
    
    /// Get category by ID
    func getCategory(by id: UUID) -> CustomCategory? {
        return categories.first { $0.id == id }
    }
    
    /// Reset to default categories
    func resetToDefaults() {
        categories = CustomCategory.defaultCategories
        saveCategories()
    }
    
    // MARK: - Persistence
    
    private func saveCategories() {
        if let encoded = try? JSONEncoder().encode(categories) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    private func loadCategories() {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey),
              let decoded = try? JSONDecoder().decode([CustomCategory].self, from: data) else {
            // First launch: use default categories
            categories = CustomCategory.defaultCategories
            saveCategories()
            return
        }
        categories = decoded
    }
}
