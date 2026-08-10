import Foundation

/// Repository implementation backed by the bundled IS steel sections dataset.
public final class BundledSteelSectionRepository: SteelSectionRepository, @unchecked Sendable {
    private let loader: LocalDatasetLoader
    private var indexer: SectionSearchIndexer?
    private var allSectionsCache: [SteelSection] = []
    private let lock = NSLock()

    public init(loader: LocalDatasetLoader = .shared) {
        self.loader = loader
    }

    public func getAllSections() async throws -> [SteelSection] {
        lock.lock()
        if !allSectionsCache.isEmpty {
            let cached = allSectionsCache
            lock.unlock()
            return cached
        }
        lock.unlock()

        let sections = try await loader.loadSections()
        lock.lock()
        self.allSectionsCache = sections
        self.indexer = SectionSearchIndexer(sections: sections)
        lock.unlock()
        return sections
    }

    public func getSections(for family: SectionFamily) async throws -> [SteelSection] {
        let all = try await getAllSections()
        return all.filter { $0.family == family }
    }

    public func getSection(byId id: String) async throws -> SteelSection? {
        let all = try await getAllSections()
        return all.first { $0.id == id }
    }

    public func searchSections(query: String, family: SectionFamily?) async throws -> [SteelSection] {
        _ = try await getAllSections()
        lock.lock()
        defer { lock.unlock() }
        guard let idx = indexer else { return [] }
        return idx.search(query: query, family: family)
    }

    public func getDatasetManifest() async throws -> DatasetManifest? {
        try await loader.loadManifest()
    }
}

/// Repository implementation for Favorites and Recents.
public final class LocalFavoritesRepository: FavoritesRepository, Sendable {
    private let persistence: PersistenceManager

    public init(persistence: PersistenceManager = .shared) {
        self.persistence = persistence
    }

    public func getFavoriteSectionIds() async -> [String] {
        await persistence.getFavoriteIds()
    }

    public func isFavorite(sectionId: String) async -> Bool {
        await persistence.isFavorite(id: sectionId)
    }

    public func toggleFavorite(sectionId: String) async {
        await persistence.toggleFavorite(id: sectionId)
    }

    public func addFavorite(sectionId: String) async {
        await persistence.addFavorite(id: sectionId)
    }

    public func removeFavorite(sectionId: String) async {
        await persistence.removeFavorite(id: sectionId)
    }

    public func getRecentlyViewedIds() async -> [String] {
        await persistence.getRecentlyViewedIds()
    }

    public func recordRecentlyViewed(sectionId: String) async {
        await persistence.recordRecentlyViewed(id: sectionId)
    }

    public func clearRecentlyViewed() async {
        await persistence.clearRecentlyViewed()
    }
}

/// Repository implementation for user Steel Projects (BOM).
public final class LocalProjectRepository: ProjectRepository, Sendable {
    private let persistence: PersistenceManager

    public init(persistence: PersistenceManager = .shared) {
        self.persistence = persistence
    }

    public func getAllProjects() async -> [SteelProject] {
        await persistence.getAllProjects()
    }

    public func getProject(byId id: UUID) async -> SteelProject? {
        let all = await persistence.getAllProjects()
        return all.first { $0.id == id }
    }

    public func saveProject(_ project: SteelProject) async {
        await persistence.saveProject(project)
    }

    public func deleteProject(byId id: UUID) async {
        await persistence.deleteProject(id: id)
    }
}
