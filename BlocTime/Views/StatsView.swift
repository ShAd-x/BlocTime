//
//  StatsView.swift
//  TimeTracker
//
//  Created by Alexis Tatarkovic on 12/11/2025.
//

import SwiftUI
import Charts

struct StatsView: View {
    @ObservedObject var viewModel: TimeViewModel
    @ObservedObject var categoryManager: CategoryManager
    @State private var chartType: ChartType = .pie
    @State private var statsPeriod: StatsPeriod = .day
    
    enum ChartType: String, CaseIterable {
        case pie = "Circulaire"
        case bar = "Barres"
    }
    
    enum StatsPeriod: String, CaseIterable {
        case day = "Jour"
        case week = "Semaine"
        case month = "Mois"
    }
    
    var stats: [UUID: Int] {
        switch statsPeriod {
        case .day:
            return viewModel.getStats()
        case .week:
            return viewModel.getWeekStats()
        case .month:
            return viewModel.getMonthStats()
        }
    }
    
    var totalBlocks: Int {
        stats.values.reduce(0, +)
    }
    
    var unassignedBlocks: Int {
        let blocksInPeriod: Int
        let blocksPerDay = viewModel.blocksPerDay
        switch statsPeriod {
        case .day:
            blocksInPeriod = blocksPerDay
        case .week:
            blocksInPeriod = blocksPerDay * 7
        case .month:
            blocksInPeriod = getDaysInMonth() * blocksPerDay
        }
        return blocksInPeriod - totalBlocks
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    if totalBlocks > 0 {
                        contentView
                    } else {
                        emptyStateView
                    }
                }
                .padding()
            }
            .navigationTitle("Statistiques")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var contentView: some View {
        VStack(spacing: 30) {
            // Period selector
            periodPicker
            
            // Unassigned time counter
            if unassignedBlocks > 0 {
                UnassignedTimeCard(
                    unassignedBlocks: unassignedBlocks,
                    totalBlocksInPeriod: {
                        let blocksPerDay = viewModel.blocksPerDay
                        switch statsPeriod {
                        case .day: return blocksPerDay
                        case .week: return blocksPerDay * 7
                        case .month: return getDaysInMonth() * blocksPerDay
                        }
                    }(),
                    blockDurationMinutes: viewModel.blockInterval.rawValue
                )
            }
            
            // Timeline visualization (only for day view)
            if statsPeriod == .day {
                TimelineVisualization(
                    blocks: viewModel.timeBlocks,
                    categoryManager: categoryManager,
                    selectedDate: viewModel.selectedDate
                )
            }
            
            // Chart type picker
            chartTypePicker
            
            // Chart display
            chartSection
            
            // Details by category
            detailsSection
        }
    }
    
    private var periodPicker: some View {
        Picker("Période", selection: $statsPeriod) {
            ForEach(StatsPeriod.allCases, id: \.self) { period in
                Text(period.rawValue).tag(period)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
    }
    
    private var chartTypePicker: some View {
        Picker("Type de graphique", selection: $chartType) {
            ForEach(ChartType.allCases, id: \.self) { type in
                Text(type.rawValue).tag(type)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
    }
    
    private var chartSection: some View {
        VStack(spacing: 15) {
            Text("Répartition du temps")
                .font(.title2)
                .fontWeight(.bold)
            
            if chartType == .pie {
                PieChartView(stats: stats, categoryManager: categoryManager, totalBlocks: totalBlocks)
            } else {
                BarChartView(stats: stats, categoryManager: categoryManager, blockDurationMinutes: viewModel.blockInterval.rawValue)
            }
            
            Text("Total: \(totalBlocks) blocs (\(String(format: "%.1f", Double(totalBlocks * viewModel.blockInterval.rawValue) / 60.0))h)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(15)
    }
    
    private var detailsSection: some View {
        VStack(spacing: 15) {
            Text("Détails")
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ForEach(stats.sorted(by: { $0.value > $1.value }), id: \.key) { item in
                if let category = categoryManager.getCategory(by: item.key) {
                    StatRow(
                        category: category,
                        blocks: item.value,
                        percentage: Double(item.value) / Double(totalBlocks),
                        blockDurationMinutes: viewModel.blockInterval.rawValue
                    )
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(15)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "chart.pie.fill")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.5))
            
            Text("Aucune donnée")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Commencez à enregistrer votre temps dans l'onglet \"Journée\"")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding(.top, 100)
    }
    
    // MARK: - Helpers
    
    private func getDaysInMonth() -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: viewModel.selectedDate)
        guard let monthStart = calendar.date(from: components),
              let range = calendar.range(of: .day, in: .month, for: monthStart) else {
            return 30
        }
        return range.count
    }
}

#Preview {
    StatsView(viewModel: TimeViewModel(), categoryManager: CategoryManager())
}
