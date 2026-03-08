import SwiftUI
import AppKit

// MARK: - Color Extensions
extension Color {
    static var launchpadBorder: Color {
        Color(.systemBlue)
    }
}

// MARK: - Font Extensions
extension Font {
    static var `default`: Font {
        .system(size: 11, weight: .medium)
    }
}

// MARK: - Glass Effect Style

enum LiquidGlassStyle {
    case regular
    case clear

    var fallbackMaterial: Material {
        switch self {
        case .regular: .regularMaterial
        case .clear: .ultraThinMaterial
        }
    }
}

// MARK: - View Extensions for Glass Effect
extension View {
    @ViewBuilder
    func liquidGlass<S: Shape>(_ style: LiquidGlassStyle = .regular, in shape: S, isEnabled: Bool = true) -> some View {
        if #available(macOS 26.0, iOS 26.0, *) {
            switch style {
            case .regular:
                self.glassEffect(.regular, in: shape)
            case .clear:
                self.glassEffect(.clear, in: shape)
            }
        } else {
            self.background(style.fallbackMaterial, in: shape)
        }
    }

    @ViewBuilder
    func liquidGlass(_ style: LiquidGlassStyle = .regular, isEnabled: Bool = true) -> some View {
        if #available(macOS 26.0, iOS 26.0, *) {
            switch style {
            case .regular:
                self.glassEffect(.regular)
            case .clear:
                self.glassEffect(.clear)
            }
        } else {
            self.background(style.fallbackMaterial)
        }
    }
}
 
