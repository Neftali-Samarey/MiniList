//
//  ProgressView.swift
//  MiniList
//
//  Created by Neftali Samarey on 8/29/24.
//

import SwiftUI

public struct ProgressView: View {

    let itemCount: Int // redundant
    let items: [Item]

    public init(itemCount: Int, items: [Item]) {
        self.itemCount = itemCount
        self.items = items
    }

    private var columns: [GridItem] = [
        GridItem(.fixed(40), spacing: 5, alignment: .leading)
    ]

    public var body: some View {
        VStack {
            Spacer()
            HStack {
                Rectangle()
                    .frame(width: UIScreen.main.bounds.size.width * dynamicProgressValue(itemCount: self.itemCount), height: 6)
                    .foregroundColor(Color.gray.opacity(0.4))
                    .clipShape(Capsule()) // Make the rectangle have rounded corners like a pill shape
                    .overlay {
                        HStack(spacing: 25) {
                            ForEach(items) { item in
                                stepView
                            }
                        }
                        /*ScrollView(.horizontal, showsIndicators: false) {
                            LazyHGrid(rows: columns, spacing: 25) {

                            }
                        }*/
                    }
            }
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.size.width, height: 200)
    }

    private var stepView: some View {
        Circle()
            .frame(width: 30, height: 30)
            .foregroundColor(Color.primaryCream)  // Set the circle's fill color (optional)
            .overlay(
                Circle()
                    .stroke(Color.gray.opacity(0.7), lineWidth: 1) // Add a thin gray border
                    .overlay {
                        /*LottieView(animationName: "EmeraldColorCheckmark", loopMode: .playOnce, contentMode: .scaleAspectFill)
                            .frame(width: 80, height: 80)*/
                    }
            )
            //.shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 2) // Add a shadow
    }

    // MARK: - Sizing configurations for progress view
    private func dynamicProgressValue(itemCount: Int) -> CGFloat {
        switch itemCount {
        case 1: return 0.0
        case 2: return 0.15
        case 3: return 0.35
        case 4: return 0.45
        case 5: return 0.55
        case 6: return 0.65
        case 7: return 0.80
        case 8: return 0.90
        default:
            return 0.95
        }
    }
}

#Preview {
    ProgressView(itemCount: 0, items: [])
}
