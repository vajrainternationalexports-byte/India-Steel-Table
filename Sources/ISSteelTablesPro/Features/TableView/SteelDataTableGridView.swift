import SwiftUI

/// High-density spreadsheet-style Table View with pinned first column (Designation), multi-column sorting, and 14 family tabs.
public struct SteelDataTableGridView: View {
    @EnvironmentObject private var environment: AppEnvironment

    @State private var selectedFamily: SectionFamily = .regularBeams
    @State private var searchText: String = ""
    @State private var sortedColumn: TableColumn = .designation
    @State private var isAscending: Bool = true

    public enum TableColumn: String, CaseIterable, Identifiable {
        case designation = "Designation"
        case mass = "Mass (kg/m)"
        case area = "Area (cm²)"
        case depth = "Depth (mm)"
        case width = "Width (mm)"
        case ixx = "Ix (cm⁴)"
        case iyy = "Iy (cm⁴)"
        case zxx = "Zx (cm³)"
        case zyy = "Zy (cm³)"

        public var id: String { rawValue }

        public var width: CGFloat {
            switch self {
            case .designation: return 140
            case .mass, .area, .depth, .width: return 85
            case .ixx, .iyy, .zxx, .zyy: return 95
            }
        }
    }

    public init() {}

    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 14 Family Selector Tabs
                familyTabsBar

