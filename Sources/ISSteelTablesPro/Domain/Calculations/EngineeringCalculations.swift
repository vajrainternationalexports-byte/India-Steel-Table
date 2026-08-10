import Foundation

/// Pure deterministic engineering calculation engine for structural steel sections according to BIS standards.
public struct EngineeringCalculations {
    /// Standard structural steel density in kg/m³ (IS 2062 / IS 800)
    public static let defaultSteelDensityKgM3: Double = 7850.0

    /// Standard acceleration due to gravity in m/s²
    public static let standardGravityMPerS2: Double = 9.80665

    // MARK: - Section Mass & Weight Calculations

    /// Calculate total mass from length and mass per metre: Mass = Qty × Length (m) × W (kg/m)
    public static func calculateSectionTotalMass(
        quantity: Int,
        lengthMeters: Double,
        massPerMetreKg: Double
    ) -> (massKg: Double, massTonnes: Double, weightKN: Double) {
        guard quantity > 0, lengthMeters >= 0, massPerMetreKg >= 0 else {
            return (0, 0, 0)
        }
        let totalMassKg = Double(quantity) * lengthMeters * massPerMetreKg
        let massTonnes = totalMassKg / 1000.0
        let weightKN = (totalMassKg * standardGravityMPerS2) / 1000.0
        return (totalMassKg, massTonnes, weightKN)
    }

    // MARK: - Plate Mass Calculation (IS 2062)

    /// Calculate steel plate mass: Mass = Length (m) × Width (m) × Thickness (mm) × 7.85 kg/(m²·mm)
    public static func calculatePlateMass(
        lengthMeters: Double,
        widthMeters: Double,
        thicknessMm: Double,
        quantity: Int = 1,
        densityKgM3: Double = defaultSteelDensityKgM3
    ) -> (unitMassKg: Double, totalMassKg: Double, massPerSqMeter: Double, areaM2: Double) {
        guard lengthMeters >= 0, widthMeters >= 0, thicknessMm >= 0, quantity > 0 else {
            return (0, 0, 0, 0)
        }
        let areaM2 = lengthMeters * widthMeters
        let thicknessM = thicknessMm / 1000.0
        let volumeM3 = areaM2 * thicknessM
        let unitMassKg = volumeM3 * densityKgM3
        let totalMassKg = unitMassKg * Double(quantity)
        let massPerSqMeter = (thicknessMm / 1000.0) * densityKgM3

        return (unitMassKg, totalMassKg, massPerSqMeter, areaM2)
    }

    // MARK: - Flat Bar Mass Calculation (IS 1731)

    /// Calculate steel flat bar mass: Mass = Width (mm) × Thickness (mm) × 0.00785 kg/m × Length (m)
    public static func calculateFlatBarMass(
        widthMm: Double,
        thicknessMm: Double,
        lengthMeters: Double,
        quantity: Int = 1,
        densityKgM3: Double = defaultSteelDensityKgM3
    ) -> (massPerMetreKg: Double, totalMassKg: Double, areaCm2: Double) {
        guard widthMm >= 0, thicknessMm >= 0, lengthMeters >= 0, quantity > 0 else {
            return (0, 0, 0)
        }
        let areaMm2 = widthMm * thicknessMm
        let areaCm2 = areaMm2 / 100.0
        let areaM2 = areaMm2 / 1_000_000.0
        let massPerMetreKg = areaM2 * densityKgM3
        let totalMassKg = massPerMetreKg * lengthMeters * Double(quantity)

        return (massPerMetreKg, totalMassKg, areaCm2)
    }

    // MARK: - Round Bar Mass Calculation (IS 1732)

    /// Calculate round steel bar mass using D²/162 rule and exact π·D²/4·ρ
    public static func calculateRoundBarMass(
        diameterMm: Double,
        lengthMeters: Double,
        quantity: Int = 1,
        densityKgM3: Double = defaultSteelDensityKgM3
    ) -> (massPerMetreKg: Double, totalMassKg: Double, areaCm2: Double, rule162MassPerM: Double) {
        guard diameterMm >= 0, lengthMeters >= 0, quantity > 0 else {
            return (0, 0, 0, 0)
        }
        let areaMm2 = (Double.pi / 4.0) * (diameterMm * diameterMm)
        let areaCm2 = areaMm2 / 100.0
        let areaM2 = areaMm2 / 1_000_000.0
        let massPerMetreKg = areaM2 * densityKgM3
        let totalMassKg = massPerMetreKg * lengthMeters * Double(quantity)
        let rule162 = (diameterMm * diameterMm) / 162.0  # Standard site approximation

        return (massPerMetreKg, totalMassKg, areaCm2, rule162)
    }

