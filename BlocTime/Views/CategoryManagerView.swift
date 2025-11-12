//
//  CategoryManagerView.swift
//  TimeTracker
//
//  Created by Alexis Tatarkovic on 12/11/2025.
//

import SwiftUI

struct CategoryManagerView: View {
    @ObservedObject var categoryManager: CategoryManager
    @Environment(\.dismiss) var dismiss
    @State private var showingAddCategory = false
    @State private var editingCategory: CustomCategory?
    @State private var showResetAlert = false
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(categoryManager.categories) { category in
                        CategoryRow(category: category)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                editingCategory = category
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                if !category.isDefault {
                                    Button(role: .destructive) {
                                        categoryManager.deleteCategory(category)
                                    } label: {
                                        Label("Supprimer", systemImage: "trash")
                                    }
                                }
                            }
                    }
                }
                
                Section {
                    Button(role: .destructive) {
                        showResetAlert = true
                    } label: {
                        HStack {
                            Spacer()
                            Text("Réinitialiser aux catégories par défaut")
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Gérer les catégories")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Fermer") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddCategory = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddCategory) {
                CategoryEditorView(categoryManager: categoryManager, category: nil)
            }
            .sheet(item: $editingCategory) { category in
                CategoryEditorView(categoryManager: categoryManager, category: category)
            }
            .alert("Réinitialiser les catégories ?", isPresented: $showResetAlert) {
                Button("Annuler", role: .cancel) { }
                Button("Réinitialiser", role: .destructive) {
                    categoryManager.resetToDefaults()
                }
            } message: {
                Text("Cette action remplacera toutes vos catégories actuelles par les 19 catégories par défaut. Les blocs déjà assignés perdront leur catégorie.")
            }
        }
    }
}

// MARK: - Category Row
struct CategoryRow: View {
    let category: CustomCategory
    
    var body: some View {
        HStack(spacing: 12) {
            Text(category.emoji)
                .font(.title2)
            
            Text(category.name)
                .font(.body)
            
            Spacer()
            
            Circle()
                .fill(category.color)
                .frame(width: 24, height: 24)
            
            if category.isDefault {
                Text("Par défaut")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Category Editor
struct CategoryEditorView: View {
    @ObservedObject var categoryManager: CategoryManager
    let category: CustomCategory?
    
    @Environment(\.dismiss) var dismiss
    @State private var name: String = ""
    @State private var emoji: String = ""
    @State private var selectedColor: Color = .blue
    
    private var isEditing: Bool {
        category != nil
    }
    
    private var canSave: Bool {
        !name.isEmpty && !emoji.isEmpty
    }
    
    // Predefined color palette
    private let colorPalette: [Color] = [
        .blue, .green, .orange, .red, .pink, .purple,
        .yellow, .cyan, .mint, .indigo, .teal, .brown,
        Color(red: 0.2, green: 0.2, blue: 0.2)
    ]
    
    var body: some View {
        NavigationView {
            Form {
                Section("Informations") {
                    TextField("Nom de la catégorie", text: $name)
                    
                    HStack {
                        Text("Emoji")
                        Spacer()
                        TextField("", text: $emoji)
                            .multilineTextAlignment(.trailing)
                            .font(.title)
                            .onChange(of: emoji) { oldValue, newValue in
                                // Limit to first emoji
                                if newValue.count > 2 {
                                    emoji = String(newValue.prefix(2))
                                }
                            }
                    }
                }
                
                Section("Couleur") {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))], spacing: 15) {
                        ForEach(colorPalette.indices, id: \.self) { index in
                            Circle()
                                .fill(colorPalette[index])
                                .frame(width: 50, height: 50)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 3)
                                        .opacity(colorPalette[index] == selectedColor ? 1 : 0)
                                )
                                .onTapGesture {
                                    selectedColor = colorPalette[index]
                                }
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                if isEditing && category?.isDefault == false {
                    Section {
                        Button(role: .destructive) {
                            if let category = category {
                                categoryManager.deleteCategory(category)
                                dismiss()
                            }
                        } label: {
                            HStack {
                                Spacer()
                                Text("Supprimer la catégorie")
                                Spacer()
                            }
                        }
                    }
                }
            }
            .navigationTitle(isEditing ? "Modifier" : "Nouvelle catégorie")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Annuler") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Enregistrer") {
                        saveCategory()
                    }
                    .disabled(!canSave)
                }
            }
            .onAppear {
                if let category = category {
                    name = category.name
                    emoji = category.emoji
                    selectedColor = category.color
                }
            }
        }
    }
    
    private func saveCategory() {
        let colorHex = selectedColor.toHex() ?? "#007AFF"
        
        if let existingCategory = category {
            // Update existing
            let updated = CustomCategory(
                id: existingCategory.id,
                name: name,
                emoji: emoji,
                colorHex: colorHex,
                isDefault: existingCategory.isDefault
            )
            categoryManager.updateCategory(updated)
        } else {
            // Create new
            let newCategory = CustomCategory(
                name: name,
                emoji: emoji,
                colorHex: colorHex,
                isDefault: false
            )
            categoryManager.addCategory(newCategory)
        }
        
        dismiss()
    }
}

#Preview {
    CategoryManagerView(categoryManager: CategoryManager())
}
