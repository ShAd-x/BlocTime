//
//  PeriodSection.swift
//  TimeTracker
//
//  Created by Alexis Tatarkovic on 12/11/2025.
//

import SwiftUI

/// Section displaying time blocks grouped by period (morning, afternoon, etc.)
struct PeriodSection: View {
    let period: TimePeriod
    let blocks: [TimeBlock]
    let categoryManager: CategoryManager
    let isSelectionMode: Bool
    @Binding var selectedBlocks: Set<UUID>
    let onBlockTap: (TimeBlock) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            periodHeader
            blocksGrid
        }
        .padding(.vertical, 8)
    }
    
    private var periodHeader: some View {
        HStack {
            Text(period.rawValue)
                .font(.headline)
                .fontWeight(.bold)
            
            Spacer()
            
            Text(period.timeRange)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 4)
    }
    
    private var blocksGrid: some View {
        VStack(spacing: 8) {
            ForEach(blocks) { block in
                TimeBlockView(
                    block: block, 
                    categoryManager: categoryManager,
                    isSelectionMode: isSelectionMode,
                    isSelected: selectedBlocks.contains(block.id)
                )
                .id(block.id)
                .onTapGesture {
                    onBlockTap(block)
                }
            }
        }
    }
}

#Preview {
    PeriodSection(
        period: .morning,
        blocks: [],
        categoryManager: CategoryManager(),
        isSelectionMode: false,
        selectedBlocks: .constant([]),
        onBlockTap: { _ in }
    )
    .padding()
}
