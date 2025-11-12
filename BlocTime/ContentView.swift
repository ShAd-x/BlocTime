//
//  ContentView.swift
//  TimeTracker
//
//  Created by Alexis Tatarkovic on 12/11/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var categoryManager = CategoryManager()
    @StateObject private var viewModel = TimeViewModel()
    
    var body: some View {
        TabView {
            DayView(viewModel: viewModel, categoryManager: categoryManager)
                .tabItem {
                    Label("Journée", systemImage: "calendar")
                }
            
            StatsView(viewModel: viewModel, categoryManager: categoryManager)
                .tabItem {
                    Label("Stats", systemImage: "chart.pie.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}
