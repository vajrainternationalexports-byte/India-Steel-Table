import SwiftUI

/// Main iOS Tab Bar & iPad Navigation Split coordinator.
public struct MainTabView: View {
    @EnvironmentObject private var environment: AppEnvironment
    @State private var selectedTab: TabItem = .home

    public init() {}

    public enum TabItem: String, CaseIterable, Identifiable {
        case home = "Home"
        case table = "Tables"
        case calculators = "Calculators"
        case compare = "Compare"
        case favorites = "Favorites"
        case settings = "Settings"

        public var id: String { rawValue }

        public var iconName: String {
            switch self {
            case .home: return "square.grid.2x2.fill"
            case .table: return "tablecells"
            case .calculators: return "function"
            case .compare: return "arrow.left.and.right.square"
            case .favorites: return "star.fill"
            case .settings: return "gearshape.fill"
            }
        }
    }

    public var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: TabItem.home.iconName)
                }
                .tag(TabItem.home)

            SteelDataTableGridView()
                .tabItem {
                    Label("Table View", systemImage: TabItem.table.iconName)
                }
                .tag(TabItem.table)

            CalculatorsHubView()
                .tabItem {
                    Label("Calculators", systemImage: TabItem.calculators.iconName)
                }
                .tag(TabItem.calculators)

            CompareView()
                .tabItem {
                    Label("Compare", systemImage: TabItem.compare.iconName)
                }
                .badge(environment.comparisonSections.count)
                .tag(TabItem.compare)

            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: TabItem.favorites.iconName)
                }
                .tag(TabItem.favorites)

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: TabItem.settings.iconName)
                }
                .tag(TabItem.settings)
        }
        .task {
            await environment.bootstrap()
        }
    }
}