    // MARK: - Square Bar Mass Calculation (IS 1732)

    /// Calculate square steel bar mass: Mass = Side² × ρ × Length
    public static func calculateSquareBarMass(
        sideMm: Double,
        lengthMeters: Double,
        quantity: Int = 1,
        densityKgM3: Double = defaultSteelDensityKgM3
    ) -> (massPerMetreKg: Double, totalMassKg: Double, areaCm2: Double) {
        guard sideMm >= 0, lengthMeters >= 0, quantity > 0 else {
            return (0, 0, 0)
        }
        let areaMm2 = sideMm * sideMm
        let areaCm2 = areaMm2 / 100.0
        let areaM2 = areaMm2 / 1_000_000.0
        let massPerMetreKg = areaM2 * densityKgM3
        let totalMassKg = massPerMetreKg * lengthMeters * Double(quantity)

        return (massPerMetreKg, totalMassKg, areaCm2)
    }

    // MARK: - Pipe & Circular Hollow Section Mass Calculation (IS 1161)

    /// Calculate circular pipe mass: Mass = π × (OD - t) × t × ρ × Length
    public static func calculateCircularPipeMass(
        outerDiameterMm: Double,
        wallThicknessMm: Double,
        lengthMeters: Double,
        quantity: Int = 1,
        densityKgM3: Double = defaultSteelDensityKgM3
    ) -> (massPerMetreKg: Double, totalMassKg: Double, areaCm2: Double, internalVolCm3PerM: Double) {
        guard outerDiameterMm > wallThicknessMm * 2, wallThicknessMm > 0, lengthMeters >= 0, quantity > 0 else {
            return (0, 0, 0, 0)
        }
        let innerDiameterMm = outerDiameterMm - (2.0 * wallThicknessMm)
        let outerAreaMm2 = (Double.pi / 4.0) * (outerDiameterMm * outerDiameterMm)
        let innerAreaMm2 = (Double.pi / 4.0) * (innerDiameterMm * innerDiameterMm)
        let steelAreaMm2 = outerAreaMm2 - innerAreaMm2
        let areaCm2 = steelAreaMm2 / 100.0
        let massPerMetreKg = (steelAreaMm2 / 1_000_000.0) * densityKgM3
        let totalMassKg = massPerMetreKg * lengthMeters * Double(quantity)
        let internalVolCm3PerM = (innerAreaMm2 / 100.0) * 100.0  # cm³ per meter of pipe

        return (massPerMetreKg, totalMassKg, areaCm2, internalVolCm3PerM)
    }

    // MARK: - Rectangular & Square Hollow Section Mass Calculation (IS 4923)

    /// Calculate RHS/SHS tube mass
    public static func calculateHollowSectionMass(
        depthMm: Double,
        widthMm: Double,
        wallThicknessMm: Double,
        lengthMeters: Double,
        quantity: Int = 1,
        densityKgM3: Double = defaultSteelDensityKgM3
    ) -> (massPerMetreKg: Double, totalMassKg: Double, areaCm2: Double) {
        guard depthMm > wallThicknessMm * 2, widthMm > wallThicknessMm * 2, wallThicknessMm > 0, lengthMeters >= 0, quantity > 0 else {
            return (0, 0, 0)
        }
        // Approximate cross-sectional area taking standard corner fillets into account (2t(h + b - 2t))
        let steelAreaMm2 = 2.0 * wallThicknessMm * (depthMm + widthMm - 2.0 * wallThicknessMm)
        let areaCm2 = steelAreaMm2 / 100.0
        let massPerMetreKg = (steelAreaMm2 / 1_000_000.0) * densityKgM3
        let totalMassKg = massPerMetreKg * lengthMeters * Double(quantity)

        return (massPerMetreKg, totalMassKg, areaCm2)
    }
}
