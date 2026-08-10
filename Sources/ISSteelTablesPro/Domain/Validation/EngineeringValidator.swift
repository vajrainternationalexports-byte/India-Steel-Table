import Foundation

/// Runtime validation engine to prevent display of corrupted or physically impossible steel values.
public struct EngineeringValidator {

    public enum ValidationResult: Sendable {
        case valid
        case warning(message: String)
        case invalid(reason: String)
    }

    /// Validates an individual steel section against engineering invariants
    public static func validateSection(_ section: SteelSection) -> ValidationResult {
        if section.massPerMetre <= 0 {
            return .invalid(reason: "Non-positive mass per metre: \(section.massPerMetre)")
        }
        if section.area <= 0 {
            return .invalid(reason: "Non-positive cross-sectional area: \(section.area)")
        }

        // Invariant: Density check W ≈ A * 0.785 kg/m for steel (density 7.85 g/cm³)
        if section.family != .hrPlates {
            let expectedMass = section.area * 0.785
            let discrepancy = abs(expectedMass - section.massPerMetre) / section.massPerMetre
            if discrepancy > 0.10 {
                return .warning(message: "Mass/Area nominal discrepancy of \(String(format: "%.1f", discrepancy * 100))% exceeds standard tolerance.")
            }
        }

        return .valid
    }

    /// Validates user calculation input
    public static func validateCalculationInput(
        dimension: Double,
        name: String,
        min: Double = 0.001,
        max: Double = 100_000.0
    ) -> (isValid: Bool, error: String?) {
        if dimension.isNaN || dimension.isInfinite {
            return (false, "\(name) must be a valid number.")
        }
        if dimension <= 0 {
            return (false, "\(name) must be greater than zero.")
        }
        if dimension < min || dimension > max {
            return (false, "\(name) must be between \(min) and \(max).")
        }
        return (true, nil)
    }
}
