//
//  CategoryPickerView.swift
//  TimeTracker
//
//  Created by Alexis Tatarkovic on 12/11/2025.
//

import SwiftUI

struct CategoryPickerView: View {
    let block: TimeBlock
    @ObservedObject var viewModel: TimeViewModel
    @ObservedObject var categoryManager: CategoryManager
    @Binding var isPresented: Bool
    @State private var searchText = ""
    
    var filteredCategories: [CustomCategory] {
        if searchText.isEmpty {
            return categoryManager.categories
        } else {
            return categoryManager.categories.filter { category in
                category.name.localizedCaseInsensitiveContains(searchText) ||
                category.emoji.contains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Choisir une catégorie")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top)
                
                Text(block.displayText)
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                // Search field
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Rechercher une catégorie...", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(10)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)
                
                Divider()
                    .padding(.horizontal)
                
                if categoryManager.categories.isEmpty {
                    VStack(spacing: 20) {
                        ProgressView()
                        Text("Chargement des catégories...")
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(filteredCategories, id: \.id) { category in
                                CategoryButton(
                                    category: category,
                                    isSelected: block.categoryId == category.id
                                ) {
                                    viewModel.updateBlock(id: block.id, categoryId: category.id)
                                    isPresented = false
                                }
                            }
                            
                            if filteredCategories.isEmpty {
                                VStack(spacing: 12) {
                                    Image(systemName: "magnifyingglass")
                                        .font(.system(size: 48))
                                        .foregroundColor(.gray)
                                    Text("Aucune catégorie trouvée")
                                        .font(.headline)
                                        .foregroundColor(.secondary)
                                }
                                .padding(.top, 40)
                            }
                            
                            // Option pour retirer la catégorie
                            if block.categoryId != nil && searchText.isEmpty {
                                Button(action: {
                                    viewModel.updateBlock(id: block.id, categoryId: nil)
                                    isPresented = false
                                }) {
                                    HStack {
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.title2)
                                        Text("Retirer la catégorie")
                                            .font(.headline)
                                        Spacer()
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.red.opacity(0.1))
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.red.opacity(0.3), lineWidth: 1)
                                    )
                                }
                                .foregroundColor(.red)
                                .padding(.top, 8)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isPresented = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
}

struct CategoryButton: View {
    let category: CustomCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Text(category.emoji)
                    .font(.system(size: 32))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(category.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Rectangle()
                        .fill(category.color)
                        .frame(height: 4)
                        .cornerRadius(2)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(category.color)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? category.color.opacity(0.15) : Color.gray.opacity(0.05))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? category.color : Color.clear, lineWidth: 2)
            )
        }
    }
}

#Preview {
    CategoryPickerView(
        block: TimeBlock(hour: 9, minute: 0),
        viewModel: TimeViewModel(),
        categoryManager: CategoryManager(),
        isPresented: .constant(true)
    )
}
