//
//  CategoryPickerView.swift
//  MiniList
//
//  Created by Neftali Samarey on 9/4/24.
//

import SwiftUI

public struct CategoryPickerView: View {

    //@State private var categorySelection: ItemCategory = .none
    @State private var selectedCategory: ItemCategory?
    var action: ((ItemCategory) -> Void)? = nil

    public init(action: ((ItemCategory) -> Void)? = nil) {
        self.action = action
    }

    private var columns: [GridItem] = [
            GridItem(.fixed(80), spacing: 10),
            GridItem(.fixed(80), spacing: 10),
            GridItem(.fixed(80), spacing: 10),
            GridItem(.fixed(80), spacing: 10)
        ]

    public var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                Section {
                    ForEach(ItemCategory.allCases, id: \.self) { category in
                        CategoryItemView(category: category, selectedCategory: $selectedCategory) { selection in
                            guard let action = self.action else { return }
                            action(selection)
                        }
                        .frame(height: 80)
                    }
                }
            }
        }
    }
}

public struct CategoryItemView: View {

    let category: ItemCategory
    @Binding var selectedCategory: ItemCategory?
    var action: ((ItemCategory) -> Void)? = nil

    @State private var isOptionSelected: Bool = false

    public init(category: ItemCategory, selectedCategory: Binding<ItemCategory?>, action: ((ItemCategory) -> Void)? = nil) {
        self.category = category
        self._selectedCategory = selectedCategory
        self.action = action
    }

    public var body: some View {
        Color.clear
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(selectedCategory == category ? Color.black.opacity(1) : Color.gray.opacity(0.7), lineWidth: selectedCategory == category ? 1.5 : 0.5)
                    .overlay {
                        VStack {
                            iconImageView
                            Text(category.title)
                                .font(.custom("Merriweather-Regular", size: 12.5))
                        }
                    }
            }
            .onTapGesture {
                if selectedCategory == category {
                    selectedCategory = nil // Deselect if tapped again
                } else {
                    selectedCategory = category // Select new category
                }
                action?(category)
            }
            .padding(.vertical, 2)
            .padding(.horizontal, 2)
            .sensoryFeedback(.selection, trigger: selectedCategory)
    }

    private var iconImageView: some View {
        Image(category.iconStringValue)
            .frame(width: 36, height: 36)
    }
}

#Preview {
    CategoryPickerView()
}
