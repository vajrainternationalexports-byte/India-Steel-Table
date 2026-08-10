import SwiftUI

/// Section Mass & Length Calculator (Quantity × Length × kg/m).
public struct SectionWeightCalculatorView: View {
    @EnvironmentObject private var environment: AppEnvironment

    @State private var selectedSection: SteelSection? = nil
    @State private var quantityText: String = "1"
    @State private var lengthText: String = "6.0"
    @State private var customMassPerMText: String = ""
    @State private var isPickerPresented: Bool = false

    public init(preselectedSection: SteelSection? = nil) {
        self._selectedSection = State(initialValue: preselectedSection)
    }

    public var body: some View {
        Form {
            Section("Selected Steel Section") {
                if let sec = selectedSection {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(sec.designation)
                                .font(.headline.monospaced())
                            Text("\(sec.family.shortTitle) • \(sec.massPerMetre) kg/m")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Button("Change") {
                            isPickerPresented = true
                        }
                    }
                } else {
                    Button {
                        isPickerPresented = true
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle")
                            Text("Select Section from Table")
                        }
                    }

                    TextField("Or enter custom mass (kg/m)", text: $customMassPerMText)
                        .keyboardType(.decimalPad)
                }
            }

            Section("Quantity & Cut Length") {
                HStack {
                    Text("Quantity (pcs)")
                    Spacer()
                    TextField("Qty", text: $quantityText)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                }

                HStack {
                    Text("Length per piece (m)")
                    Spacer()
                    TextField("Length in meters", text: $lengthText)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                }
            }

            Section("Calculation Results") {
                let (massKg, massTonnes, weightKN) = calculate()

                HStack {
                    Text("Total Mass")
                    Spacer()
                    Text(String(format: "%.2f kg", massKg))
                        .font(.body.monospaced().bold())
                        .foregroundColor(.primary)
                }

                HStack {
                    Text("Total Mass (Tonnes)")
                    Spacer()
                    Text(String(format: "%.3f t", massTonnes))
                        .font(.body.monospaced().bold())
                        .foregroundColor(ColorTokens.blueprintBlue)
                }

                HStack {
                    Text("Total Weight (Force)")
                    Spacer()
                    Text(String(format: "%.3f kN", weightKN))
                        .font(.body.monospaced().bold())
                        .foregroundColor(ColorTokens.engineeringOrange)
                }

                let totalLength = (Double(quantityText) ?? 1) * (Double(lengthText) ?? 0)
                HStack {
                    Text("Total Length")
                    Spacer()
                    Text(String(format: "%.2f m", totalLength))
                        .font(.body.monospaced())
                        .foregroundColor(.secondary)
                }
            }

            Section("Governing Formula") {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Total Mass (kg) = Quantity × Length (m) × W (kg/m)")
                        .font(.caption.monospaced())
                        .foregroundColor(.secondary)
                    Text("Total Weight (kN) = Total Mass (kg) × 9.80665 / 1000")
                        .font(.caption.monospaced())
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("Section Weight")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isPickerPresented) {
            SectionPickerSheet { sec in
                self.selectedSection = sec
            }
        }
        .onAppear {
            if let sec = selectedSection {
                customMassPerMText = "\(sec.massPerMetre)"
            }
        }
    }

    private func calculate() -> (Double, Double, Double) {
        let qty = Int(quantityText) ?? 1
        let length = Double(lengthText) ?? 0.0
        let massPerM = selectedSection?.massPerMetre ?? Double(customMassPerMText) ?? 0.0
        return EngineeringCalculations.calculateSectionTotalMass(
            quantity: qty,
            lengthMeters: length,
            massPerMetreKg: massPerM
        )
    }
}

/// Custom Steel Plate Weight Calculator (IS 2062).
public struct PlateWeightCalculatorView: View {
    @State private var lengthText: String = "2.5"
    @State private var widthText: String = "1.25"
    @State private var thicknessText: String = "12.0"
    @State private var quantityText: String = "1"
    @State private var densityText: String = "7850"

    public init() {}

    public var body: some View {
        Form {
            Section("Plate Dimensions") {
                HStack {
                    Text("Length (m)")
                    Spacer()
                    TextField("Length in meters", text: $lengthText)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                }

                HStack {
                    Text("Width (m)")
                    Spacer()
                    TextField("Width in meters", text: $widthText)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                }

                HStack {
                    Text("Thickness (mm)")
                    Spacer()
                    TextField("Thickness in mm", text: $thicknessText)
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
                let (unitMass, totalMass, massPerSqM, areaM2) = calculate()

                HStack {
                    Text("Unit Plate Mass")
                    Spacer()
                    Text(String(format: "%.2f kg", unitMass))
                        .font(.body.monospaced().bold())
                }

                HStack {
                    Text("Total Mass")
                    Spacer()
                    Text(String(format: "%.2f kg (%.3f t)", totalMass, totalMass / 1000.0))
                        .font(.body.monospaced().bold())
                        .foregroundColor(ColorTokens.blueprintBlue)
                }

                HStack {
                    Text("Mass per Unit Area")
                    Spacer()
                    Text(String(format: "%.2f kg/m²", massPerSqM))
                        .font(.body.monospaced())
                        .foregroundColor(.secondary)
                }

                HStack {
                    Text("Plate Surface Area")
                    Spacer()
                    Text(String(format: "%.2f m²", areaM2))
                        .font(.body.monospaced())
                        .foregroundColor(.secondary)
                }
            }

            Section("Material Density") {
                HStack {
                    Text("Steel Density (kg/m³)")
                    Spacer()
                    TextField("7850", text: $densityText)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                }
            }

            Section("Formula") {
                Text("Mass = Length (m) × Width (m) × Thickness (mm) × 7.85 kg/(m²·mm)")
                    .font(.caption.monospaced())
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("Plate Weight Calculator")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func calculate() -> (Double, Double, Double, Double) {
        let length = Double(lengthText) ?? 0
        let width = Double(widthText) ?? 0
        let thickness = Double(thicknessText) ?? 0
        let qty = Int(quantityText) ?? 1
        let density = Double(densityText) ?? 7850.0

        return EngineeringCalculations.calculatePlateMass(
            lengthMeters: length,
            widthMeters: width,
            thicknessMm: thickness,
            quantity: qty,
            densityKgM3: density
        )
    }
}
