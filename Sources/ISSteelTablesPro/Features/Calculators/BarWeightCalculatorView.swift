import SwiftUI

/// Round and Square Bar Weight Calculator with D²/162 site rule comparison.
public struct BarWeightCalculatorView: View {
    @State private var barType: BarType = .round
    @State private var dimensionText: String = "16.0"
    @State private var lengthText: String = "12.0"
    @State private var quantityText: String = "10"

    public enum BarType: String, CaseIterable, Identifiable {
        case round = "Round Bar (Ø)"
        case square = "Square Bar (□)"

        public var id: String { rawValue }
    }

    public init() {}

    public var body: some View {
        Form {
            Section("Bar Type & Cross-Section") {
                Picker("Bar Type", selection: $barType) {
                    ForEach(BarType.allCases) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(.segmented)

                HStack {
                    Text(barType == .round ? "Diameter Ø (mm)" : "Side S (mm)")
                    Spacer()
                    TextField("Dimension in mm", text: $dimensionText)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                }

                HStack {
                    Text("Length per piece (m)")
                    Spacer()
                    TextField("12.0", text: $lengthText)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                }

                HStack {
                    Text("Quantity (pcs)")
                    Spacer()
                    TextField("10", text: $quantityText)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                }
            }

            Section("Calculation Results") {
                let (massPerM, totalMass, areaCm2, rule162) = calculate()

                HStack {
                    Text("Unit Mass per Metre")
                    Spacer()
                    Text(String(format: "%.3f kg/m", massPerM))
                        .font(.body.monospaced().bold())
                }

                if barType == .round {
                    HStack {
                        Text("Site Rule (D²/162)")
                        Spacer()
                        Text(String(format: "%.3f kg/m", rule162))
                            .font(.body.monospaced())
                            .foregroundColor(.secondary)
                    }
                }

                HStack {
                    Text("Total Mass")
                    Spacer()
                    Text(String(format: "%.2f kg (%.3f t)", totalMass, totalMass / 1000.0))
                        .font(.body.monospaced().bold())
                        .foregroundColor(ColorTokens.blueprintBlue)
                }

                HStack {
                    Text("Cross-Sectional Area")
                    Spacer()
                    Text(String(format: "%.2f cm²", areaCm2))
                        .font(.body.monospaced())
                        .foregroundColor(.secondary)
                }
            }

            Section("Standard Formulas (IS 1732)") {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Exact: W = Area (m²) × 7850 kg/m³")
                        .font(.caption.monospaced())
                    Text("Round Bar Rule: W ≈ D² / 162.2 kg/m")
                        .font(.caption.monospaced())
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("Bar Weight Calculator")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func calculate() -> (Double, Double, Double, Double) {
        let dim = Double(dimensionText) ?? 0
        let len = Double(lengthText) ?? 0
        let qty = Int(quantityText) ?? 1

        if barType == .round {
            return EngineeringCalculations.calculateRoundBarMass(
                diameterMm: dim,
                lengthMeters: len,
                quantity: qty
            )
        } else {
            let (m, tot, a) = EngineeringCalculations.calculateSquareBarMass(
                sideMm: dim,
                lengthMeters: len,
                quantity: qty
            )
            return (m, tot, a, 0)
        }
    }
}

/// Circular Pipe & Hollow Structural Tube Weight & Capacity Calculator.
public struct PipeWeightCalculatorView: View {
    @State private var outerDiaText: String = "60.3"
    @State private var wallThicknessText: String = "3.6"
    @State private var lengthText: String = "6.0"
    @State private var quantityText: String = "1"

    public init() {}

    public var body: some View {
        Form {
            Section("Tube Dimensions (mm)") {
                HStack {
                    Text("Outer Diameter (OD)")
                    Spacer()
                    TextField("OD in mm", text: $outerDiaText)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                }

                HStack {
                    Text("Wall Thickness (t)")
                    Spacer()
                    TextField("t in mm", text: $wallThicknessText)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                }

                HStack {
                    Text("Length per piece (m)")
                    Spacer()
                    TextField("Length in meters", text: $lengthText)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                }

                HStack {
                    Text("Quantity (pcs)")
                    Spacer()
                    TextField("Qty", text: $quantityText)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                }
            }

            Section("Calculation Results") {
                let (massPerM, totalMass, areaCm2, intVol) = calculate()

                HStack {
                    Text("Mass per Metre")
                    Spacer()
                    Text(String(format: "%.3f kg/m", massPerM))
                        .font(.body.monospaced().bold())
                }

                HStack {
                    Text("Total Mass")
                    Spacer()
                    Text(String(format: "%.2f kg", totalMass))
                        .font(.body.monospaced().bold())
                        .foregroundColor(ColorTokens.blueprintBlue)
                }

                HStack {
                    Text("Metal Area")
                    Spacer()
                    Text(String(format: "%.2f cm²", areaCm2))
                        .font(.body.monospaced())
                        .foregroundColor(.secondary)
                }

                HStack {
                    Text("Internal Volume")
                    Spacer()
                    Text(String(format: "%.1f cm³/m", intVol))
                        .font(.body.monospaced())
                        .foregroundColor(.secondary)
                }
            }

            Section("Governing Formula (IS 1161)") {
                Text("Mass (kg/m) = π × (OD - t) × t × 0.00785")
                    .font(.caption.monospaced())
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("Pipe Weight Calculator")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func calculate() -> (Double, Double, Double, Double) {
        let od = Double(outerDiaText) ?? 0
        let t = Double(wallThicknessText) ?? 0
        let len = Double(lengthText) ?? 0
        let qty = Int(quantityText) ?? 1

        return EngineeringCalculations.calculateCircularPipeMass(
            outerDiameterMm: od,
            wallThicknessMm: t,
            lengthMeters: len,
            quantity: qty
        )
    }
}

/// Universal Structural Engineering Unit Converter.
public struct UnitConverterView: View {
    @State private var category: ConverterCategory = .length
    @State private var inputValueText: String = "100.0"

    // Length
    @State private var fromLength: LengthUnit = .millimeter
    @State private var toLength: LengthUnit = .meter

    // Mass
    @State private var fromMass: MassUnit = .kilogram
    @State private var toMass: MassUnit = .tonne

    // Force
    @State private var fromForce: ForceUnit = .kilonewton
    @State private var toForce: ForceUnit = .newton

    // Inertia
    @State private var fromInertia: InertiaUnit = .cm4
    @State private var toInertia: InertiaUnit = .mm4

    public enum ConverterCategory: String, CaseIterable, Identifiable {
        case length = "Length"
        case mass = "Mass"
        case force = "Force"
        case inertia = "Moment of Inertia"

        public var id: String { rawValue }
    }

    public init() {}

    public var body: some View {
        Form {
            Section("Conversion Category") {
                Picker("Category", selection: $category) {
                    ForEach(ConverterCategory.allCases) { cat in
                        Text(cat.rawValue).tag(cat)
                    }
                }
            }

            Section("Input Value") {
                TextField("Enter value", text: $inputValueText)
                    .keyboardType(.decimalPad)
                    .font(.title3.monospaced())
            }

            Section("Units") {
                switch category {
                case .length:
                    Picker("From", selection: $fromLength) {
                        ForEach(LengthUnit.allCases) { u in Text(u.rawValue).tag(u) }
                    }
                    Picker("To", selection: $toLength) {
                        ForEach(LengthUnit.allCases) { u in Text(u.rawValue).tag(u) }
                    }

                case .mass:
                    Picker("From", selection: $fromMass) {
                        ForEach(MassUnit.allCases) { u in Text(u.rawValue).tag(u) }
                    }
                    Picker("To", selection: $toMass) {
                        ForEach(MassUnit.allCases) { u in Text(u.rawValue).tag(u) }
                    }

                case .force:
                    Picker("From", selection: $fromForce) {
                        ForEach(ForceUnit.allCases) { u in Text(u.rawValue).tag(u) }
                    }
                    Picker("To", selection: $toForce) {
                        ForEach(ForceUnit.allCases) { u in Text(u.rawValue).tag(u) }
                    }

                case .inertia:
                    Picker("From", selection: $fromInertia) {
                        ForEach(InertiaUnit.allCases) { u in Text(u.rawValue).tag(u) }
                    }
                    Picker("To", selection: $toInertia) {
                        ForEach(InertiaUnit.allCases) { u in Text(u.rawValue).tag(u) }
                    }
                }
            }

            Section("Converted Output") {
                let result = computeConversion()
                HStack {
                    Text("Result")
                        .font(.headline)
                    Spacer()
                    Text(String(format: "%.4f", result))
                        .font(.title3.monospaced().bold())
                        .foregroundColor(ColorTokens.blueprintBlue)
                }
            }
        }
        .navigationTitle("Unit Converter")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func computeConversion() -> Double {
        let val = Double(inputValueText) ?? 0.0
        switch category {
        case .length:
            return UnitConverter.convertLength(value: val, from: fromLength, to: toLength)
        case .mass:
            return UnitConverter.convertMass(value: val, from: fromMass, to: toMass)
        case .force:
            return UnitConverter.convertForce(value: val, from: fromForce, to: toForce)
        case .inertia:
            return UnitConverter.convertInertia(value: val, from: fromInertia, to: toInertia)
        }
    }
}
