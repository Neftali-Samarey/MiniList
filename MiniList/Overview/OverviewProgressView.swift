//
//  OverviewProgressView.swift
//  MiniList
//
//  Created by Neftali Samarey on 8/20/24.
//

import SwiftUI

public struct OverviewProgressView: View {
    public var body: some View {
        Rectangle()
            .overlay {
                Text("Content")
            }
            .foregroundStyle(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .frame(height: 85, alignment: .center)
            .border(Color.gray.opacity(0.5), width: 1.0)
    }
}

#Preview {
    OverviewProgressView()
}
