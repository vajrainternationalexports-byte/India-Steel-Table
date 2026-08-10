import Foundation

/// Categorized property groups for clean display and one-tap copying.
public enum PropertyCategory: String, CaseIterable, Identifiable, Sendable {
    case general = "General & Standards"
    case dimensions = "Dimensions & Radii"
    case massArea = "Mass & Cross-Sectional Area"
    case inertia = "Moments of Inertia (Second Moment)"
    case radiiOfGyration = "Radii of Gyration"
    case sectionModulus = "Section Modulus"
    case centroid = "Centroid & Principal Axes"
    case surfaceFlow = "Surface & Fluid Flow"

    public var id: String { rawValue }

    public var iconName: String {
        switch self {
        case .general: return "info.circle"
        case .dimensions: return "ruler"
        case .massArea: return "scalemass"
        case .inertia: return "rotate.3d"
        case .radiiOfGyration: return "circle.dashed"
        case .sectionModulus: return "cube"
        case .centroid: return "scope"
        case .surfaceFlow: return "drop"
        }
    }
}

/// A formatted property item for display.
public struct PropertyDisplayItem: Identifiable, Sendable {
    public let id: String
    public let label: String
    public let symbol: String
    public let value: String
    public let unit: String
    public let category: PropertyCategory

    public init(label: String, symbol: String, value: String, unit: String, category: PropertyCategory) {
        self.id = "\(category.rawValue)-\(symbol)-\(label)"
        self.label = label
        self.symbol = symbol
        self.value = value
        self.unit = unit
        self.category = category
    }

    public var formattedFullText: String {
        if symbol.isEmpty {
            return "\(label): \(value) \(unit)".trimmingCharacters(in: .whitespaces)
        }
        return "\(label) (\(symbol)): \(value) \(unit)".trimmingCharacters(in: .whitespaces)
    }
}

/// Dynamic property extraction engine.
public struct SectionPropertyExtractor {

