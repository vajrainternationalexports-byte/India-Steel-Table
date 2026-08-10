import Foundation

/// Defines engineering units and system preferences.
public enum EngineeringUnitSystem: String, CaseIterable, Codable, Sendable {
    case metric = "Metric (IS Standard)"
    case imperial = "Imperial (US/UK)"

    public var isMetric: Bool { self == .metric }
}

public enum LengthUnit: String, CaseIterable, Identifiable, Sendable {
    case millimeter = "mm"
    case centimeter = "cm"
    case meter = "m"
    case inch = "in"
    case foot = "ft"

    public var id: String { rawValue }

    /// Conversion multiplier to meters (m)
    public var toMeterMultiplier: Double {
        switch self {
        case .millimeter: return 0.001
        case .centimeter: return 0.01
        case .meter: return 1.0
        case .inch: return 0.0254
        case .foot: return 0.3048
        }
    }
}

public enum MassUnit: String, CaseIterable, Identifiable, Sendable {
    case kilogram = "kg"
    case tonne = "tonne (t)"
    case quintal = "quintal (q)"
    case pound = "lb"

    public var id: String { rawValue }

    /// Conversion multiplier to kilograms (kg)
    public var toKgMultiplier: Double {
        switch self {
        case .kilogram: return 1.0
        case .tonne: return 1000.0
        case .quintal: return 100.0
        case .pound: return 0.45359237
        }
    }
}

public enum ForceUnit: String, CaseIterable, Identifiable, Sendable {
    case newton = "N"
    case kilonewton = "kN"
    case kilogramForce = "kgf"

    public var id: String { rawValue }

    /// Conversion to Newtons (N)
    public var toNewtonMultiplier: Double {
        switch self {
        case .newton: return 1.0
        case .kilonewton: return 1000.0
        case .kilogramForce: return 9.80665
        }
    }
}

public enum AreaUnit: String, CaseIterable, Identifiable, Sendable {
    case mm2 = "mm²"
    case cm2 = "cm²"
    case m2 = "m²"
    case in2 = "in²"
    case ft2 = "ft²"

    public var id: String { rawValue }

    /// Conversion multiplier to cm²
    public var toCm2Multiplier: Double {
        switch self {
        case .mm2: return 0.01
        case .cm2: return 1.0
        case .m2: return 10000.0
        case .in2: return 6.4516
        case .ft2: return 929.0304
        }
    }
}

public enum InertiaUnit: String, CaseIterable, Identifiable, Sendable {
    case cm4 = "cm⁴"
    case mm4 = "mm⁴ (x10⁴)"
    case in4 = "in⁴"

    public var id: String { rawValue }

    /// Conversion multiplier to cm⁴
    public var toCm4Multiplier: Double {
        switch self {
        case .cm4: return 1.0
        case .mm4: return 0.0001
        case .in4: return 41.62314
        }
    }
}
