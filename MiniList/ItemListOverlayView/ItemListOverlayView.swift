//
//  ItemListOverlayView.swift
//  MiniList
//
//  Created by Neftali Samarey on 8/20/24.
//

import SwiftUI
import UIKit

public class ListViewModel: ObservableObject {

    @Published private(set) var items: [Item] = []

    var count: Int {
        items.count
    }

    func loadData() {
        let item1 = Item(name: "Wonder Bread", purchased: false, category: .bakery)
        let item2 = Item(name: "Apples", purchased: false, category: .fruits)
        let item3 = Item(name: "Milk", purchased: false, category: .dairy)
        let item4 = Item(name: "Shampoo", purchased: false, category: .beauty)
        items.append(item1)
        items.append(item2)
        items.append(item3)
        items.append(item4)
    }

    func add(item: Item) {
        items.append(item)
    }

    func clear() {
        items = []
    }
}

public struct ItemListOverlayView: View { // backgroundDarkOverlay

    @EnvironmentObject private var viewModel: ListViewModel
    @Environment(\.colorScheme) private var colorScheme

    @State private var textInput: String = ""
    @State private var isFirstResponder: Bool = false

    public var body: some View {
        Color.clear
            .overlay(alignment: .bottom) {
                VStack(spacing: 0) {
                    content
                        .background(colorScheme == .dark ? Color.backgroundDarkOverlay : Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 0))
                }
            }
    }

    private var content: some View {
        GeometryReader { geometry in
            VStack {
                Text("MiniList")
                    .font(.system(size: 20, weight: .medium))

                /*if viewModel.count > 0 {
                    List(self.viewModel.items) { item in
                        ItemListView(category: item.category, text: item.name)
                            .listRowSeparator(.hidden)
                            .listRowBackground(colorScheme == .dark ? Color.backgroundDarkOverlay : Color.white)
                    }
                    .scrollIndicators(ScrollIndicatorVisibility.visible)
                    /*.background(.pink)
                    .scrollContentBackground(.hidden)*/
                    .listStyle(.plain)
                    .listSectionSeparator(.hidden)
                    .animation(.spring(.bouncy, blendDuration: 0.9), value: self.viewModel.count > 0)
                    .padding(.bottom, UIScreen.main.bounds.height * 0.35)
                } else {
                    // empty state
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.size.width - 15, height: 500)
                        .foregroundColor(Color.cyan)
                }*/

                /*FirstResponderTextField(text: $textInput, placeholder: "Carrot Cake", isFirstResponder: isFirstResponder)
                    .frame(height: 45)
                    .padding()*/
            }
            .frame(width: geometry.size.width)
            //.environmentObject(viewModel)
        }
    }
}

//#Preview {
//   // ItemListOverlayView(geoProxy: .frame(Geom))
//}

struct FirstResponderTextField: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String
    var isFirstResponder: Bool = false

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.text = text
        textField.delegate = context.coordinator
        textField.borderStyle = .none
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        if isFirstResponder && !uiView.isFirstResponder {
            uiView.becomeFirstResponder()
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }
    }
}
