import Foundation

/// Immutable domain model representing a single Indian Standard (IS) structural steel section.
public struct SteelSection: Identifiable, Codable, Hashable, Sendable {
    public let id: String
    public let designation: String
    public let family: SectionFamily
    public let series: String
    public let standard: String
    public let massPerMetre: Double     // kg/m (or kg/m² for plates)
    public let area: Double             // cm²

    public let dimensions: SectionDimensions
    public let structural: StructuralProperties
    public let surface: SurfaceProperties?
    public let aliases: [String]

    public init(
        id: String,
        designation: String,
        family: SectionFamily,
        series: String,
        standard: String,
        massPerMetre: Double,
        area: Double,
        dimensions: SectionDimensions,
        structural: StructuralProperties,
        surface: SurfaceProperties? = nil,
        aliases: [String] = []
    ) {
        self.id = id
        self.designation = designation
        self.family = family
        self.series = series
        self.standard = standard
        self.massPerMetre = massPerMetre
        self.area = area
        self.dimensions = dimensions
        self.structural = structural
        self.surface = surface
        self.aliases = aliases
    }

    /// Normalized designation for instant query matching (e.g., "ISMB 300" -> "ISMB300")
    public var normalizedDesignation: String {
        designation
            .uppercased()
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: "X", with: "X")
    }
}

/// Geometric dimensions of a structural steel section according to IS codes.
public struct SectionDimensions: Codable, Hashable, Sendable {
    // Angles
    public let legA_mm: Double?
    public let legB_mm: Double?
    public let thickness_t_mm: Double?
    public let rootRadius_r1_mm: Double?
    public let toeRadius_r2_description: String? // e.g. "Square" or "4.5 mm"

    // Beams & Channels & Tees
    public let depth_h_mm: Double?
    public let width_b_mm: Double?
    public let webThickness_tw_mm: Double?
    public let flangeThickness_tf_mm: Double?
    public let rootRadius_R_mm: Double?
    public let toeRadius_r_mm: Double?
    public let flangeSlope_deg: Double? // 98° for ISMB, 94° for ISHB, 95° for ISMC

    // Pipes / Tubes
    public let outerDiameter_od_mm: Double?
    public let nominalBore_nb_mm: Double?
    public let wallThickness_t_mm: Double?
    public let pipeClass: String? // Light, Medium, Heavy

    // Hollow Sections (RHS / SHS)
    public let cornerRadius_r_mm: Double?

    // Bars
    public let diameter_d_mm: Double?
    public let side_s_mm: Double?

    public init(
        legA_mm: Double? = nil,
        legB_mm: Double? = nil,
        thickness_t_mm: Double? = nil,
        rootRadius_r1_mm: Double? = nil,
        toeRadius_r2_description: String? = nil,
        depth_h_mm: Double? = nil,
        width_b_mm: Double? = nil,
        webThickness_tw_mm: Double? = nil,
        flangeThickness_tf_mm: Double? = nil,
        rootRadius_R_mm: Double? = nil,
        toeRadius_r_mm: Double? = nil,
        flangeSlope_deg: Double? = nil,
        outerDiameter_od_mm: Double? = nil,
        nominalBore_nb_mm: Double? = nil,
        wallThickness_t_mm: Double? = nil,
        pipeClass: String? = nil,
        cornerRadius_r_mm: Double? = nil,
        diameter_d_mm: Double? = nil,
        side_s_mm: Double? = nil
    ) {
        self.legA_mm = legA_mm
        self.legB_mm = legB_mm
        self.thickness_t_mm = thickness_t_mm
        self.rootRadius_r1_mm = rootRadius_r1_mm
        self.toeRadius_r2_description = toeRadius_r2_description
        self.depth_h_mm = depth_h_mm
        self.width_b_mm = width_b_mm
        self.webThickness_tw_mm = webThickness_tw_mm
        self.flangeThickness_tf_mm = flangeThickness_tf_mm
        self.rootRadius_R_mm = rootRadius_R_mm
        self.toeRadius_r_mm = toeRadius_r_mm
        self.flangeSlope_deg = flangeSlope_deg
        self.outerDiameter_od_mm = outerDiameter_od_mm
        self.nominalBore_nb_mm = nominalBore_nb_mm
        self.wallThickness_t_mm = wallThickness_t_mm
        self.pipeClass = pipeClass
        self.cornerRadius_r_mm = cornerRadius_r_mm
        self.diameter_d_mm = diameter_d_mm
        self.side_s_mm = side_s_mm
    }

