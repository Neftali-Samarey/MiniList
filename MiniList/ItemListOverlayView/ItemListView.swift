//
//  ItemListView.swift
//  MiniList
//
//  Created by Neftali Samarey on 8/20/24.
//

import SwiftUI

public struct ItemListView: View {

    let text: String

    public var body: some View {
        Rectangle()
            .overlay {
                VStack {
                    HStack {
                        Text(text)
                            .font(.system(size: 18))
                            .foregroundStyle(Color.black)
                        Spacer()
                        // lottie view checkmark
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 10)
            }
            .foregroundStyle(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .frame(height: 70, alignment: .center)
            .shadow(color: Color.gray.opacity(0.5) ,radius: 1.8)
    }
}

#Preview {
    ItemListView(text: "Item title")
}
