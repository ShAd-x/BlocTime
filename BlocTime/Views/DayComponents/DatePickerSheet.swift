//
//  DatePickerSheet.swift
//  TimeTracker
//
//  Created by Alexis Tatarkovic on 12/11/2025.
//

import SwiftUI

/// Modal sheet for selecting a date using graphical calendar picker
struct DatePickerSheet: View {
    let selectedDate: Date
    let onDateSelected: (Date) -> Void
    
    @Environment(\.dismiss) var dismiss
    @State private var tempDate: Date
    
    init(selectedDate: Date, onDateSelected: @escaping (Date) -> Void) {
        self.selectedDate = selectedDate
        self.onDateSelected = onDateSelected
        self._tempDate = State(initialValue: selectedDate)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                datePicker
                confirmButton
                Spacer()
            }
            .navigationTitle("Choisir une date")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    cancelButton
                }
            }
        }
    }
    
    private var datePicker: some View {
        DatePicker(
            "Sélectionner une date",
            selection: $tempDate,
            displayedComponents: [.date]
        )
        .datePickerStyle(.graphical)
        .padding()
    }
    
    private var confirmButton: some View {
        Button(action: {
            onDateSelected(tempDate)
        }) {
            Text("Confirmer")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(12)
        }
        .padding(.horizontal)
    }
    
    private var cancelButton: some View {
        Button("Annuler") {
            dismiss()
        }
    }
}

#Preview {
    DatePickerSheet(selectedDate: Date()) { _ in }
}
