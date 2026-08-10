import Foundation

/// Item in a steel estimation takeoff / Bill of Materials (BOM).
public struct ProjectBOMItem: Identifiable, Codable, Hashable, Sendable {
    public let id: UUID
    public var sectionId: String
    public var designation: String
    public var family: SectionFamily
    public var massPerMetre: Double
    public var quantity: Int
    public var lengthMeters: Double
    public var unitRatePerKg: Double?
    public var remarks: String

    public init(
        id: UUID = UUID(),
        sectionId: String,
        designation: String,
        family: SectionFamily,
        massPerMetre: Double,
        quantity: Int,
        lengthMeters: Double,
        unitRatePerKg: Double? = nil,
        remarks: String = ""
    ) {
        self.id = id
        self.sectionId = sectionId
        self.designation = designation
        self.family = family
        self.massPerMetre = massPerMetre
        self.quantity = quantity
        self.lengthMeters = lengthMeters
        self.unitRatePerKg = unitRatePerKg
        self.remarks = remarks
    }

    /// Total length in meters for this line item
    public var totalLengthMeters: Double {
        Double(quantity) * lengthMeters
    }

    /// Total mass in kilograms (kg)
    public var totalMassKg: Double {
        totalLengthMeters * massPerMetre
    }

    /// Total mass in tonnes (t)
    public var totalMassTonnes: Double {
        totalMassKg / 1000.0
    }

    /// Estimated cost based on rate per kg
    public var estimatedCost: Double? {
        guard let rate = unitRatePerKg, rate > 0 else { return nil }
        return totalMassKg * rate
    }
}

/// Project container with multiple steel takeoff items and aggregate metrics.
public struct SteelProject: Identifiable, Codable, Hashable, Sendable {
    public let id: UUID
    public var projectName: String
    public var clientOrLocation: String
    public var items: [ProjectBOMItem]
    public var createdAt: Date
    public var updatedAt: Date
    public var currencySymbol: String

    public init(
        id: UUID = UUID(),
        projectName: String = "Untitled Steel Project",
        clientOrLocation: String = "",
        items: [ProjectBOMItem] = [],
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        currencySymbol: String = "₹"
    ) {
        self.id = id
        self.projectName = projectName
        self.clientOrLocation = clientOrLocation
        self.items = items
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.currencySymbol = currencySymbol
    }

    public var totalItemsCount: Int {
        items.reduce(0) { $0 + $1.quantity }
    }

    public var totalLengthMeters: Double {
        items.reduce(0.0) { $0 + $1.totalLengthMeters }
    }

    public var totalMassKg: Double {
        items.reduce(0.0) { $0 + $1.totalMassKg }
    }

    public var totalMassTonnes: Double {
        totalMassKg / 1000.0
    }

    public var totalEstimatedCost: Double {
        items.compactMap { $0.estimatedCost }.reduce(0.0, +)
    }
}