                // High-Density Data Grid
                tableGridContent
            }
            .navigationTitle("Steel Data Tables")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "Filter table...")
            .background(ColorTokens.viewBackground)
        }
    }

    // MARK: - Family Tabs
    private var familyTabsBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
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
        .background(Color(uiColor: .systemBackground))
        .overlay(
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(Color.primary.opacity(0.08)),
            alignment: .bottom
        )
    }

    // MARK: - Table Grid Content
    private var tableGridContent: some View {
        let sections = sortedAndFilteredSections

        return ScrollView([.horizontal, .vertical]) {
            LazyVStack(alignment: .leading, spacing: 0) {
                // Pinned Header
                HStack(spacing: 0) {
                    ForEach(TableColumn.allCases) { col in
                        Button {
                            if sortedColumn == col {
                                isAscending.toggle()
                            } else {
                                sortedColumn = col
                                isAscending = true
                            }
                        } label: {
                            HStack(spacing: 4) {
                                Text(col.rawValue)
                                    .font(.caption2.bold().monospaced())
                                    .foregroundColor(.primary)

                                if sortedColumn == col {
                                    Image(systemName: isAscending ? "chevron.up" : "chevron.down")
                                        .font(.system(size: 9, weight: .bold))
                                        .foregroundColor(.accentColor)
                                }
                            }
                            .frame(width: col.width, alignment: col == .designation ? .leading : .trailing)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 10)
                            .background(ColorTokens.badgeBackground)
                        }
                        .buttonStyle(.plain)
                    }
                }

                Divider()

                // Rows
                ForEach(Array(sections.enumerated()), id: \.element.id) { (idx, sec) in
                    NavigationLink(destination: SectionDetailView(section: sec)) {
                        HStack(spacing: 0) {
                            Text(sec.designation)
                                .font(.caption.monospaced().bold())
                                .foregroundColor(.primary)
                                .frame(width: TableColumn.designation.width, alignment: .leading)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 8)

                            Text(String(format: "%.1f", sec.massPerMetre))
                                .font(.caption.monospaced())
                                .foregroundColor(.primary)
                                .frame(width: TableColumn.mass.width, alignment: .trailing)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 8)

                            Text(String(format: "%.1f", sec.area))
                                .font(.caption.monospaced())
                                .foregroundColor(.primary)
                                .frame(width: TableColumn.area.width, alignment: .trailing)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 8)

                            Text(sec.dimensions.primaryDepth != nil ? "\(Int(sec.dimensions.primaryDepth!))" : "—")
                                .font(.caption.monospaced())
                                .foregroundColor(.secondary)
                                .frame(width: TableColumn.depth.width, alignment: .trailing)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 8)

                            Text(sec.dimensions.primaryWidth != nil ? "\(Int(sec.dimensions.primaryWidth!))" : "—")
                                .font(.caption.monospaced())
                                .foregroundColor(.secondary)
                                .frame(width: TableColumn.width.width, alignment: .trailing)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 8)

                            Text(sec.structural.ixx_cm4 != nil ? String(format: "%.1f", sec.structural.ixx_cm4!) : "—")
                                .font(.caption.monospaced())
                                .foregroundColor(.secondary)
                                .frame(width: TableColumn.ixx.width, alignment: .trailing)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 8)

                            Text(sec.structural.iyy_cm4 != nil ? String(format: "%.1f", sec.structural.iyy_cm4!) : "—")
                                .font(.caption.monospaced())
                                .foregroundColor(.secondary)
                                .frame(width: TableColumn.iyy.width, alignment: .trailing)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 8)

                            Text(sec.structural.zxx_cm3 != nil ? String(format: "%.1f", sec.structural.zxx_cm3!) : "—")
                                .font(.caption.monospaced())
                                .foregroundColor(.secondary)
                                .frame(width: TableColumn.zxx.width, alignment: .trailing)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 8)

                            Text(sec.structural.zyy_cm3 != nil ? String(format: "%.1f", sec.structural.zyy_cm3!) : "—")
                                .font(.caption.monospaced())
                                .foregroundColor(.secondary)
                                .frame(width: TableColumn.zyy.width, alignment: .trailing)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 8)
                        }
                        .background(idx % 2 == 0 ? ColorTokens.cardBackground : ColorTokens.cardBackground.opacity(0.6))
                    }
                    .buttonStyle(.plain)

                    Divider()
                }
            }
        }
    }

    private var sortedAndFilteredSections: [SteelSection] {
        var items = environment.allSections.filter { $0.family == selectedFamily }

        if !searchText.isEmpty {
            let indexer = SectionSearchIndexer(sections: items)
            items = indexer.search(query: searchText, family: selectedFamily)
        }

        return items.sorted { s0, s1 in
            switch sortedColumn {
            case .designation:
                return isAscending ? s0.designation.localizedStandardCompare(s1.designation) == .orderedAscending
                                   : s0.designation.localizedStandardCompare(s1.designation) == .orderedDescending
            case .mass:
                return isAscending ? s0.massPerMetre < s1.massPerMetre : s0.massPerMetre > s1.massPerMetre
            case .area:
                return isAscending ? s0.area < s1.area : s0.area > s1.area
            case .depth:
                let d0 = s0.dimensions.primaryDepth ?? 0
                let d1 = s1.dimensions.primaryDepth ?? 0
                return isAscending ? d0 < d1 : d0 > d1
            case .width:
                let w0 = s0.dimensions.primaryWidth ?? 0
                let w1 = s1.dimensions.primaryWidth ?? 0
                return isAscending ? w0 < w1 : w0 > w1
            case .ixx:
                let i0 = s0.structural.ixx_cm4 ?? 0
                let i1 = s1.structural.ixx_cm4 ?? 0
                return isAscending ? i0 < i1 : i0 > i1
            case .iyy:
                let i0 = s0.structural.iyy_cm4 ?? 0
                let i1 = s1.structural.iyy_cm4 ?? 0
                return isAscending ? i0 < i1 : i0 > i1
            case .zxx:
                let z0 = s0.structural.zxx_cm3 ?? 0
                let z1 = s1.structural.zxx_cm3 ?? 0
                return isAscending ? z0 < z1 : z0 > z1
            case .zyy:
                let z0 = s0.structural.zyy_cm3 ?? 0
                let z1 = s1.structural.zyy_cm3 ?? 0
                return isAscending ? z0 < z1 : z0 > z1
            }
        }
    }
}
