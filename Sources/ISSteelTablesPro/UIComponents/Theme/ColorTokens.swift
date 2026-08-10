import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

/// Design system color tokens tailored for professional structural engineering readability in both Dark and Light modes.
public struct ColorTokens {
    public static let primarySteel = Color.accentColor
    public static let blueprintBlue = Color(red: 0.10, green: 0.45, blue: 0.90)
    public static let engineeringOrange = Color(red: 0.95, green: 0.55, blue: 0.15)
    public static let steelCyan = Color(red: 0.15, green: 0.75, blue: 0.85)
    public static let badgeBackground = Color.secondary.opacity(0.12)
    public static let cardBackground = Color(uiColor: .secondarySystemGroupedBackground)
    public static let viewBackground = Color(uiColor: .systemGroupedBackground)
}

public struct TypographyTokens {
    public static let designationTitle = Font.system(.title2, design: .monospaced).weight(.bold)
    public static let propertyLabel = Font.system(.subheadline, design: .default).weight(.medium)
    public static let propertyValue = Font.system(.body, design: .monospaced).weight(.semibold)
    public static let tableCellNumber = Font.system(.callout, design: .monospaced).weight(.medium)
    public static let unitTag = Font.system(.caption2, design: .monospaced).weight(.regular)
    public static let sectionHeader = Font.system(.headline, design: .default).weight(.bold)
}