    /// Primary Depth / Height for high-level sorting & filters
    public var primaryDepth: Double? {
        depth_h_mm ?? legA_mm ?? outerDiameter_od_mm ?? side_s_mm ?? diameter_d_mm
    }

    /// Primary Width for high-level sorting & filters
    public var primaryWidth: Double? {
        width_b_mm ?? legB_mm ?? legA_mm ?? outerDiameter_od_mm ?? side_s_mm ?? diameter_d_mm
    }
}

/// Structural mechanics properties according to SP 6(1) and IS 800.
public struct StructuralProperties: Codable, Hashable, Sendable {
    // Moments of Inertia (Second Moment of Area) in cm⁴
    public let ixx_cm4: Double?
    public let iyy_cm4: Double?
    public let iuMax_cm4: Double? // Principal Axis U-U (Max)
    public let ivMin_cm4: Double? // Principal Axis V-V (Min)

    // Radii of Gyration in cm
    public let rxx_cm: Double?
    public let ryy_cm: Double?
    public let ruMax_cm: Double?  // Radius of gyration ru (Max)
    public let rvMin_cm: Double?  // Radius of gyration rv (Min)

    // Elastic Section Modulus in cm³
    public let zxx_cm3: Double?
    public let zyy_cm3: Double?

    // Plastic Section Modulus in cm³
    public let zp_x_cm3: Double?
    public let zp_y_cm3: Double?

    // Centroid Distances & Principal Axis Inclination
    public let cx_cm: Double?
    public let cy_cm: Double?
    public let ex_cm: Double?
    public let ey_cm: Double?
    public let tanAlpha: Double?  // Inclination tan α of principal axis

    // Torsion & Warping Constants
    public let it_cm4: Double?    // Torsional constant
    public let iw_cm6: Double?    // Warping constant

    public init(
        ixx_cm4: Double? = nil,
        iyy_cm4: Double? = nil,
        iuMax_cm4: Double? = nil,
        ivMin_cm4: Double? = nil,
        rxx_cm: Double? = nil,
        ryy_cm: Double? = nil,
        ruMax_cm: Double? = nil,
        rvMin_cm: Double? = nil,
        zxx_cm3: Double? = nil,
        zyy_cm3: Double? = nil,
        zp_x_cm3: Double? = nil,
        zp_y_cm3: Double? = nil,
        cx_cm: Double? = nil,
        cy_cm: Double? = nil,
        ex_cm: Double? = nil,
        ey_cm: Double? = nil,
        tanAlpha: Double? = nil,
        it_cm4: Double? = nil,
        iw_cm6: Double? = nil
    ) {
        self.ixx_cm4 = ixx_cm4
        self.iyy_cm4 = iyy_cm4
        self.iuMax_cm4 = iuMax_cm4
        self.ivMin_cm4 = ivMin_cm4
        self.rxx_cm = rxx_cm
        self.ryy_cm = ryy_cm
        self.ruMax_cm = ruMax_cm
        self.rvMin_cm = rvMin_cm
        self.zxx_cm3 = zxx_cm3
        self.zyy_cm3 = zyy_cm3
        self.zp_x_cm3 = zp_x_cm3
        self.zp_y_cm3 = zp_y_cm3
        self.cx_cm = cx_cm
        self.cy_cm = cy_cm
        self.ex_cm = ex_cm
        self.ey_cm = ey_cm
        self.tanAlpha = tanAlpha
        self.it_cm4 = it_cm4
        self.iw_cm6 = iw_cm6
    }
}

/// Surface area and fluid capacity metrics (especially for pipes and hollow sections).
public struct SurfaceProperties: Codable, Hashable, Sendable {
    public let surfaceAreaPerMetre_m2: Double?
    public let externalSurface_cm2PerM: Double?
    public let internalSurface_cm2PerM: Double?
    public let internalVolume_cm3PerM: Double?

    public init(
        surfaceAreaPerMetre_m2: Double? = nil,
        externalSurface_cm2PerM: Double? = nil,
        internalSurface_cm2PerM: Double? = nil,
        internalVolume_cm3PerM: Double? = nil
    ) {
        self.surfaceAreaPerMetre_m2 = surfaceAreaPerMetre_m2
        self.externalSurface_cm2PerM = externalSurface_cm2PerM
        self.internalSurface_cm2PerM = internalSurface_cm2PerM
        self.internalVolume_cm3PerM = internalVolume_cm3PerM
    }
}
