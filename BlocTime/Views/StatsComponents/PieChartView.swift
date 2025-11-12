//
//  PieChartView.swift
//  TimeTracker
//
//  Created by Alexis Tatarkovic on 12/11/2025.
//

import SwiftUI
import Charts

/// Pie chart visualization for category statistics
struct PieChartView: View {
    let stats: [UUID: Int]
    let categoryManager: CategoryManager
    let totalBlocks: Int
    
    var body: some View {
        Chart(stats.sorted(by: { $0.value > $1.value }), id: \.key) { item in
            if let category = categoryManager.getCategory(by: item.key) {
                SectorMark(
                    angle: .value("Nombre", item.value),
                    innerRadius: .ratio(0.5),
                    angularInset: 2
                )
                .foregroundStyle(category.color)
                .annotation(position: .overlay) {
                    if item.value > 0 {
                        Text("\(item.value)")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .frame(height: 300)
    }
}

#Preview {
    let categoryManager = CategoryManager()
    let stats = [categoryManager.categories[0].id: 10, categoryManager.categories[1].id: 5, categoryManager.categories[2].id: 8]
    PieChartView(
        stats: stats,
        categoryManager: categoryManager,
        totalBlocks: 23
    )
    .padding()
}
