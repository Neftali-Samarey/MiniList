//
//  LottieManager.swift
//  MiniList
//
//  Created by Neftali Samarey on 3/16/25.
//

import Foundation

public enum LottieFileManager: String, CaseIterable {
    case empty

    public static func animation(with animation: LottieFileManager) -> String {
        switch animation {
        case .empty: return "EmptyRelaxBlue"
        }
    }
}
