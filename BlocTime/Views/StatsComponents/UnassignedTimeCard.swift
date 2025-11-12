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
    
    var hours: Double {
        Double(unassignedBlocks) / 2.0
    }
    
    var assignedPercentage: Int {
        Int((Double(48 - unassignedBlocks) / 48.0) * 100)
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
    UnassignedTimeCard(unassignedBlocks: 15)
        .padding()
}
