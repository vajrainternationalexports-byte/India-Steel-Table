import Foundation

/// Actor responsible for loading and decoding the immutable bundled IS steel sections dataset.
public actor LocalDatasetLoader {
    public static let shared = LocalDatasetLoader()

    private var cachedSections: [SteelSection]?
    private var cachedManifest: DatasetManifest?

    public init() {}

    /// Loads all sections from the bundled JSON dataset with error recovery.
    public func loadSections() throws -> [SteelSection] {
        if let cached = cachedSections {
            return cached
        }

        // Locate bundled dataset
        let bundle = Bundle.module
        guard let url = bundle.url(forResource: "is_steel_sections_master", withExtension: "json", subdirectory: "Data/BundledData")
                ?? bundle.url(forResource: "is_steel_sections_master", withExtension: "json")
                ?? Bundle.main.url(forResource: "is_steel_sections_master", withExtension: "json") else {
            // Fallback for standalone / test environment: direct file resolution
            if let fallbackUrl = findFallbackDatasetUrl() {
                return try loadFromUrl(fallbackUrl)
            }
            throw DatasetError.datasetNotFound
        }

        return try loadFromUrl(url)
    }

    /// Loads manifest metadata.
    public func loadManifest() throws -> DatasetManifest? {
        if let cached = cachedManifest {
            return cached
        }

        let bundle = Bundle.module
        guard let url = bundle.url(forResource: "dataset_manifest", withExtension: "json", subdirectory: "Data/BundledData")
                ?? bundle.url(forResource: "dataset_manifest", withExtension: "json")
                ?? Bundle.main.url(forResource: "dataset_manifest", withExtension: "json")
                ?? findFallbackManifestUrl() else {
            return nil
        }

        let data = try Data(contentsOf: url)
        let manifest = try JSONDecoder().decode(DatasetManifest.self, from: data)
        self.cachedManifest = manifest
        return manifest
    }

    private func loadFromUrl(_ url: URL) throws -> [SteelSection] {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let sections = try decoder.decode([SteelSection].self, from: data)
        self.cachedSections = sections
        return sections
    }

    private func findFallbackDatasetUrl() -> URL? {
        let possiblePaths = [
            "Sources/ISSteelTablesPro/Data/BundledData/is_steel_sections_master.json",
            "../Sources/ISSteelTablesPro/Data/BundledData/is_steel_sections_master.json",
            "../../Sources/ISSteelTablesPro/Data/BundledData/is_steel_sections_master.json"
        ]
        for path in possiblePaths {
            let fullPath = URL(fileURLWithPath: FileManager.default.currentDirectoryPath).appendingPathComponent(path)
            if FileManager.default.fileExists(atPath: fullPath.path) {
                return fullPath
            }
        }
        return nil
    }

    private func findFallbackManifestUrl() -> URL? {
        let possiblePaths = [
            "Sources/ISSteelTablesPro/Data/BundledData/dataset_manifest.json",
            "../Sources/ISSteelTablesPro/Data/BundledData/dataset_manifest.json"
        ]
        for path in possiblePaths {
            let fullPath = URL(fileURLWithPath: FileManager.default.currentDirectoryPath).appendingPathComponent(path)
            if FileManager.default.fileExists(atPath: fullPath.path) {
                return fullPath
            }
        }
        return nil
    }
}

public enum DatasetError: Error, LocalizedError {
    case datasetNotFound
    case corruptedData(String)
    case invalidChecksum

    public var errorDescription: String? {
        switch self {
        case .datasetNotFound:
            return "The IS Steel Sections master dataset could not be found in the application bundle."
        case .corruptedData(let msg):
            return "The steel dataset is corrupted or invalid: \(msg)"
        case .invalidChecksum:
            return "Dataset checksum verification failed."
        }
    }
}
