import SwiftUI

/// Application settings, unit preferences, steel density, reference standards, and legal disclaimer.
public struct SettingsView: View {
    @EnvironmentObject private var environment: AppEnvironment

    public init() {}

    public var body: some View {
        NavigationStack {
            Form {
                Section("Engineering Units & Precision") {
                    Picker("Unit System", selection: $environment.unitSystem) {
                        ForEach(EngineeringUnitSystem.allCases, id: \.rawValue) { sys in
                            Text(sys.rawValue).tag(sys.rawValue)
                        }
                    }

                    Stepper("Decimal Precision: \(environment.decimalPrecision)", value: $environment.decimalPrecision, in: 1...4)

                    HStack {
                        Text("Steel Density")
                        Spacer()
                        Text("\(Int(environment.steelDensity)) kg/m³")
                            .foregroundColor(.secondary)
                    }
                }

                Section("Application Preferences") {
                    Toggle("Haptic Feedback", isOn: $environment.hapticsEnabled)
                }

                Section("Reference Standards & Sources") {
                    NavigationLink(destination: StandardInfoView()) {
                        HStack {
                            Image(systemName: "book.closed.fill")
                                .foregroundColor(ColorTokens.blueprintBlue)
                            Text("Bureau of Indian Standards (BIS)")
                        }
                    }

                    NavigationLink(destination: DisclaimerView()) {
                        HStack {
                            Image(systemName: "exclamationmark.shield.fill")
                                .foregroundColor(ColorTokens.engineeringOrange)
                            Text("Engineering Disclaimer")
                        }
                    }
                }

                Section("About IS Steel Tables Pro") {
                    HStack {
                        Text("App Version")
                        Spacer()
                        Text("1.0.0 (Build 2026.1)")
                            .foregroundColor(.secondary)
                    }

                    HStack {
                        Text("Dataset Status")
                        Spacer()
                        HStack(spacing: 4) {
                            Circle().fill(Color.green).frame(width: 8, height: 8)
                            Text("VERIFIED OFFLINE")
                                .font(.caption.bold().monospaced())
                                .foregroundColor(.green)
                        }
                    }

                    HStack {
                        Text("Verified Sections")
                        Spacer()
                        Text("\(environment.allSections.count)")
                            .font(.caption.monospaced().bold())
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings & Info")
        }
    }
}

/// BIS Standards references and codes documentation.
public struct StandardInfoView: View {
    public init() {}

    public var body: some View {
        List {
            Section("Indian Standards (BIS) Referenced") {
                StandardRow(
                    code: "IS 808:1989",
                    title: "Dimensions for Hot Rolled Steel Beam, Column, Channel and Angle Sections",
                    coverage: "ISMB, ISJB, ISLB, ISWB, ISHB, ISMC, ISJC, ISLC, ISA Equal & Unequal Angles, Tee Bars"
                )

                StandardRow(
                    code: "IS 1161:2014 / IS 1239",
                    title: "Steel Tubes for Structural Purposes",
                    coverage: "Circular structural steel pipes (Light, Medium, Heavy classes, 15 NB to 350 NB)"
                )

                StandardRow(
                    code: "IS 4923:1997",
                    title: "Hollow Steel Sections for Structural Use",
                    coverage: "Square Hollow Sections (SHS) and Rectangular Hollow Sections (RHS)"
                )

                StandardRow(
                    code: "IS 1732:1989",
                    title: "Dimensions for Round and Square Steel Bars for Structural and Engineering Purposes",
                    coverage: "Round bars (5mm - 100mm), Square bars (5mm - 100mm)"
                )

                StandardRow(
                    code: "IS 1731:1971",
                    title: "Dimensions for Steel Flats for Structural and General Engineering Purposes",
                    coverage: "Hot rolled structural flats (12mm - 400mm width)"
                )

                StandardRow(
                    code: "IS 2062:2011",
                    title: "Hot Rolled Medium and High Tensile Structural Steel",
                    coverage: "Structural steel plates, mechanical and grade properties"
                )

                StandardRow(
                    code: "SP 6(1):1964",
                    title: "Handbook for Structural Engineers - Part 1: Structural Steel Sections",
                    coverage: "Comprehensive sectional properties, geometric moduli, and second moments"
                )
            }

            Section("Official Sources") {
                Link("BIS Standards Portal (standards.bis.gov.in)", destination: URL(string: "https://standards.bis.gov.in/website")!)
                Link("BIS Electronic Standards (standardsbis.bsbedge.com)", destination: URL(string: "https://standardsbis.bsbedge.com")!)
            }
        }
        .navigationTitle("BIS Standards")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct StandardRow: View {
    let code: String
    let title: String
    let coverage: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(code)
                .font(.headline.monospaced().bold())
                .foregroundColor(.accentColor)
            Text(title)
                .font(.subheadline)
                .foregroundColor(.primary)
            Text(coverage)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

/// Engineering Legal Disclaimer View.
public struct DisclaimerView: View {
    public init() {}

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Engineering Reference Disclaimer")
                    .font(.title2.bold())
                    .foregroundColor(.primary)

                Text("This application is intended strictly as a digital reference and calculation aid for structural engineers, civil engineers, fabricators, and estimation professionals. It does not replace applicable Indian Standards (BIS), project specifications, structural design calculations, or verification by a qualified registered structural engineer.")
                    .font(.body)
                    .foregroundColor(.primary)

                Text("Users are responsible for verifying all values against the authoritative current published standard and project tender specifications prior to design approval, fabrication, material procurement, or construction.")
                    .font(.body)
                    .foregroundColor(.secondary)

                Text("Calculations for mass, weight, and volume assume standard carbon steel density (7850 kg/m³) according to IS 2062. For specialty alloy steels, stainless steel, or non-standard profiles, density variations must be accounted for.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(20)
        }
        .navigationTitle("Disclaimer")
        .navigationBarTitleDisplayMode(.inline)
        .background(ColorTokens.viewBackground)
    }
}
