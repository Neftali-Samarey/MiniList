//
//  ContentView.swift
//  MiniList
//
//  Created by Neftali Samarey on 8/20/24.
//

import SwiftUI
import CoreData
import Lottie


public enum ItemCategory: String, CaseIterable {
    case `none`
    case bank
    case dairy
    case fruits
    case meats
    case bakery
    case beauty
    case pet

    var imageName: String {
        return self.rawValue
    }

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
        case .pet:
            return "Pet"
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
        case .pet:
            return "Pets"
        }
    }
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

    // test
    @State private var categoryIndexedSelections = 0

    private func mapItemCategoryAsset(with checklist: Checklist) -> ItemCategory {
        guard let itemCategory = checklist.itemCategory else { return .none }
        return itemCategory.self
    }

    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                VStack {
                    if !checklist.isEmpty {
                        VStack {
                            Picker("What is your favorite color?", selection: $categoryIndexedSelections) {
                                Text("All").tag(0)
                                Text("Completed").tag(1)
                            }
                            .pickerStyle(.segmented)
                        }
                        .padding(.horizontal, 15)

                        List {
                            ForEach(checklist, id: \.self) { item in
                                ItemListView(category: mapItemCategoryAsset(with: item), text: item.name ?? "No Name")
                                    .listRowSeparator(.hidden)
                                    .listRowBackground(colorScheme == .dark ? Color.backgroundDarkOverlay : Color.white)
                            }
                            .onDelete(perform: deleteItem)
                        }
                        .scrollIndicators(ScrollIndicatorVisibility.visible)
                        .listStyle(.plain)
                        .listSectionSeparator(.hidden)
                        .animation(.spring(.bouncy, blendDuration: 0.9), value: self.viewModel.count > 0)
                    } else {
                        VStack(spacing: 10) {
                            LottieView(animationName: LottieFileManager.animation(with: .empty))
                                .frame(height: geometry.size.height / 3)
                                .overlay(alignment: .bottom) {
                                    Text(allGoodTitle)
                                        .font(.custom("Merriweather-Regular", size: 22))
                                        .foregroundStyle(colorScheme == .dark ? Color.white : Color.black.opacity(0.45))
                                }
                        }
                    }
                }
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
        newItem.id = UUID()
        newItem.name = title
        newItem.category = category.rawValue.data(using: .utf8)

        /*if let uiImage = UIImage(named: category.iconStringValue),
           let imageData = uiImage.pngData() {
            newItem.category = imageData
        }*/

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

extension ContentView {

    var allGoodTitle: String {
        "All Goods!"
    }
}
