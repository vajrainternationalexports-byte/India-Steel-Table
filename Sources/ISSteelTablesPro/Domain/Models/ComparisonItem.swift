import Foundation

/// Model for comparing 2 to 5 sections side-by-side.
public struct SectionComparisonMatrix: Sendable {
    public let sections: [SteelSection]

    public init(sections: [SteelSection]) {
        self.sections = sections
    }

    public struct ComparisonRow: Identifiable, Sendable {
        public let id: String
        public let propertyName: String
        public let symbol: String
        public let unit: String
        public let values: [Double?]
        public let displayValues: [String]
        public let maxIndex: Int?
        public let minIndex: Int?
    }

    public func generateComparisonRows(precision: Int = 2) -> [ComparisonRow] {
        guard !sections.isEmpty else { return [] }

        var rows: [ComparisonRow] = []

        func addRow(
            id: String,
            name: String,
            symbol: String,
            unit: String,
            keyPath: (SteelSection) -> Double?
        ) {
            let vals = sections.map(keyPath)
            // If all nil, skip
            if vals.allSatisfy({ $0 == nil }) { return }

            let displayVals = vals.map { val -> String in
                if let v = val {
                    return String(format: "%.\(precision)f", v)
                } else {
                    return "—"
                }
            }

            var maxIdx: Int? = nil
            var minIdx: Int? = nil
            var maxV = -Double.infinity
            var minV = Double.infinity

            for (i, v) in vals.enumerated() {
                if let v = v {
                    if v > maxV {
                        maxV = v
                        maxIdx = i
                    }
                    if v < minV {
                        minV = v
                        minIdx = i
                    }
                }
            }

            if maxV == minV {
                maxIdx = nil
                minIndex = nil
            }

            rows.append(ComparisonRow(
                id: id,
                propertyName: name,
                symbol: symbol,
                unit: unit,
                values: vals,
                displayValues: displayVals,
                maxIndex: maxIdx,
                minIndex: minIdx
            ))
        }

        addRow(id: "mass", name: "Mass per Metre", symbol: "W", unit: "kg/m", keyPath: { $0.massPerMetre })
        addRow(id: "area", name: "Cross-Sectional Area", symbol: "A", unit: "cm²", keyPath: { $0.area })
        addRow(id: "depth", name: "Depth / Height", symbol: "h", unit: "mm", keyPath: { $0.dimensions.depth_h_mm ?? $0.dimensions.outerDiameter_od_mm ?? $0.dimensions.side_s_mm ?? $0.dimensions.diameter_d_mm ?? $0.dimensions.legA_mm })
        addRow(id: "width", name: "Width / Flange", symbol: "b", unit: "mm", keyPath: { $0.dimensions.width_b_mm ?? $0.dimensions.legB_mm ?? $0.dimensions.side_s_mm })
        addRow(id: "tw", name: "Web / Leg Thickness", symbol: "tw / t", unit: "mm", keyPath: { $0.dimensions.webThickness_tw_mm ?? $0.dimensions.thickness_t_mm ?? $0.dimensions.wallThickness_t_mm })
        addRow(id: "tf", name: "Flange Thickness", symbol: "tf", unit: "mm", keyPath: { $0.dimensions.flangeThickness_tf_mm })
        addRow(id: "ixx", name: "Moment of Inertia (X-X)", symbol: "Ixx", unit: "cm⁴", keyPath: { $0.structural.ixx_cm4 })
        addRow(id: "iyy", name: "Moment of Inertia (Y-Y)", symbol: "Iyy", unit: "cm⁴", keyPath: { $0.structural.iyy_cm4 })
        addRow(id: "rxx", name: "Radius of Gyration (X-X)", symbol: "rx", unit: "cm", keyPath: { $0.structural.rxx_cm })
        addRow(id: "ryy", name: "Radius of Gyration (Y-Y)", symbol: "ry", unit: "cm", keyPath: { $0.structural.ryy_cm })
        addRow(id: "zxx", name: "Elastic Modulus (X-X)", symbol: "Zxx", unit: "cm³", keyPath: { $0.structural.zxx_cm3 })
        addRow(id: "zyy", name: "Elastic Modulus (Y-Y)", symbol: "Zyy", unit: "cm³", keyPath: { $0.structural.zyy_cm3 })

        return rows
    }
}
