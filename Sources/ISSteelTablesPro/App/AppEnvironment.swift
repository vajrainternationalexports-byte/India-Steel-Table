import SwiftUI

/// App-wide dependency container and user preferences state.
@MainActor
public final class AppEnvironment: ObservableObject {
    public static let shared = AppEnvironment()

    // Repositories
    public let sectionRepository: SteelSectionRepository
    public let favoritesRepository: FavoritesRepository
    public let projectRepository: ProjectRepository

    // User Preferences
    @AppStorage("app_unit_system") public var unitSystem: String = EngineeringUnitSystem.metric.rawValue
    @AppStorage("app_decimal_precision") public var decimalPrecision: Int = 2
    @AppStorage("app_steel_density") public var steelDensity: Double = 7850.0
    @AppStorage("app_haptics_enabled") public var hapticsEnabled: Bool = true
    @AppStorage("app_appearance_mode") public var appearanceMode: String = "system"

    // Published App State
    @Published public var allSections: [SteelSection] = []
    @Published public var favoriteIds: Set<String> = []
    @Published public var recentIds: [String] = []
    @Published public var comparisonSections: [SteelSection] = []
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String? = nil

    public init(
        sectionRepository: SteelSectionRepository = BundledSteelSectionRepository(),
        favoritesRepository: FavoritesRepository = LocalFavoritesRepository(),
        projectRepository: ProjectRepository = LocalProjectRepository()
    ) {
        self.sectionRepository = sectionRepository
        self.favoritesRepository = favoritesRepository
        self.projectRepository = projectRepository
    }

    /// Preloads the bundled steel dataset on app launch asynchronously without blocking the main thread.
    public func bootstrap() async {
        isLoading = true
        errorMessage = nil
        do {
            let sections = try await sectionRepository.getAllSections()
            self.allSections = sections
            let favs = await favoritesRepository.getFavoriteSectionIds()
            self.favoriteIds = Set(favs)
            let recents = await favoritesRepository.getRecentlyViewedIds()
            self.recentIds = recents
            self.isLoading = false
        } catch {
            self.errorMessage = error.localizedDescription
            self.isLoading = false
        }
    }

    public func toggleFavorite(sectionId: String) async {
        await favoritesRepository.toggleFavorite(sectionId: sectionId)
        if favoriteIds.contains(sectionId) {
            favoriteIds.remove(sectionId)
        } else {
            favoriteIds.insert(sectionId)
        }
    }

    public func isFavorite(sectionId: String) -> Bool {
        favoriteIds.contains(sectionId)
    }

    public func recordRecentlyViewed(sectionId: String) async {
        await favoritesRepository.recordRecentlyViewed(sectionId: sectionId)
        recentIds.removeAll { $0 == sectionId }
        recentIds.insert(sectionId, at: 0)
    }

    public func addToComparison(_ section: SteelSection) {
        if !comparisonSections.contains(where: { $0.id == section.id }) {
            if comparisonSections.count < 5 {
                comparisonSections.append(section)
            }
        }
    }

    public func removeFromComparison(_ section: SteelSection) {
        comparisonSections.removeAll { $0.id == section.id }
    }

    public func clearComparison() {
        comparisonSections.removeAll()
    }
}
