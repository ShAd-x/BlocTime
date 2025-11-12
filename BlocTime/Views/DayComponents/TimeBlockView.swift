//
//  TimeBlockView.swift
//  TimeTracker
//
//  Created by Alexis Tatarkovic on 12/11/2025.
//

import SwiftUI

/// Visual representation of a single 30-minute time block
struct TimeBlockView: View {
    let block: TimeBlock
    let categoryManager: CategoryManager
    let isSelectionMode: Bool
    let isSelected: Bool
    
    var body: some View {
        HStack {
            if isSelectionMode {
                selectionIndicator
            }
            timeLabel
            Spacer()
            categoryBadge
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(backgroundShape)
        .overlay(borderShape)
        .contentShape(Rectangle())
    }
    
    private var selectionIndicator: some View {
        Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
            .foregroundColor(isSelected ? .blue : .gray)
            .font(.title3)
    }
    
    private var timeLabel: some View {
        Text(block.displayText)
            .font(.system(.body))
            .frame(width: 120, alignment: .leading)
    }
    
    @ViewBuilder
    private var categoryBadge: some View {
        if let categoryId = block.categoryId,
           let category = categoryManager.getCategory(by: categoryId) {
            assignedBadge(category: category)
        } else {
            unassignedBadge
        }
    }
    
    private func assignedBadge(category: CustomCategory) -> some View {
        HStack(spacing: 8) {
            Text(category.emoji)
            Text(category.name)
                .font(.subheadline)
        }
        .foregroundColor(.white)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(category.color)
        .cornerRadius(8)
    }
    
    private var unassignedBadge: some View {
        Text("Non assigné")
            .font(.subheadline)
            .foregroundColor(.secondary)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
    }
    
    private var backgroundShape: some View {
        let categoryColor = block.categoryId.flatMap { categoryManager.getCategory(by: $0)?.color }
        return RoundedRectangle(cornerRadius: 10)
            .fill(categoryColor?.opacity(0.1) ?? Color.clear)
    }
    
    private var borderShape: some View {
        let categoryColor = block.categoryId.flatMap { categoryManager.getCategory(by: $0)?.color }
        return RoundedRectangle(cornerRadius: 10)
            .stroke(categoryColor?.opacity(0.3) ?? Color.gray.opacity(0.2), lineWidth: 1)
    }
}

#Preview {
    let categoryManager = CategoryManager()
    VStack(spacing: 10) {
        TimeBlockView(block: TimeBlock(hour: 9, minute: 0, categoryId: categoryManager.categories.first?.id, date: Date()), categoryManager: categoryManager, isSelectionMode: false, isSelected: false)
        TimeBlockView(block: TimeBlock(hour: 10, minute: 30, categoryId: nil, date: Date()), categoryManager: categoryManager, isSelectionMode: true, isSelected: true)
    }
    .padding()
}
