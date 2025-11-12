//
//  UnassignedTimeCard.swift
//  TimeTracker
//
//  Created by Alexis Tatarkovic on 12/11/2025.
//

import SwiftUI

/// Card displaying unassigned time blocks information
struct UnassignedTimeCard: View {
    let unassignedBlocks: Int
    let totalBlocksInPeriod: Int
    let blockDurationMinutes: Int
    
    var hours: Double {
        Double(unassignedBlocks * blockDurationMinutes) / 60.0
    }
    
    var assignedPercentage: Int {
        guard totalBlocksInPeriod > 0 else { return 0 }
        return Int((Double(totalBlocksInPeriod - unassignedBlocks) / Double(totalBlocksInPeriod)) * 100)
    }
    
    var body: some View {
        HStack(spacing: 12) {
            iconView
            textContent
            Spacer()
            percentageView
        }
        .padding()
        .background(backgroundColor)
        .cornerRadius(12)
        .overlay(borderOverlay)
    }
    
    private var iconView: some View {
        Image(systemName: "clock.badge.exclamationmark")
            .font(.title2)
            .foregroundColor(.orange)
    }
    
    private var textContent: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Temps non assigné")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("\(unassignedBlocks) blocs (\(String(format: "%.1f", hours))h)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    private var percentageView: some View {
        Text("\(assignedPercentage)%")
            .font(.title3)
            .fontWeight(.bold)
            .foregroundColor(.orange)
    }
    
    private var backgroundColor: Color {
        Color.orange.opacity(0.1)
    }
    
    private var borderOverlay: some View {
        RoundedRectangle(cornerRadius: 12)
            .stroke(Color.orange.opacity(0.3), lineWidth: 1)
    }
}

#Preview {
    UnassignedTimeCard(
        unassignedBlocks: 15,
        totalBlocksInPeriod: 48,
        blockDurationMinutes: 30
    )
    .padding()
}