    public static func extractAllProperties(
        section: SteelSection,
        precision: Int = 2
    ) -> [PropertyCategory: [PropertyDisplayItem]] {
        var dict: [PropertyCategory: [PropertyDisplayItem]] = [:]

        // 1. General & Standards
        var general: [PropertyDisplayItem] = [
            PropertyDisplayItem(label: "Designation", symbol: "", value: section.designation, unit: "", category: .general),
            PropertyDisplayItem(label: "Category Family", symbol: "", value: section.family.rawValue, unit: "", category: .general),
            PropertyDisplayItem(label: "Reference Standard", symbol: "", value: section.standard, unit: "", category: .general)
        ]
        if !section.series.isEmpty {
            general.append(PropertyDisplayItem(label: "Section Series", symbol: "", value: section.series, unit: "", category: .general))
        }
        dict[.general] = general

        // 2. Mass & Area
        var massArea: [PropertyDisplayItem] = []
        let isPlate = section.family == .hrPlates
        massArea.append(PropertyDisplayItem(
            label: isPlate ? "Mass per Unit Area" : "Mass per Metre",
            symbol: "M / W",
            value: formatNumber(section.massPerMetre, precision: precision),
            unit: isPlate ? "kg/m²" : "kg/m",
            category: .massArea
        ))
        massArea.append(PropertyDisplayItem(
            label: "Cross-Sectional Area",
            symbol: "Ar / A",
            value: formatNumber(section.area, precision: precision),
            unit: "cm²",
            category: .massArea
        ))
        dict[.massArea] = massArea

        // 3. Dimensions & Radii
        var dims: [PropertyDisplayItem] = []
        let d = section.dimensions
        if let la = d.legA_mm {
            if let lb = d.legB_mm, lb != la {
                dims.append(PropertyDisplayItem(label: "Leg Dimensions (A × B)", symbol: "A, B", value: "\(Int(la)) × \(Int(lb))", unit: "mm", category: .dimensions))
            } else {
                dims.append(PropertyDisplayItem(label: "Leg Length", symbol: "A, B", value: "\(Int(la)) × \(Int(la))", unit: "mm", category: .dimensions))
            }
        }
        if let h = d.depth_h_mm {
            dims.append(PropertyDisplayItem(label: "Depth / Height", symbol: "h", value: formatNumber(h, precision: 1), unit: "mm", category: .dimensions))
        }
        if let b = d.width_b_mm {
            dims.append(PropertyDisplayItem(label: "Width / Flange Width", symbol: "b / bf", value: formatNumber(b, precision: 1), unit: "mm", category: .dimensions))
        }
        if let t = d.thickness_t_mm {
            dims.append(PropertyDisplayItem(label: "Thickness", symbol: "t", value: formatNumber(t, precision: 1), unit: "mm", category: .dimensions))
        }
        if let tw = d.webThickness_tw_mm {
            dims.append(PropertyDisplayItem(label: "Web Thickness", symbol: "tw", value: formatNumber(tw, precision: 1), unit: "mm", category: .dimensions))
        }
        if let tf = d.flangeThickness_tf_mm {
            dims.append(PropertyDisplayItem(label: "Flange Thickness", symbol: "tf", value: formatNumber(tf, precision: 1), unit: "mm", category: .dimensions))
        }
        if let r1 = d.rootRadius_r1_mm ?? d.rootRadius_R_mm {
            dims.append(PropertyDisplayItem(label: "Root Radius", symbol: "R₁ / R", value: formatNumber(r1, precision: 1), unit: "mm", category: .dimensions))
        }
        if let r2Desc = d.toeRadius_r2_description {
            dims.append(PropertyDisplayItem(label: "Toe Radius", symbol: "R₂", value: r2Desc, unit: "", category: .dimensions))
        } else if let r2 = d.toeRadius_r_mm {
            dims.append(PropertyDisplayItem(label: "Toe Radius", symbol: "r / R₂", value: formatNumber(r2, precision: 1), unit: "mm", category: .dimensions))
        }
        if let slope = d.flangeSlope_deg {
            dims.append(PropertyDisplayItem(label: "Flange Slope", symbol: "Ø", value: "\(Int(slope))", unit: "°", category: .dimensions))
        }
        if let od = d.outerDiameter_od_mm {
            dims.append(PropertyDisplayItem(label: "Outer Diameter", symbol: "OD", value: formatNumber(od, precision: 1), unit: "mm", category: .dimensions))
        }
        if let nb = d.nominalBore_nb_mm {
            dims.append(PropertyDisplayItem(label: "Nominal Bore", symbol: "NB", value: "\(Int(nb))", unit: "mm", category: .dimensions))
        }
        if let wt = d.wallThickness_t_mm {
            dims.append(PropertyDisplayItem(label: "Wall Thickness", symbol: "t", value: formatNumber(wt, precision: 1), unit: "mm", category: .dimensions))
        }
        if let dia = d.diameter_d_mm {
            dims.append(PropertyDisplayItem(label: "Bar Diameter", symbol: "Ø", value: formatNumber(dia, precision: 1), unit: "mm", category: .dimensions))
        }
        if let side = d.side_s_mm {
            dims.append(PropertyDisplayItem(label: "Square Side", symbol: "S", value: formatNumber(side, precision: 1), unit: "mm", category: .dimensions))
        }
        dict[.dimensions] = dims

        // 4. Moments of Inertia
        var inertia: [PropertyDisplayItem] = []
        let s = section.structural
        if let ixx = s.ixx_cm4 {
            inertia.append(PropertyDisplayItem(label: "Moment of Inertia X-X", symbol: "Ix / Ixx", value: formatNumber(ixx, precision: precision), unit: "cm⁴", category: .inertia))
        }
        if let iyy = s.iyy_cm4 {
            inertia.append(PropertyDisplayItem(label: "Moment of Inertia Y-Y", symbol: "Iy / Iyy", value: formatNumber(iyy, precision: precision), unit: "cm⁴", category: .inertia))
        }
        if let iu = s.iuMax_cm4 {
            inertia.append(PropertyDisplayItem(label: "Principal Inertia U-U (Max)", symbol: "Iu max", value: formatNumber(iu, precision: precision), unit: "cm⁴", category: .inertia))
        }
        if let iv = s.ivMin_cm4 {
            inertia.append(PropertyDisplayItem(label: "Principal Inertia V-V (Min)", symbol: "Iv min", value: formatNumber(iv, precision: precision), unit: "cm⁴", category: .inertia))
        }
        if let it = s.it_cm4 {
            inertia.append(PropertyDisplayItem(label: "Torsion Constant", symbol: "It", value: formatNumber(it, precision: precision), unit: "cm⁴", category: .inertia))
        }
        dict[.inertia] = inertia

        // 5. Radii of Gyration
        var radii: [PropertyDisplayItem] = []
        if let rx = s.rxx_cm {
            radii.append(PropertyDisplayItem(label: "Radius of Gyration X-X", symbol: "rx", value: formatNumber(rx, precision: precision), unit: "cm", category: .radiiOfGyration))
        }
        if let ry = s.ryy_cm {
            radii.append(PropertyDisplayItem(label: "Radius of Gyration Y-Y", symbol: "ry", value: formatNumber(ry, precision: precision), unit: "cm", category: .radiiOfGyration))
        }
        if let ru = s.ruMax_cm {
            radii.append(PropertyDisplayItem(label: "Radius of Gyration U-U (Max)", symbol: "ru max", value: formatNumber(ru, precision: precision), unit: "cm", category: .radiiOfGyration))
        }
        if let rv = s.rvMin_cm {
            radii.append(PropertyDisplayItem(label: "Radius of Gyration V-V (Min)", symbol: "rv min", value: formatNumber(rv, precision: precision), unit: "cm", category: .radiiOfGyration))
        }
        dict[.radiiOfGyration] = radii

        // 6. Section Modulus
        var modulus: [PropertyDisplayItem] = []
        if let zxx = s.zxx_cm3 {
            modulus.append(PropertyDisplayItem(label: "Elastic Section Modulus X-X", symbol: "Zx / Zxx", value: formatNumber(zxx, precision: precision), unit: "cm³", category: .sectionModulus))
        }
        if let zyy = s.zyy_cm3 {
            modulus.append(PropertyDisplayItem(label: "Elastic Section Modulus Y-Y", symbol: "Zy / Zyy", value: formatNumber(zyy, precision: precision), unit: "cm³", category: .sectionModulus))
        }
        if let zpx = s.zp_x_cm3 {
            modulus.append(PropertyDisplayItem(label: "Plastic Section Modulus X-X", symbol: "Zp,x", value: formatNumber(zpx, precision: precision), unit: "cm³", category: .sectionModulus))
        }
        dict[.sectionModulus] = modulus

        // 7. Centroid & Principal Axes
        var centroid: [PropertyDisplayItem] = []
        if let cx = s.cx_cm {
            centroid.append(PropertyDisplayItem(label: "Centroid Distance Cx", symbol: "Cx", value: formatNumber(cx, precision: precision), unit: "cm", category: .centroid))
        }
        if let cy = s.cy_cm {
            centroid.append(PropertyDisplayItem(label: "Centroid Distance Cy", symbol: "Cy", value: formatNumber(cy, precision: precision), unit: "cm", category: .centroid))
        }
        if let tanA = s.tanAlpha {
            centroid.append(PropertyDisplayItem(label: "Principal Axis Inclination", symbol: "Tan α", value: formatNumber(tanA, precision: 2), unit: "", category: .centroid))
        }
        dict[.centroid] = centroid

        // 8. Surface & Flow
        if let surf = section.surface {
            var surfaceItems: [PropertyDisplayItem] = []
            if let sa = surf.surfaceAreaPerMetre_m2 {
                surfaceItems.append(PropertyDisplayItem(label: "Surface Area / Metre", symbol: "Sa", value: formatNumber(sa, precision: 3), unit: "m²/m", category: .surfaceFlow))
            }
            if let ext = surf.externalSurface_cm2PerM {
                surfaceItems.append(PropertyDisplayItem(label: "External Surface Area", symbol: "Se", value: formatNumber(ext, precision: 1), unit: "cm²/m", category: .surfaceFlow))
            }
            if let intS = surf.internalSurface_cm2PerM {
                surfaceItems.append(PropertyDisplayItem(label: "Internal Surface Area", symbol: "Si", value: formatNumber(intS, precision: 1), unit: "cm²/m", category: .surfaceFlow))
            }
            if let vol = surf.internalVolume_cm3PerM {
                surfaceItems.append(PropertyDisplayItem(label: "Internal Volume / Capacity", symbol: "V", value: formatNumber(vol, precision: 1), unit: "cm³/m", category: .surfaceFlow))
            }
            dict[.surfaceFlow] = surfaceItems
        }

        return dict
    }

    private static func formatNumber(_ num: Double, precision: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = precision
        return formatter.string(from: NSNumber(value: num)) ?? "\(num)"
    }
}
