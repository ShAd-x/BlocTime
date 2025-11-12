//
//  BarChartView.swift
//  TimeTracker
//
//  Created by Alexis Tatarkovic on 12/11/2025.
//

import SwiftUI
import Charts

/// Bar chart visualization for category statistics
struct BarChartView: View {
    let stats: [UUID: Int]
    let categoryManager: CategoryManager
    
    var sortedStats: [(UUID, Int)] {
        stats.sorted(by: { $0.value > $1.value })
    }
    
    var body: some View {
        Chart {
            ForEach(sortedStats, id: \.0) { categoryId, count in
                if let category = categoryManager.getCategory(by: categoryId) {
                    BarMark(
                        x: .value("Heures", Double(count) / 2.0),
                        y: .value("Catégorie", category.name)
                    )
                    .foregroundStyle(category.color)
                    .annotation(position: .trailing) {
                        HStack(spacing: 4) {
                            Text(category.emoji)
                            Text(String(format: "%.1fh", Double(count) / 2.0))
                                .font(.caption)
                                .fontWeight(.semibold)
                        }
                    }
                }
            }
        }
        .chartXAxis {
            AxisMarks(position: .bottom)
        }
        .chartYAxis {
            AxisMarks(position: .leading) { value in
                if let categoryName = value.as(String.self) {
                    AxisValueLabel {
                        Text(categoryName)
                            .font(.subheadline)
                    }
                }
            }
        }
        .frame(height: CGFloat(sortedStats.count) * 60 + 40)
    }
}

#Preview {
    let categoryManager = CategoryManager()
    let stats = [categoryManager.categories[0].id: 10, categoryManager.categories[1].id: 5, categoryManager.categories[2].id: 8]
    BarChartView(stats: stats, categoryManager: categoryManager)
        .padding()
}
