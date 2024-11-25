//
//  ContentView.swift
//  MiniList
//
//  Created by Neftali Samarey on 8/20/24.
//

import SwiftUI
import CoreData

@objc
public enum ItemCategory: Int, CaseIterable {
    case `none` = 0
    case bank
    case dairy
    case fruits
    case meats
    case bakery
    case beauty

    var iconStringValue: String {
        switch self {
        case .none:
            return "None"
        case .bank:
            return "Bank"
        case .dairy:
            return "Milk"
        case .fruits:
            return "Fruits"
        case .meats:
            return "Meats"
        case .bakery:
            return "Bakery"
        case .beauty:
            return "Shampoo"
        }
    }

    var title: String {
        switch self {
        case .none:
            return "None"
        case .bank:
            return "Bank"
        case .dairy:
            return "Dairy"
        case .fruits:
            return "Fruits"
        case .meats:
            return "Meats"
        case .bakery:
            return "Bakery"
        case .beauty:
            return "Beauty"
        }
    }
}

extension Checklist {

    /*var itemCategory: ItemCategory {
        get {
            return ItemCategory(rawValue: Int(self.itemCategory.rawValue)) ?? .none
        }
        set {
            self.itemCategory = Int64(newValue.rawValue)
        }
    }*/
}

public struct Item: Identifiable {
    public let id = UUID()
    public let name: String
    public let purchased: Bool
    public let category: ItemCategory
}

struct ContentView: View {

    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var viewModel = ListViewModel() // Create the shared viewModel

    @State private var yOffset: CGFloat = 0
    @State private var hasToggledAddMode: Bool = false   // modal visibility
    @State private var isFieldVisible: Bool = false      // field visibility
    @State private var text: String = String() //revert
    @State private var categoryString: String = ""
    @State private var keyboardHeight: CGFloat = 0
    @State private var categorySelection: ItemCategory = .none

    // Core Data
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Checklist.name, ascending: true)],
        animation: .default)
    private var checklist: FetchedResults<Checklist>

    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                List {
                    ForEach(checklist, id: \.self) { item in
                        ItemListView(category: .bakery, text: item.name ?? "No Name")
                            .listRowSeparator(.hidden)
                            .listRowBackground(colorScheme == .dark ? Color.backgroundDarkOverlay : Color.white)
                    }
                    .onDelete(perform: deleteItem)
                }
                .scrollIndicators(ScrollIndicatorVisibility.visible)
                .listStyle(.plain)
                .listSectionSeparator(.hidden)
                .animation(.spring(.bouncy, blendDuration: 0.9), value: self.viewModel.count > 0)
                .navigationTitle("MiniList")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("MiniList")
                            .font(.custom("Merriweather-Bold", size: 20.0))
                    }

                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            presentModalView()
                        } label: {
                            Image(systemName: "plus")
                                .foregroundColor(Color.backgroundDark)
                        }
                        .sensoryFeedback(.selection, trigger: hasToggledAddMode)
                    }
                }
            }
            .onAppear {
                self.viewModel.loadData()
            }
            .sheet(isPresented: $hasToggledAddMode) {
                modalSheetContent
                    .presentationDetents([.medium, .large])
            }
        }
    }

    private var modalSheetContent: some View {
        VStack(alignment: .leading, spacing: 25) {
            headerView
            contentFieldView
            categoryGridView
            Spacer()
            addItemButtonView
        }
        .padding(.vertical, 26)
        .padding(.horizontal, 26)
        .onAppear {
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
                if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                    self.keyboardHeight = keyboardFrame.height
                }
            }
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                self.keyboardHeight = 0
            }
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    }

    // MARK: - Header
    private var headerView: some View {
        HStack {
            Text("New Item")
                .font(.custom("Merriweather-Bold", size: 22))

            Spacer()

            Button {
                hasToggledAddMode.toggle()
            } label: {
                ZStack {
                    Circle()
                        .fill(Color(white: colorScheme == .dark ? 0.19 : 0.93))
                    Image(systemName: "xmark")
                        .resizable()
                        .scaledToFit()
                        .font(Font.body.weight(.bold))
                        .scaleEffect(0.416)
                        .foregroundColor(Color(white: colorScheme == .dark ? 0.62 : 0.51))
                }
            }
            .frame(width: 26, height: 26)
            .sensoryFeedback(.selection, trigger: hasToggledAddMode)
        }
    }

    // MARK: - Content
    private var contentFieldView: some View {
        VStack(alignment: .leading ,spacing: 10) {
            Text("Title")
                .font(.custom("Merriweather-Regular", size: 15.0))

            TextField("Ground Coffee", text: $text)
                .font(.custom("Merriweather-Regular", size: 15.0))
                .textInputAutocapitalization(.words)
                .padding(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.7), lineWidth: 1)
                )
                .onAppear {
                    UITextField.appearance().clearButtonMode = .whileEditing
                }
                .onDisappear {
                    // cleanup
                    text = ""
                }
        }
    }

    // MARK: - Category Grid
    private var categoryGridView: some View {
        VStack(alignment: .leading ,spacing: 10) {
            Text("Category")
                .font(.custom("Merriweather-Regular", size: 15.0))

            CategoryPickerView { categorySelection in
                self.categorySelection = categorySelection
            }
        }
    }

    // MARK: - Add CTA
    private var addItemButtonView: some View {
        Button {
            guard !text.isEmpty else { return }
            createListing(with: text, category: self.categorySelection)
            hasToggledAddMode.toggle()
        } label: {
            Text("Add to List")
                .font(.custom("Merriweather-Bold", size: 16.0))
                .foregroundColor(.white)
                .padding(.vertical, 12)
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity)
                .background(text.isEmpty ? Color.gray.opacity(0.7) : Color.black)
                .cornerRadius(25)
        }
        .animation(.easeOut(duration: 0.3), value: keyboardHeight)
        .disabled(text.isEmpty)
    }

    // MARK: - UI Component
    private func presentModalView() {
        hasToggledAddMode.toggle()
    }

    // MARK: Core Data Create & Delete
    private func createListing(with title: String, category: ItemCategory) {
        let newItem = Checklist(context: self.viewContext)
        newItem.name = title
        //newItem.category = category.rawValue

        do {
            try self.viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }

    private func deleteItem(at offsets: IndexSet) {
        for index in offsets {
            let checklistItem = checklist[index]
            viewContext.delete(checklistItem)
        }

        do {
            try self.viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }

    // MARK: - UI Configurations
    private func cardOffsetConfiguration(with value: CGFloat) -> CGFloat {
        //guard viewModel.count < 1 else { return value * 1 } // full screen
        if viewModel.count > 0 {
            if !hasToggledAddMode {
                return value * 0.20
            } else {
                return yOffset
            }
        } else {
            return value * 0.10
        }
    }
}

#Preview {
    ContentView()
}
