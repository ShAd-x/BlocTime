//
//  TimeViewModel.swift
//  TimeTracker
//
//  Created by Alexis Tatarkovic on 12/11/2025.
//

import Foundation
import SwiftUI
import Combine

class TimeViewModel: ObservableObject {
    // MARK: - Published Properties
    
    /// Multi-date storage: Dictionary keyed by date string (YYYY-MM-DD)
    @Published var allDaysData: [String: [TimeBlock]] = [:]
    
    /// Currently selected date for viewing/editing
    @Published var selectedDate: Date = Date()
    
    /// Time interval for blocks (15, 30, or 60 minutes)
    @Published var blockInterval: BlockInterval = .thirtyMinutes
    
    // Reference to CategoryManager
    let categoryManager: CategoryManager
    
    // MARK: - Constants
    
    private let userDefaultsKey = "allDaysData"
    private let intervalKey = "blockInterval"
    
    // MARK: - Computed Properties
    
    var blocksPerDay: Int {
        return blockInterval.blocksPerDay
    }
    
    // MARK: - Computed Properties
    
    /// Returns blocks for the currently selected date
    var timeBlocks: [TimeBlock] {
        let dateKey = dateToKey(selectedDate)
        return allDaysData[dateKey] ?? generateBlocks(for: selectedDate)
    }
    
    /// Check if selected date is today
    var isToday: Bool {
        Calendar.current.isDateInToday(selectedDate)
    }
    
    // MARK: - Initialization
    
    init() {
        self.categoryManager = CategoryManager()
        loadBlockInterval()
        loadAllDaysData()
        ensureBlocksExist(for: selectedDate)
    }
    
    // MARK: - Date Management
    
