//
//  ItemListOverlayView.swift
//  MiniList
//
//  Created by Neftali Samarey on 8/20/24.
//

import SwiftUI

public class ListViewModel: ObservableObject {

    @Published private(set) var items: [Item] = []

    var count: Int {
        items.count
    }

    func loadData() {
        let item1 = Item(name: "Popcorn", purchased: false, category: .none)
        let item2 = Item(name: "Bananas", purchased: false, category: .fruits)
        let item3 = Item(name: "Milk", purchased: false, category: .dairy)
        items.append(item1)
        items.append(item2)
        items.append(item3)
    }

    func add(item: Item) {
        items.append(item)
    }
}

public struct ItemListOverlayView: View {

    @ObservedObject var viewModel: ListViewModel

    public var body: some View {
        GeometryReader { geo in
            Color.clear
                .overlay(alignment: .bottom) {
                    content
                        .frame(width: geo.size.width, height: geo.size.height * 0.75)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
        }
    }

    private var content: some View {
        VStack {
            Text("Grocery List")
                .font(.system(size: 20, weight: .medium))
            List(viewModel.items) { item in
                ItemListView(text: item.name)
                    .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .listSectionSeparator(.hidden)
            .onAppear {
                self.viewModel.loadData()
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 10)
    }
}

#Preview {
    ItemListOverlayView(viewModel: .init())
}
