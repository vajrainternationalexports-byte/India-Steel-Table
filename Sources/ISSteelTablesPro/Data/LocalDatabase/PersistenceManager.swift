import Foundation

/// Thread-safe local persistence manager for user state (Favorites, Recently Viewed, Projects).
public actor PersistenceManager {
    public static let shared = PersistenceManager()

    private let userDefaults: UserDefaults
    private let favoritesKey = "is_steel_favorites_ids"
    private let recentsKey = "is_steel_recents_ids"
    private let projectsKey = "is_steel_projects_data"

    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    // MARK: - Favorites

    public func getFavoriteIds() -> [String] {
        userDefaults.stringArray(forKey: favoritesKey) ?? []
    }

    public func isFavorite(id: String) -> Bool {
        getFavoriteIds().contains(id)
    }

    public func addFavorite(id: String) {
        var current = getFavoriteIds()
        if !current.contains(id) {
            current.append(id)
            userDefaults.set(current, forKey: favoritesKey)
        }
    }

    public func removeFavorite(id: String) {
        var current = getFavoriteIds()
        current.removeAll { $0 == id }
        userDefaults.set(current, forKey: favoritesKey)
    }

    public func toggleFavorite(id: String) {
        if isFavorite(id: id) {
            removeFavorite(id: id)
        } else {
            addFavorite(id: id)
        }
    }

    // MARK: - Recently Viewed

    public func getRecentlyViewedIds() -> [String] {
        userDefaults.stringArray(forKey: recentsKey) ?? []
    }

    public func recordRecentlyViewed(id: String) {
        var current = getRecentlyViewedIds()
        current.removeAll { $0 == id }
        current.insert(id, at: 0)
        // Keep at most 50 recent items
        if current.count > 50 {
            current = Array(current.prefix(50))
        }
        userDefaults.set(current, forKey: recentsKey)
    }

    public func clearRecentlyViewed() {
        userDefaults.removeObject(forKey: recentsKey)
    }

    // MARK: - Projects (BOM)

    public func getAllProjects() -> [SteelProject] {
        guard let data = userDefaults.data(forKey: projectsKey) else { return [] }
        do {
            return try JSONDecoder().decode([SteelProject].self, from: data)
        } catch {
            return []
        }
    }

    public func saveProject(_ project: SteelProject) {
        var projects = getAllProjects()
        if let idx = projects.firstIndex(where: { $0.id == project.id }) {
            projects[idx] = project
        } else {
            projects.insert(project, at: 0)
        }
        if let data = try? JSONEncoder().encode(projects) {
            userDefaults.set(data, forKey: projectsKey)
        }
    }

    public func deleteProject(id: UUID) {
        var projects = getAllProjects()
        projects.removeAll { $0.id == id }
        if let data = try? JSONEncoder().encode(projects) {
            userDefaults.set(data, forKey: projectsKey)
        }
    }
}
