import SwiftUI

/// Engineering Calculators Hub providing access to all structural steel estimation and conversion tools.
public struct CalculatorsHubView: View {
    public init() {}

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Calculator Cards
                    NavigationLink(destination: SectionWeightCalculatorView()) {
                        CalculatorMenuCard(
                            title: "Standard Section Weight",
                            subtitle: "Quantity × Length × Tabulated Mass (kg/m)",
                            icon: "scalemass.fill",
                            color: ColorTokens.blueprintBlue,
                            formula: "Total Mass = N × L × W (kg/m)"
                        )
                    }
                    .buttonStyle(.plain)

                    NavigationLink(destination: PlateWeightCalculatorView()) {
                        CalculatorMenuCard(
                            title: "Steel Plate Weight",
                            subtitle: "Length (m) × Width (m) × Thickness (mm)",
                            icon: "square.stack.3d.up.fill",
                            color: ColorTokens.engineeringOrange,
                            formula: "Mass = L × W × t × 7.85 kg/(m²·mm)"
                        )
                    }
                    .buttonStyle(.plain)

                    NavigationLink(destination: BarWeightCalculatorView()) {
                        CalculatorMenuCard(
                            title: "Round & Square Bar Weight",
                            subtitle: "Diameter / Side with D²/162 site rule",
                            icon: "circle.fill",
                            color: .purple,
                            formula: "W (kg/m) = D² / 162 (IS 1732 standard)"
                        )
                    }
                    .buttonStyle(.plain)

                    NavigationLink(destination: PipeWeightCalculatorView()) {
                        CalculatorMenuCard(
                            title: "Pipe & Hollow Tube Weight",
                            subtitle: "Outer Diameter, Wall Thickness & Capacity",
                            icon: "circle.circle",
                            color: ColorTokens.steelCyan,
                            formula: "Mass = π × (OD - t) × t × 0.00785"
                        )
                    }
                    .buttonStyle(.plain)

                    NavigationLink(destination: UnitConverterView()) {
                        CalculatorMenuCard(
                            title: "Structural Unit Converter",
                            subtitle: "Length, Mass, Force, Area, Inertia & Modulus",
                            icon: "arrow.left.arrow.right",
                            color: .green,
                            formula: "mm ↔ cm ↔ m • kg ↔ tonne ↔ kN • cm⁴ ↔ mm⁴"
                        )
                    }
                    .buttonStyle(.plain)

                    NavigationLink(destination: ProjectBOMEstimatorView()) {
                        CalculatorMenuCard(
                            title: "Project Take-off & BOM",
                            subtitle: "Multi-item steel bill of quantities & cost",
                            icon: "list.clipboard.fill",
                            color: .indigo,
                            formula: "Aggregate Mass (t) + Total Cost (₹)"
                        )
                    }
                    .buttonStyle(.plain)
                }
                .padding(16)
            }
            .navigationTitle("Engineering Calculators")
            .background(ColorTokens.viewBackground)
        }
    }
}

/// Menu card for a specific calculator.
struct CalculatorMenuCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let formula: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                    .frame(width: 44, height: 44)
                    .background(color.opacity(0.12))
                    .cornerRadius(10)

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption.bold())
                    .foregroundColor(.secondary.opacity(0.6))
            }

            Text(formula)
                .font(.caption2.monospaced())
                .foregroundColor(color)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(color.opacity(0.08))
                .cornerRadius(6)
        }
        .padding(16)
        .background(ColorTokens.cardBackground)
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.primary.opacity(0.06), lineWidth: 1)
        )
    }
}
