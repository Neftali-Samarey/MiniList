//
//  ContentView.swift
//  MiniList
//
//  Created by Neftali Samarey on 8/20/24.
//

import SwiftUI

public enum ItemCategory: String, CaseIterable {
    case `none`
    case dairy
    case fruits
    case meats
    case bakery
}

public struct Item: Identifiable {
    public let id = UUID()
    public let name: String
    public let purchased: Bool
    public let category: ItemCategory
}

struct ContentView: View {

    // Overvable ViewModel
    @State var yOffset: CGFloat = 0
    @ObservedObject var listViewModel: ListViewModel = .init()

    var body: some View {
        // main content view
        ZStack {
            Color.primaryCream

            // overlay anchor view
            ItemListOverlayView(viewModel: .init())
                .shadow(color: Color.gray.opacity(0.5) ,radius: 1.8)
                .offset(y: yOffset)
        }
        .ignoresSafeArea(.all)
        .onTapGesture {
            /*withAnimation(.easeInOut(duration: 0.5)) {
                yOffset += 600
            }*/
        }

        /*VStack {
            OverviewProgressView()
                .padding(.horizontal, 10)

            List(viewModel.items) { item in
                ItemListView(text: item.name)
                    .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .listSectionSeparator(.hidden)
            .onAppear {
                self.viewModel.loadData()
            }

            Button(action: {
                viewModel.add(item: Item(name: "Pie"))
            }, label: {
                Text("Add")
            })
        }*/
    }
}

#Preview {
    ContentView()
}
