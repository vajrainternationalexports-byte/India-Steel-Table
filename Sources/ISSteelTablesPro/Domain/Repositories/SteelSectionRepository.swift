import Foundation

/// Repository protocol for retrieving and searching steel sections.
public protocol SteelSectionRepository: Sendable {
    /// Loads all sections synchronously or asynchronously
    func getAllSections() async throws -> [SteelSection]

    /// Retrieves sections filtered by section family
    func getSections(for family: SectionFamily) async throws -> [SteelSection]

    /// Retrieves a specific section by its unique ID
    func getSection(byId id: String) async throws -> SteelSection?

    /// Searches sections across designations, aliases, standards, and series
    func searchSections(query: String, family: SectionFamily?) async throws -> [SteelSection]

    /// Returns dataset manifest metadata (version, total count, SHA-256 hash)
    func getDatasetManifest() async throws -> DatasetManifest?
}

public struct DatasetManifest: Codable, Sendable {
    public let datasetName: String
    public let datasetVersion: String
    public let schemaVersion: String
    public let totalSections: Int
    public let standardsCovered: [String]
    public let categories: [String]
    public let fileChecksumSha256: String
    public let steelDensityKgM3: Double
    public let builtAt: String
    public let validationStatus: String
}
