import SwiftUI

/// Compact metric pill displaying symbol, number, and unit tag.
public struct MetricPill: View {
    public let symbol: String
    public let value: String
    public let unit: String

    public init(symbol: String, value: String, unit: String) {
        self.symbol = symbol
        self.value = value
        self.unit = unit
    }

    public var body: some View {
        HStack(spacing: 4) {
            if !symbol.isEmpty {
                Text(symbol)
                    .font(.caption2.bold())
                    .foregroundColor(.secondary)
            }
            Text(value)
                .font(.subheadline.monospaced().weight(.semibold))
                .foregroundColor(.primary)
            Text(unit)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(ColorTokens.badgeBackground)
        .cornerRadius(6)
    }
}

/// Standardized card for displaying a steel section in list views.
public struct SectionRowCard: View {
    public let section: SteelSection
    public var isFavorite: Bool = false
    public var onToggleFavorite: (() -> Void)? = nil

    public init(section: SteelSection, isFavorite: Bool = false, onToggleFavorite: (() -> Void)? = nil) {
        self.section = section
        self.isFavorite = isFavorite
        self.onToggleFavorite = onToggleFavorite
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(section.designation)
                        .font(.headline.monospaced().bold())
                        .foregroundColor(.primary)

                    Text("\(section.family.shortTitle) • \(section.standard)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                if let onToggle = onToggleFavorite {
                    Button(action: onToggle) {
                        Image(systemName: isFavorite ? "star.fill" : "star")
                            .foregroundColor(isFavorite ? .yellow : .secondary.opacity(0.6))
                            .font(.subheadline)
                    }
                    .buttonStyle(.borderless)
                }
            }

            // Quick metrics grid
            HStack(spacing: 8) {
                let isPlate = section.family == .hrPlates
                MetricPill(
                    symbol: "W",
                    value: String(format: "%.1f", section.massPerMetre),
                    unit: isPlate ? "kg/m²" : "kg/m"
                )

                MetricPill(
                    symbol: "A",
                    value: String(format: "%.1f", section.area),
                    unit: "cm²"
                )

                if let depth = section.dimensions.primaryDepth {
                    MetricPill(
                        symbol: "h",
                        value: "\(Int(depth))",
                        unit: "mm"
                    )
                }

                Spacer()
            }
        }
        .padding(.vertical, 4)
    }
}
