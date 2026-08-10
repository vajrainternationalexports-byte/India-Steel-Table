import XCTest
@testable import ISSteelTablesPro

final class DatasetValidationTests: XCTestCase {

    func testMasterDatasetCoverageAndInvariants() async throws {
        let repo = BundledSteelSectionRepository()
        let sections = try await repo.getAllSections()

        XCTAssertGreaterThanOrEqual(sections.count, 500, "Dataset should contain at least 500 verified structural sections")

        // Invariant check on all sections
        for sec in sections {
            XCTAssertFalse(sec.id.isEmpty, "Section ID must not be empty")
            XCTAssertFalse(sec.designation.isEmpty, "Designation must not be empty")
            XCTAssertGreaterThan(sec.massPerMetre, 0, "Mass must be positive for \(sec.designation)")
            XCTAssertGreaterThan(sec.area, 0, "Area must be positive for \(sec.designation)")

            // Check that validated passes
            let valResult = EngineeringValidator.validateSection(sec)
            switch valResult {
            case .invalid(let reason):
                XCTFail("Section \(sec.designation) failed invariant validation: \(reason)")
            default:
                break
            }
        }
    }

    func testAllCategoriesPresent() async throws {
        let repo = BundledSteelSectionRepository()
        let sections = try await repo.getAllSections()

        for family in SectionFamily.allCases {
            let count = sections.filter { $0.family == family }.count
            XCTAssertGreaterThan(count, 0, "Family \(family.rawValue) should have sections in the dataset")
        }
    }
}

final class SearchIndexerTests: XCTestCase {

    func testSearchNormalizationAndFuzzyMatching() async throws {
        let repo = BundledSteelSectionRepository()
        let sections = try await repo.getAllSections()
        let indexer = SectionSearchIndexer(sections: sections)

        // Exact match
        let ismb300 = indexer.search(query: "ISMB 300")
        XCTAssertTrue(ismb300.contains { $0.designation == "ISMB 300" })

        // Normalized no-space match
        let ismb300NoSpace = indexer.search(query: "ismb300")
        XCTAssertTrue(ismb300NoSpace.contains { $0.designation == "ISMB 300" })

        // Angle search with 'x'
        let angle = indexer.search(query: "ISA 50x50x6")
        XCTAssertTrue(angle.contains { $0.designation == "ISA 50X50X6" })

        // Channel search
        let channel = indexer.search(query: "ISMC 150")
        XCTAssertTrue(channel.contains { $0.designation == "ISMC 150" })
    }
}

final class BOMEstimatorTests: XCTestCase {

    func testBOMTakeoffAggregation() {
        var project = SteelProject(projectName: "Factory Shed Frame")
        project.items.append(ProjectBOMItem(
            sectionId: "beam-ismb-300",
            designation: "ISMB 300",
            family: .beams,
            massPerMetre: 44.2,
            quantity: 10,
            lengthMeters: 6.0,
            unitRatePerKg: 75.0
        ))
        project.items.append(ProjectBOMItem(
            sectionId: "channel-ismc-150",
            designation: "ISMC 150",
            family: .channels,
            massPerMetre: 16.4,
            quantity: 20,
            lengthMeters: 5.0,
            unitRatePerKg: 75.0
        ))

        let summary = SteelEstimationEngine.summarizeProject(project)

        // ISMB 300: 10 * 6 * 44.2 = 2652.0 kg
        // ISMC 150: 20 * 5 * 16.4 = 1640.0 kg
        // Total = 4292.0 kg = 4.292 tonnes
        XCTAssertEqual(summary.totalItemsCount, 30)
        XCTAssertEqual(summary.totalLengthMeters, 160.0, accuracy: 0.01)
        XCTAssertEqual(summary.totalMassKg, 4292.0, accuracy: 0.01)
        XCTAssertEqual(summary.totalMassTonnes, 4.292, accuracy: 0.001)
        XCTAssertEqual(summary.totalEstimatedCost, 4292.0 * 75.0, accuracy: 0.01)
    }
}
