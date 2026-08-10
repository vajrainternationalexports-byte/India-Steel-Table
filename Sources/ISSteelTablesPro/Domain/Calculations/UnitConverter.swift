import Foundation

/// Universal structural engineering unit converter covering Length, Mass, Force, Area, Second Moment of Area, Section Modulus, and Density.
public struct UnitConverter {

    // MARK: - Length
    public static func convertLength(value: Double, from: LengthUnit, to: LengthUnit) -> Double {
        let inMeters = value * from.toMeterMultiplier
        return inMeters / to.toMeterMultiplier
    }

    // MARK: - Mass
    public static func convertMass(value: Double, from: MassUnit, to: MassUnit) -> Double {
        let inKg = value * from.toKgMultiplier
        return inKg / to.toKgMultiplier
    }

    // MARK: - Force
    public static func convertForce(value: Double, from: ForceUnit, to: ForceUnit) -> Double {
        let inNewtons = value * from.toNewtonMultiplier
        return inNewtons / to.toNewtonMultiplier
    }

    // MARK: - Area
    public static func convertArea(value: Double, from: AreaUnit, to: AreaUnit) -> Double {
        let inCm2 = value * from.toCm2Multiplier
        return inCm2 / to.toCm2Multiplier
    }

    // MARK: - Moment of Inertia (Second Moment of Area)
    public static func convertInertia(value: Double, from: InertiaUnit, to: InertiaUnit) -> Double {
        let inCm4 = value * from.toCm4Multiplier
        return inCm4 / to.toCm4Multiplier
    }

    // MARK: - Section Modulus (cm³ ↔ mm³ ↔ in³)
    public static func convertSectionModulus(value: Double, fromUnit: String, toUnit: String) -> Double {
        // Normalize to cm³
        var inCm3 = value
        switch fromUnit.lowercased() {
        case "mm³", "mm3": inCm3 = value * 0.001
        case "cm³", "cm3": inCm3 = value
        case "m³", "m3": inCm3 = value * 1_000_000.0
        case "in³", "in3": inCm3 = value * 16.387064
        default: break
        }

        switch toUnit.lowercased() {
        case "mm³", "mm3": return inCm3 * 1000.0
        case "cm³", "cm3": return inCm3
        case "m³", "m3": return inCm3 / 1_000_000.0
        case "in³", "in3": return inCm3 / 16.387064
        default: return inCm3
        }
    }
}