    /// Navigate to previous day
    func previousDay() {
        guard let previousDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate) else {
            return
        }
        selectDate(previousDate)
    }
    
    /// Navigate to next day
    func nextDay() {
        guard let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate) else {
            return
        }
        selectDate(nextDate)
    }
    
    /// Change selected date and ensure blocks exist
    func selectDate(_ date: Date) {
        selectedDate = date
        ensureBlocksExist(for: date)
        objectWillChange.send()
    }
    
    // MARK: - Block Management
    
    /// Update the category of a specific block
    func updateBlock(id: UUID, categoryId: UUID?) {
        let dateKey = dateToKey(selectedDate)
        guard var blocks = allDaysData[dateKey],
              let index = blocks.firstIndex(where: { $0.id == id }) else {
            return
        }
        
        blocks[index] = TimeBlock(
            id: blocks[index].id,
            hour: blocks[index].hour,
            minute: blocks[index].minute,
            categoryId: categoryId,
            date: blocks[index].date,
            duration: blocks[index].duration
        )
        
        allDaysData[dateKey] = blocks
        saveAllDaysData()
        objectWillChange.send()
    }
    
    /// Update multiple blocks with the same category
    func updateBlocks(ids: [UUID], categoryId: UUID?) {
        let dateKey = dateToKey(selectedDate)
        guard var blocks = allDaysData[dateKey] else {
            return
        }
        
        for id in ids {
            if let index = blocks.firstIndex(where: { $0.id == id }) {
                blocks[index] = TimeBlock(
                    id: blocks[index].id,
                    hour: blocks[index].hour,
                    minute: blocks[index].minute,
                    categoryId: categoryId,
                    date: blocks[index].date,
                    duration: blocks[index].duration
                )
            }
        }
        
        allDaysData[dateKey] = blocks
        saveAllDaysData()
        objectWillChange.send()
    }
    
    /// Reset all blocks for the selected date to unassigned
    func resetDay() {
        let dateKey = dateToKey(selectedDate)
        allDaysData[dateKey] = generateBlocks(for: selectedDate)
        saveAllDaysData()
        objectWillChange.send()
    }
    
    /// Generate blocks for the selected date if they don't exist
    func generateDayBlocks() {
        let dateKey = dateToKey(selectedDate)
        allDaysData[dateKey] = generateBlocks(for: selectedDate)
        saveAllDaysData()
        objectWillChange.send()
    }
    
    /// Change the block interval and regenerate all blocks for the current day
    func changeBlockInterval(_ newInterval: BlockInterval) {
        blockInterval = newInterval
        saveBlockInterval()
        
        // Regenerate blocks for the selected date
        let dateKey = dateToKey(selectedDate)
        allDaysData[dateKey] = generateBlocks(for: selectedDate)
        saveAllDaysData()
        objectWillChange.send()
    }
    
    // MARK: - Statistics
    
    /// Get statistics by category for the selected date
    func getStats() -> [UUID: Int] {
        return calculateStats(for: timeBlocks)
    }
    
    /// Get statistics aggregated over a week starting from the selected date
    func getWeekStats() -> [UUID: Int] {
        let calendar = Calendar.current
        guard let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: selectedDate)) else {
            return [:]
        }
        
        var aggregatedStats: [UUID: Int] = [:]
        
        for dayOffset in 0..<7 {
            guard let date = calendar.date(byAdding: .day, value: dayOffset, to: weekStart) else {
                continue
            }
            
            let dateKey = dateToKey(date)
            guard let blocks = allDaysData[dateKey] else { continue }
            
            let dayStats = calculateStats(for: blocks)
            for (categoryId, count) in dayStats {
                aggregatedStats[categoryId, default: 0] += count
            }
        }
        
        return aggregatedStats
    }
    
    /// Get statistics aggregated over a month containing the selected date
    func getMonthStats() -> [UUID: Int] {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: selectedDate)
        guard let monthStart = calendar.date(from: components),
              let monthRange = calendar.range(of: .day, in: .month, for: monthStart) else {
            return [:]
        }
        
        var aggregatedStats: [UUID: Int] = [:]
        
        for day in monthRange {
            var dayComponents = components
            dayComponents.day = day
            guard let date = calendar.date(from: dayComponents) else {
                continue
            }
            
            let dateKey = dateToKey(date)
            guard let blocks = allDaysData[dateKey] else { continue }
            
            let dayStats = calculateStats(for: blocks)
            for (categoryId, count) in dayStats {
                aggregatedStats[categoryId, default: 0] += count
            }
        }
        
        return aggregatedStats
    }
    
    // MARK: - Private Helpers
    
    /// Convert Date to string key (YYYY-MM-DD)
    private func dateToKey(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    /// Ensure blocks exist for a given date
    private func ensureBlocksExist(for date: Date) {
        let dateKey = dateToKey(date)
        if allDaysData[dateKey] == nil || allDaysData[dateKey]?.count != blocksPerDay {
            allDaysData[dateKey] = generateBlocks(for: date)
            saveAllDaysData()
        }
    }
    
    /// Generate blocks for a specific date based on the current interval
    private func generateBlocks(for date: Date) -> [TimeBlock] {
        var blocks: [TimeBlock] = []
        let dayStart = Calendar.current.startOfDay(for: date)
        let minutes = blockInterval.minutesInHour()
        
        for hour in 0...23 {
            for minute in minutes {
                let block = TimeBlock(
                    hour: hour,
                    minute: minute,
                    date: dayStart,
                    duration: blockInterval.rawValue
                )
                blocks.append(block)
            }
        }
        
        return blocks
    }
    
    /// Calculate statistics from a list of blocks
    private func calculateStats(for blocks: [TimeBlock]) -> [UUID: Int] {
        var stats: [UUID: Int] = [:]
        
        for block in blocks {
            if let categoryId = block.categoryId {
                stats[categoryId, default: 0] += 1
            }
        }
        
        return stats
    }
    
    // MARK: - UserDefaults Persistence
    
    private func saveAllDaysData() {
        if let encoded = try? JSONEncoder().encode(allDaysData) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    private func loadAllDaysData() {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey),
              let decoded = try? JSONDecoder().decode([String: [TimeBlock]].self, from: data) else {
            return
        }
        allDaysData = decoded
    }
    
    private func saveBlockInterval() {
        UserDefaults.standard.set(blockInterval.rawValue, forKey: intervalKey)
    }
    
    private func loadBlockInterval() {
        if let savedInterval = UserDefaults.standard.value(forKey: intervalKey) as? Int,
           let interval = BlockInterval(rawValue: savedInterval) {
            blockInterval = interval
        }
    }
}
