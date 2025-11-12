//
//  DateNavigationHeader.swift
//  TimeTracker
//
//  Created by Alexis Tatarkovic on 12/11/2025.
//

import SwiftUI

/// Header component for date navigation with prev/next buttons and date picker
struct DateNavigationHeader: View {
    let selectedDate: Date
    let isToday: Bool
    let onPrevious: () -> Void
    let onNext: () -> Void
    let onDateTap: () -> Void
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        formatter.locale = Locale(identifier: "fr_FR")
        return formatter
    }
    
    var body: some View {
        HStack(spacing: 16) {
            previousButton
            Spacer()
            dateDisplay
            Spacer()
            nextButton
        }
    }
    
    private var previousButton: some View {
        Button(action: onPrevious) {
            Image(systemName: "chevron.left")
                .font(.title3)
                .foregroundColor(.blue)
                .frame(width: 44, height: 44)
        }
    }
    
    private var nextButton: some View {
        Button(action: onNext) {
            Image(systemName: "chevron.right")
                .font(.title3)
                .foregroundColor(.blue)
                .frame(width: 44, height: 44)
        }
    }
    
    private var dateDisplay: some View {
        VStack(spacing: 4) {
            if isToday {
                todayBadge
            }
            
            dateButton
        }
    }
    
    private var todayBadge: some View {
        Text("Aujourd'hui")
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .background(Color.blue)
            .cornerRadius(12)
    }
    
    private var dateButton: some View {
        Button(action: onDateTap) {
            HStack(spacing: 6) {
                Text(dateFormatter.string(from: selectedDate))
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Image(systemName: "calendar")
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
        }
    }
}

#Preview {
    DateNavigationHeader(
        selectedDate: Date(),
        isToday: true,
        onPrevious: {},
        onNext: {},
        onDateTap: {}
    )
    .padding()
}
