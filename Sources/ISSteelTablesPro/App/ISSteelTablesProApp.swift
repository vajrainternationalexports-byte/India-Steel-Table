import SwiftUI

/// Main iOS Application Entry Point for IS Steel Tables Pro.
@main
public struct ISSteelTablesProApp: App {
    @StateObject private var environment = AppEnvironment.shared

    public init() {}

    public var body: some Scene {
        WindowGroup {
            DualAppContainerView()
                .environmentObject(environment)
                .preferredColorScheme(.dark)
        }
    }
}
