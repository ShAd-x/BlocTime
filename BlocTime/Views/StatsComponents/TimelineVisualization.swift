//
//  TimelineVisualization.swift
//  TimeTracker
//
//  Created by Alexis Tatarkovic on 12/11/2025.
//

import SwiftUI

/// Visual timeline showing blocks distribution across the day
struct TimelineVisualization: View {
    let blocks: [TimeBlock]
    let categoryManager: CategoryManager
    let selectedDate: Date
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE d MMMM"
        formatter.locale = Locale(identifier: "fr_FR")
        return formatter.string(from: selectedDate)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            headerView
            timelineBar
            timeLabels
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(15)
    }
    
    private var headerView: some View {
        HStack {
            Text("Timeline")
                .font(.title2)
                .fontWeight(.bold)
            
            Spacer()
            
            Text(formattedDate)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    private var timelineBar: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background
                Rectangle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(height: 40)
                    .cornerRadius(20)
                
                // Colored segments for each block
                HStack(spacing: 0) {
                    ForEach(blocks) { block in
                        let blockColor = block.categoryId.flatMap { categoryManager.getCategory(by: $0)?.color } ?? Color.gray.opacity(0.2)
                        Rectangle()
                            .fill(blockColor)
                            .frame(width: geometry.size.width / 48)
                    }
                }
                .cornerRadius(20)
            }
        }
        .frame(height: 40)
    }
    
    private var timeLabels: some View {
        HStack {
            TimeLabel(text: "00:00")
            Spacer()
            TimeLabel(text: "06:00")
            Spacer()
            TimeLabel(text: "12:00")
            Spacer()
            TimeLabel(text: "18:00")
            Spacer()
            TimeLabel(text: "23:30")
        }
    }
}

/// Helper view for time labels
struct TimeLabel: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.caption2)
            .foregroundColor(.secondary)
    }
}

#Preview {
    TimelineVisualization(
        blocks: [],
        categoryManager: CategoryManager(),
        selectedDate: Date()
    )
    .padding()
}
