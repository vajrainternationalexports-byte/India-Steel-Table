import Foundation

/// Repository protocol for managing user favorite sections and recently viewed history.
public protocol FavoritesRepository: Sendable {
    func getFavoriteSectionIds() async -> [String]
    func isFavorite(sectionId: String) async -> Bool
    func toggleFavorite(sectionId: String) async
    func addFavorite(sectionId: String) async
    func removeFavorite(sectionId: String) async

    func getRecentlyViewedIds() async -> [String]
    func recordRecentlyViewed(sectionId: String) async
    func clearRecentlyViewed() async
}

/// Repository protocol for managing user steel estimation projects.
public protocol ProjectRepository: Sendable {
    func getAllProjects() async -> [SteelProject]
    func getProject(byId id: UUID) async -> SteelProject?
    func saveProject(_ project: SteelProject) async
    func deleteProject(byId id: UUID) async
}
