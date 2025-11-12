//
//  SelectionActionBar.swift
//  TimeTracker
//
//  Created by Alexis Tatarkovic on 12/11/2025.
//

import SwiftUI

/// Action bar displayed at the bottom when blocks are selected
struct SelectionActionBar: View {
    let selectedCount: Int
    @ObservedObject var categoryManager: CategoryManager
    let onCategorySelected: (UUID) -> Void
    let onCancel: () -> Void
    @State private var searchText = ""
    
    var filteredCategories: [CustomCategory] {
        if searchText.isEmpty {
            return categoryManager.categories
        } else {
            return categoryManager.categories.filter { category in
                category.name.localizedCaseInsensitiveContains(searchText) ||
                category.emoji.contains(searchText)
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            
            VStack(spacing: 12) {
                // Header with count
                HStack {
                    Text("\(selectedCount) bloc\(selectedCount > 1 ? "s" : "") sélectionné\(selectedCount > 1 ? "s" : "")")
                        .font(.headline)
                    
                    Spacer()
                    
                    Button("Annuler") {
                        onCancel()
                    }
                    .font(.subheadline)
                }
                
                // Search field
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                    TextField("Rechercher...", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                        .font(.subheadline)
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                                .font(.subheadline)
                        }
                    }
                }
                .padding(8)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                
                // Category selection
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(filteredCategories) { category in
                            CategoryChip(category: category) {
                                onCategorySelected(category.id)
                            }
                        }
                        
                        if filteredCategories.isEmpty {
                            Text("Aucune catégorie trouvée")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding()
                        }
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5)
        }
    }
}

/// Small category chip for quick selection
struct CategoryChip: View {
    let category: CustomCategory
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Text(category.emoji)
                    .font(.title3)
                Text(category.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(category.color.opacity(0.15))
            .foregroundColor(category.color)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(category.color, lineWidth: 1.5)
            )
        }
    }
}

#Preview {
    SelectionActionBar(
        selectedCount: 5,
        categoryManager: CategoryManager(),
        onCategorySelected: { _ in },
        onCancel: {}
    )
}
