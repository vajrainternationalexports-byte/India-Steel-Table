import SwiftUI

/// Side-by-side comparison screen for 2 to 5 steel sections with property differences and min/max highlights.
public struct CompareView: View {
    @EnvironmentObject private var environment: AppEnvironment
    @State private var isAddSectionSheetPresented: Bool = false

    public init() {}

    public var body: some View {
        NavigationStack {
            VStack {
                if environment.comparisonSections.isEmpty {
                    emptyComparisonState
                } else {
                    comparisonTableContent
                }
            }
            .navigationTitle("Section Comparison")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 8) {
                        if !environment.comparisonSections.isEmpty {
                            Button("Clear") {
                                environment.clearComparison()
                            }
                            .foregroundColor(.red)
                        }

                        Button {
                            isAddSectionSheetPresented = true
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.title3)
                        }
                    }
                }
            }
            .sheet(isPresented: $isAddSectionSheetPresented) {
                SectionPickerSheet { selected in
                    environment.addToComparison(selected)
                }
            }
            .background(ColorTokens.viewBackground)
        }
    }

    // MARK: - Empty State
    private var emptyComparisonState: some View {
        VStack(spacing: 16) {
            Image(systemName: "arrow.left.and.right.square")
                .font(.system(size: 56))
                .foregroundColor(.secondary.opacity(0.5))

            Text("No Sections in Comparison")
                .font(.headline)
                .foregroundColor(.primary)

            Text("Select 2 to 5 steel sections to compare dimensions, sectional areas, moments of inertia, and moduli side-by-side.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Button {
                isAddSectionSheetPresented = true
            } label: {
                HStack {
                    Image(systemName: "plus")
                    Text("Add Section to Compare")
                }
                .font(.subheadline.bold())
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }

    // MARK: - Comparison Matrix Table
    private var comparisonTableContent: some View {
        let matrix = SectionComparisonMatrix(sections: environment.comparisonSections)
        let rows = matrix.generateComparisonRows(precision: environment.decimalPrecision)

        return ScrollView([.horizontal, .vertical]) {
            VStack(alignment: .leading, spacing: 0) {
                // Section Headers
                HStack(spacing: 0) {
                    Text("Property")
                        .font(.caption.bold().monospaced())
                        .frame(width: 150, alignment: .leading)
                        .padding(10)
                        .background(ColorTokens.badgeBackground)

                    ForEach(environment.comparisonSections) { sec in
                        VStack(alignment: .center, spacing: 4) {
                            HStack {
                                Text(sec.designation)
                                    .font(.caption.bold().monospaced())
                                    .lineLimit(1)

                                Button {
                                    environment.removeFromComparison(sec)
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                            }

                            Text(sec.family.shortTitle)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        .frame(width: 120)
                        .padding(8)
                        .background(ColorTokens.badgeBackground)
                    }
                }

                Divider()

                // Property Rows
                ForEach(rows) { row in
                    HStack(spacing: 0) {
                        VStack(alignment: .leading, spacing: 1) {
                            Text(row.propertyName)
                                .font(.caption.bold())
                                .foregroundColor(.primary)
                            Text("\(row.symbol) (\(row.unit))")
                                .font(.caption2.monospaced())
                                .foregroundColor(.secondary)
                        }
                        .frame(width: 150, alignment: .leading)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)

                        ForEach(Array(row.displayValues.enumerated()), id: \.offset) { (idx, val) in
                            let isMax = row.maxIndex == idx
                            let isMin = row.minIndex == idx

                            Text(val)
                                .font(.caption.monospaced().bold())
                                .foregroundColor(isMax ? .green : (isMin ? .orange : .primary))
                                .frame(width: 120, alignment: .center)
                                .padding(.vertical, 8)
                                .background(
                                    isMax ? Color.green.opacity(0.12) :
                                    (isMin ? Color.orange.opacity(0.12) : Color.clear)
                                )
                        }
                    }
                    .background(ColorTokens.cardBackground)

                    Divider()
                }
            }
            .padding(16)
        }
    }
}

/// Sheet for selecting a steel section to add to the comparison matrix.
public struct SectionPickerSheet: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var environment: AppEnvironment
    @State private var searchText: String = ""
    @State private var selectedFamily: SectionFamily? = nil

    public let onSelect: (SteelSection) -> Void

    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Family Filter Bar
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        Button {
                            selectedFamily = nil
                        } label: {
                            Text("All")
                                .font(.caption.bold().monospaced())
                                .foregroundColor(selectedFamily == nil ? .white : .primary)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(selectedFamily == nil ? Color.accentColor : ColorTokens.badgeBackground)
                                .cornerRadius(8)
                        }

                        ForEach(SectionFamily.allCases) { family in
                            Button {
                                selectedFamily = family
                            } label: {
                                Text(family.shortTitle)
                                    .font(.caption.bold().monospaced())
                                    .foregroundColor(selectedFamily == family ? .white : .primary)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(selectedFamily == family ? Color.accentColor : ColorTokens.badgeBackground)
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                }

                let filtered = SectionSearchIndexer(sections: environment.allSections)
                    .search(query: searchText, family: selectedFamily)

                List(filtered) { sec in
                    Button {
                        onSelect(sec)
                        dismiss()
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(sec.designation)
                                    .font(.headline.monospaced())
                                    .foregroundColor(.primary)
                                Text("\(sec.family.shortTitle) • \(sec.standard)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }

                            Spacer()

                            VStack(alignment: .trailing, spacing: 2) {
                                Text("\(String(format: "%.1f", sec.massPerMetre)) kg/m")
                                    .font(.caption.monospaced().bold())
                                    .foregroundColor(.primary)
                                Text("\(String(format: "%.1f", sec.area)) cm²")
                                    .font(.caption2.monospaced())
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Select Section to Compare")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "Search sections...")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}
