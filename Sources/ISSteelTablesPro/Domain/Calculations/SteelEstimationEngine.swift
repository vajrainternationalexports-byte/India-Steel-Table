import Foundation

/// Engine for calculating Project BOM totals, mass breakdown by section family, and cost estimation.
public struct SteelEstimationEngine {

    public struct BOMSummary: Sendable {
        public let totalItemsCount: Int
        public let totalLengthMeters: Double
        public let totalMassKg: Double
        public let totalMassTonnes: Double
        public let totalEstimatedCost: Double
        public let massByFamily: [SectionFamily: Double]
        public let heaviestSection: ProjectBOMItem?
        public let longestSection: ProjectBOMItem?
    }

    public static func summarizeProject(_ project: SteelProject) -> BOMSummary {
        var massByFamily: [SectionFamily: Double] = [:]
        var heaviest: ProjectBOMItem? = nil
        var longest: ProjectBOMItem? = nil
        var maxMass = 0.0
        var maxLength = 0.0

        for item in project.items {
            let itemMass = item.totalMassKg
            massByFamily[item.family, default: 0.0] += itemMass

            if itemMass > maxMass {
                maxMass = itemMass
                heaviest = item
            }
            if item.totalLengthMeters > maxLength {
                maxLength = item.totalLengthMeters
                longest = item
            }
        }

        return BOMSummary(
            totalItemsCount: project.totalItemsCount,
            totalLengthMeters: project.totalLengthMeters,
            totalMassKg: project.totalMassKg,
            totalMassTonnes: project.totalMassTonnes,
            totalEstimatedCost: project.totalEstimatedCost,
            massByFamily: massByFamily,
            heaviestSection: heaviest,
            longestSection: longest
        )
    }
}
