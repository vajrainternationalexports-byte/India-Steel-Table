import SwiftUI

/// Project Take-off / Bill of Materials (BOM) Estimator for structural steel quantities, total mass (tonnes), and estimated cost.
public struct ProjectBOMEstimatorView: View {
    @EnvironmentObject private var environment: AppEnvironment

    @State private var currentProject: SteelProject = SteelProject()
    @State private var isAddItemSheetPresented: Bool = false
    @State private var isExportSheetPresented: Bool = false
    @State private var csvExportText: String = ""

    public init() {}

    public var body: some View {
        Form {
            Section("Project Details") {
                TextField("Project Name", text: $currentProject.projectName)
                TextField("Client / Location", text: $currentProject.clientOrLocation)
            }

            Section("BOM Line Items (\(currentProject.items.count))") {
                if currentProject.items.isEmpty {
                    VStack(spacing: 8) {
                        Text("No steel sections added to project.")
                            .foregroundColor(.secondary)
                        Button("Add First Item") {
                            isAddItemSheetPresented = true
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(8)
                } else {
                    ForEach(currentProject.items) { item in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(item.designation)
                                    .font(.headline.monospaced())
                                Spacer()
                                Text(String(format: "%.2f kg", item.totalMassKg))
                                    .font(.subheadline.monospaced().bold())
                            }

                            HStack {
                                Text("\(item.quantity) pcs × \(String(format: "%.1f", item.lengthMeters))m = \(String(format: "%.1f", item.totalLengthMeters))m")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text("@ \(String(format: "%.1f", item.massPerMetre)) kg/m")
                                    .font(.caption.monospaced())
                                    .foregroundColor(.secondary)
                            }

                            if let cost = item.estimatedCost {
                                HStack {
                                    Text("Estimated Rate: ₹\(String(format: "%.1f", item.unitRatePerKg ?? 0))/kg")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Text("₹\(String(format: "%.2f", cost))")
                                        .font(.caption.bold())
                                        .foregroundColor(.green)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .onDelete { indices in
                        currentProject.items.remove(atOffsets: indices)
                    }
                }

                Button {
                    isAddItemSheetPresented = true
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Steel Line Item")
                    }
                }
            }

            Section("Project Summary Totals") {
                HStack {
                    Text("Total Steel Pieces")
                    Spacer()
                    Text("\(currentProject.totalItemsCount)")
                        .font(.body.monospaced().bold())
                }

                HStack {
                    Text("Total Cut Length")
                    Spacer()
                    Text(String(format: "%.2f m", currentProject.totalLengthMeters))
                        .font(.body.monospaced().bold())
                }

                HStack {
                    Text("Total Mass (Kilograms)")
                    Spacer()
                    Text(String(format: "%.2f kg", currentProject.totalMassKg))
                        .font(.body.monospaced().bold())
                }

                HStack {
                    Text("Total Mass (Metric Tonnes)")
                    Spacer()
                    Text(String(format: "%.3f t", currentProject.totalMassTonnes))
                        .font(.headline.monospaced().bold())
                        .foregroundColor(ColorTokens.blueprintBlue)
                }

                if currentProject.totalEstimatedCost > 0 {
                    HStack {
                        Text("Total Estimated Cost")
                        Spacer()
                        Text("₹\(String(format: "%.2f", currentProject.totalEstimatedCost))")
                            .font(.headline.monospaced().bold())
                            .foregroundColor(.green)
                    }
                }
            }

            Section {
                Button {
                    generateCSV()
                    isExportSheetPresented = true
                } label: {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                        Text("Export BOM to CSV")
                    }
                }
                .disabled(currentProject.items.isEmpty)
            }
        }
        .navigationTitle("Steel BOM Estimator")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isAddItemSheetPresented) {
            AddBOMItemSheet { newItem in
                currentProject.items.append(newItem)
            }
        }
        .sheet(isPresented: $isExportSheetPresented) {
            ShareSheet(activityItems: [csvExportText])
        }
    }

    private func generateCSV() {
        var csv = "Designation,Family,Quantity,Length (m),Total Length (m),Unit Mass (kg/m),Total Mass (kg),Rate (INR/kg),Total Cost (INR)\n"
        for item in currentProject.items {
            let escapedDesig = CSVExporter.sanitizeCSVField(item.designation)
            let row = "\(escapedDesig),\(item.family.rawValue),\(item.quantity),\(item.lengthMeters),\(item.totalLengthMeters),\(item.massPerMetre),\(item.totalMassKg),\(item.unitRatePerKg ?? 0),\(item.estimatedCost ?? 0)\n"
            csv += row
        }
        csv += "TOTAL,,,\(currentProject.totalItemsCount),\(currentProject.totalLengthMeters),,\(currentProject.totalMassKg),,\(currentProject.totalEstimatedCost)\n"
        self.csvExportText = csv
    }
}

/// Sheet for configuring a new BOM line item.
struct AddBOMItemSheet: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var environment: AppEnvironment

    @State private var selectedSection: SteelSection? = nil
    @State private var quantityText: String = "1"
    @State private var lengthText: String = "6.0"
    @State private var rateText: String = "75.0"
    @State private var isPickerPresented: Bool = false

    let onAdd: (ProjectBOMItem) -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("Select Section") {
                    if let sec = selectedSection {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(sec.designation)
                                    .font(.headline.monospaced())
                                Text("\(sec.family.shortTitle) • \(sec.massPerMetre) kg/m")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Button("Change") { isPickerPresented = true }
                        }
                    } else {
                        Button("Select Section...") {
                            isPickerPresented = true
                        }
                    }
                }

                Section("Dimensions & Rate") {
                    HStack {
                        Text("Quantity")
                        Spacer()
                        TextField("Qty", text: $quantityText)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                    }

                    HStack {
                        Text("Cut Length (m)")
                        Spacer()
                        TextField("Length", text: $lengthText)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }

                    HStack {
                        Text("Estimated Rate (₹/kg)")
                        Spacer()
                        TextField("Rate", text: $rateText)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                }
            }
            .navigationTitle("Add Steel Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") {
                        if let sec = selectedSection {
                            let item = ProjectBOMItem(
                                sectionId: sec.id,
                                designation: sec.designation,
                                family: sec.family,
                                massPerMetre: sec.massPerMetre,
                                quantity: Int(quantityText) ?? 1,
                                lengthMeters: Double(lengthText) ?? 6.0,
                                unitRatePerKg: Double(rateText)
                            )
                            onAdd(item)
                            dismiss()
                        }
                    }
                    .disabled(selectedSection == nil)
                    .bold()
                }
            }
            .sheet(isPresented: $isPickerPresented) {
                SectionPickerSheet { sec in
                    self.selectedSection = sec
                }
            }
        }
    }
}
