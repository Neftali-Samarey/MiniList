//
//  ItemListView.swift
//  MiniList
//
//  Created by Neftali Samarey on 8/20/24.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {

    var animationName: String
    var loopMode: LottieLoopMode = .loop
    var contentMode: UIView.ContentMode = .scaleAspectFit

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)

        let animationView = LottieAnimationView(name: animationName)
        animationView.loopMode = loopMode
        animationView.contentMode = contentMode
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.configuration = LottieConfiguration(renderingEngine: .mainThread)

        view.addSubview(animationView)

        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])

        animationView.play()

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // No update code needed for static Lottie animations
    }
}

public struct ItemListView: View {

    @Environment(\.colorScheme) private var colorScheme
    @State private var isSelected: Bool = false

    private let category: ItemCategory
    private let text: String

    public init(category: ItemCategory, text: String) {
        self.category = category
        self.text = text
    }

    public var body: some View {
        Rectangle()
            .overlay {
                VStack {
                    HStack(spacing: 8) {
                        iconImageView

                        Text(text)
                            .font(.custom("Merriweather-Regular", size: 16))
                            .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
                        Spacer()
                        // lottie view checkmark
                        Button {
                            self.isSelected.toggle()
                        } label: {
                            Circle()
                                .stroke(Color.gray.opacity(0.7), lineWidth: 1)
                                .frame(width: 26, height: 26)
                                .overlay {
                                    if isSelected {
                                        Image(systemName: "checkmark")
                                            .frame(width: 26, height: 26)
                                            .foregroundColor(Color.backgroundDark)
                                    }
                                }
                        }

                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 10)
            }
            .foregroundStyle(colorScheme == .dark ? Color.backgroundDarkOverlay : Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .frame(height: 70, alignment: .center)
            .shadow(color: colorScheme == .dark ? Color.backgroundDarkAlt.opacity(1) : Color.gray.opacity(0.5) ,radius: 1.8)
    }

    private var iconImageView: some View {
        Image(category.iconStringValue)
            .frame(width: 40, height: 40)
    }
}

#Preview {
    ItemListView(category: .none, text: "Item title")
}
