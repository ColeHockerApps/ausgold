// AppTheme.swift
import SwiftUI
import Combine

struct AppTheme {
    struct Fonts {
        static let title = Font.system(size: 28, weight: .bold, design: .rounded)
        static let button = Font.system(size: 18, weight: .semibold, design: .rounded)
        static let body = Font.system(size: 16, weight: .regular, design: .rounded)
        static let small = Font.system(size: 13, weight: .medium, design: .rounded)
    }

    struct Radii {
        static let small: CGFloat = 8
        static let medium: CGFloat = 14
        static let large: CGFloat = 22
        static let full: CGFloat = 999
    }

    struct Shadows {
        static let light = Shadow(color: .black.opacity(0.15), radius: 6, y: 3)
        static let strong = Shadow(color: .black.opacity(0.25), radius: 10, y: 5)
    }

    struct Padding {
        static let screen: CGFloat = 24
        static let element: CGFloat = 12
        static let section: CGFloat = 20
    }
}

struct Shadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat = 0
    let y: CGFloat
}
