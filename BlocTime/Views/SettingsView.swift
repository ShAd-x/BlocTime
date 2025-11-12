//
//  SettingsView.swift
//  TimeTracker
//
//  Created by Alexis Tatarkovic on 12/11/2025.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: TimeViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showIntervalChangeAlert = false
    @State private var pendingInterval: BlockInterval?
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    ForEach(BlockInterval.allCases, id: \.self) { interval in
                        HStack {
                            Text(interval.emoji)
                                .font(.title2)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(interval.displayName)
                                    .font(.body)
                                
                                Text("\(interval.blocksPerDay) blocs par jour")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            if viewModel.blockInterval == interval {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.accentColor)
                                    .fontWeight(.semibold)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if viewModel.blockInterval != interval {
                                pendingInterval = interval
                                showIntervalChangeAlert = true
                            }
                        }
                    }
                } header: {
                    Text("Intervalle de temps")
                } footer: {
                    Text("Choisissez la durée de chaque bloc de temps. Attention : changer cet intervalle supprimera TOUTES vos données existantes.")
                }
            }
            .navigationTitle("Paramètres")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fermer") {
                        dismiss()
                    }
                }
            }
            .alert("Changer l'intervalle de temps ?", isPresented: $showIntervalChangeAlert) {
                Button("Annuler", role: .cancel) {
                    pendingInterval = nil
                }
                Button("Changer", role: .destructive) {
                    if let newInterval = pendingInterval {
                        viewModel.changeBlockInterval(newInterval)
                        pendingInterval = nil
                    }
                }
            } message: {
                Text("Cette action supprimera TOUTES vos données de catégories pour tous les jours. Cette action est irréversible.")
            }
        }
    }
}

// MARK: - Preview
#Preview {
    SettingsView(viewModel: TimeViewModel())
}
