//
//  StatRow.swift
//  TimeTracker
//
//  Created by Alexis Tatarkovic on 12/11/2025.
//

import SwiftUI

/// Detailed row view for a single category's statistics
struct StatRow: View {
    let category: CustomCategory
    let blocks: Int
    let percentage: Double
    
    var hours: Double {
        Double(blocks) / 2.0
    }
    
    var body: some View {
        VStack(spacing: 8) {
            headerRow
            progressBar
            percentageLabel
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.primary.opacity(0.05))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.primary.opacity(0.1), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    private var headerRow: some View {
        HStack {
            HStack(spacing: 10) {
                Text(category.emoji)
                    .font(.title3)
                
                Text(category.name)
                    .font(.headline)
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text(String(format: "%.1fh", hours))
                        .font(.headline)
                        .foregroundColor(category.color)
                    
                    Text("\(blocks) blocs")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
    
    private var progressBar: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 8)
                    .cornerRadius(4)
                
                Rectangle()
                    .fill(category.color)
                    .frame(width: geometry.size.width * percentage, height: 8)
                    .cornerRadius(4)
            }
        }
        .frame(height: 8)
    }
    
    private var percentageLabel: some View {
        Text(String(format: "%.1f%%", percentage * 100))
            .font(.caption)
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity, alignment: .trailing)
    }
}

#Preview {
    let categoryManager = CategoryManager()
    StatRow(category: categoryManager.categories.first!, blocks: 16, percentage: 0.33)
        .padding()
}
