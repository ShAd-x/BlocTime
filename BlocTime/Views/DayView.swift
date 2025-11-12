//
//  DayView.swift
//  TimeTracker
//
//  Created by Alexis Tatarkovic on 12/11/2025.
//

import SwiftUI

struct DayView: View {
    @ObservedObject var viewModel: TimeViewModel
    @ObservedObject var categoryManager: CategoryManager
    @State private var selectedBlock: TimeBlock?
    @State private var showDatePicker = false
    @State private var showCategoryManager = false
    @State private var isSelectionMode = false
    @State private var selectedBlocks: Set<UUID> = []
    @State private var showResetAlert = false
    @State private var showSettings = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                VStack(spacing: 0) {
                    // Date navigation header
                    DateNavigationHeader(
                        selectedDate: viewModel.selectedDate,
                        isToday: viewModel.isToday,
                        onPrevious: { viewModel.previousDay() },
                        onNext: { viewModel.nextDay() },
                        onDateTap: { showDatePicker = true }
                    )
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                    .background(Color(.systemBackground))
                    
                    Divider()
                    
                    // ScrollViewReader for auto-scroll functionality
                    ScrollViewReader { proxy in
                        ScrollView {
                            VStack(spacing: 20) {
                                ForEach(TimePeriod.allCases, id: \.self) { period in
                                    PeriodSection(
                                        period: period,
                                        blocks: blocksForPeriod(period),
                                        categoryManager: categoryManager,
                                        isSelectionMode: isSelectionMode,
                                        selectedBlocks: $selectedBlocks,
                                        onBlockTap: { block in
                                            handleBlockTap(block)
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 12)
                            .padding(.bottom, isSelectionMode ? 100 : 0)
                        }
                        .onAppear {
                            // Auto-scroll to current time if viewing today
                            if viewModel.isToday {
                                scrollToCurrentTime(proxy: proxy)
                            }
                        }
                    }
                }
                
                // Selection action bar
                if isSelectionMode {
                    SelectionActionBar(
                        selectedCount: selectedBlocks.count,
                        categoryManager: categoryManager,
                        onCategorySelected: { categoryId in
                            viewModel.updateBlocks(ids: Array(selectedBlocks), categoryId: categoryId)
                            exitSelectionMode()
                        },
                        onCancel: {
                            exitSelectionMode()
                        }
                    )
                    .transition(.move(edge: .bottom))
                }
            }
            .navigationTitle("Ma journée")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if isSelectionMode {
                        Button("Annuler") {
                            exitSelectionMode()
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    if isSelectionMode {
                        Button("Tout") {
                            selectAll()
                        }
                    } else {
                        Menu {
                            Button(action: {
                                showSettings = true
                            }) {
                                Label("Paramètres", systemImage: "gearshape")
                            }
                            
                            Button(action: {
                                showCategoryManager = true
                            }) {
                                Label("Gérer les catégories", systemImage: "square.grid.2x2")
                            }
                            
                            Divider()
                            
                            Button(action: {
                                isSelectionMode = true
                            }) {
                                Label("Sélection multiple", systemImage: "checkmark.circle")
                            }
                            
                            Button(action: {
                                showResetAlert = true
                            }) {
                                Label("Réinitialiser", systemImage: "arrow.counterclockwise")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                    }
                }
            }
        }
        .sheet(item: $selectedBlock) { block in
            CategoryPickerView(
                block: block,
                viewModel: viewModel,
                categoryManager: categoryManager,
                isPresented: Binding(
                    get: { selectedBlock != nil },
                    set: { if !$0 { selectedBlock = nil } }
                )
            )
            .presentationDetents([.medium, .large])
        }
        .sheet(isPresented: $showDatePicker) {
            DatePickerSheet(
                selectedDate: viewModel.selectedDate,
                onDateSelected: { date in
                    viewModel.selectDate(date)
                    showDatePicker = false
                }
            )
        }
        .sheet(isPresented: $showCategoryManager) {
            CategoryManagerView(categoryManager: categoryManager)
        }
        .sheet(isPresented: $showSettings) {
            SettingsView(viewModel: viewModel)
        }
        .alert("Réinitialiser la journée ?", isPresented: $showResetAlert) {
            Button("Annuler", role: .cancel) { }
            Button("Réinitialiser", role: .destructive) {
                viewModel.resetDay()
            }
        } message: {
            Text("Cette action supprimera toutes les catégories assignées aux blocs de cette journée.")
        }
    }
    
    // Filter blocks for a specific period
    private func blocksForPeriod(_ period: TimePeriod) -> [TimeBlock] {
        viewModel.timeBlocks.filter { block in
            period.hourRange.contains(block.hour)
        }
    }
    
    // Handle block tap (single selection or multi-selection)
    private func handleBlockTap(_ block: TimeBlock) {
        if isSelectionMode {
            if selectedBlocks.contains(block.id) {
                selectedBlocks.remove(block.id)
            } else {
                selectedBlocks.insert(block.id)
            }
        } else {
            selectedBlock = block
        }
    }
    
    // Exit selection mode
    private func exitSelectionMode() {
        isSelectionMode = false
        selectedBlocks.removeAll()
    }
    
    // Select all blocks
    private func selectAll() {
        selectedBlocks = Set(viewModel.timeBlocks.map { $0.id })
    }
    
    // Scroll to current time block
    private func scrollToCurrentTime(proxy: ScrollViewProxy) {
        let calendar = Calendar.current
        let now = Date()
        let currentHour = calendar.component(.hour, from: now)
        let currentMinute = calendar.component(.minute, from: now)
        
        // Find the closest block
        if let currentBlock = viewModel.timeBlocks.first(where: { block in
            block.hour == currentHour && (currentMinute < 30 ? block.minute == 0 : block.minute == 30)
        }) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation {
                    proxy.scrollTo(currentBlock.id, anchor: .center)
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    DayView(viewModel: TimeViewModel(), categoryManager: CategoryManager())
}
