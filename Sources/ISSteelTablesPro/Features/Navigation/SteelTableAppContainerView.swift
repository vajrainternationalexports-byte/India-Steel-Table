import SwiftUI

/// Screen navigation state matching exact IS Steel Table v1.4.3 flow.
public enum AppScreenState: Hashable {
    case categories
    case detail(family: SectionFamily, sectionId: String)
    case sizePicker(family: SectionFamily, currentSectionId: String)
    case calculator(family: SectionFamily, sectionId: String)
}

/// Central App Container View for iOS SwiftUI app (replacing TabBar).
public struct SteelTableAppContainerView: View {
    @EnvironmentObject private var environment: AppEnvironment

    @State private var screenStack: [AppScreenState] = []
    @State private var currentCategory: SectionFamily = .equalAngles
    @State private var currentSectionId: String = ""

    public init() {}

    public var body: some View {
        NavigationStack(path: $screenStack) {
            HomeCategoryListView(onSelectCategory: { family in
                currentCategory = family
                if let firstSec = environment.allSections.first(where: { $0.family == family }) {
                    currentSectionId = firstSec.id
                    screenStack.append(.detail(family: family, sectionId: firstSec.id))
                } else {
                    Task {
                        await environment.bootstrap()
                        if let firstSec = environment.allSections.first(where: { $0.family == family }) {
                            currentSectionId = firstSec.id
                            screenStack.append(.detail(family: family, sectionId: firstSec.id))
                        }
                    }
                }
            })
            .navigationDestination(for: AppScreenState.self) { screen in
                switch screen {
                case .categories:
                    HomeCategoryListView(onSelectCategory: { family in
                        currentCategory = family
                        if let firstSec = environment.allSections.first(where: { $0.family == family }) {
                            currentSectionId = firstSec.id
                            screenStack.append(.detail(family: family, sectionId: firstSec.id))
                        }
                    })

                case .detail(let family, let sectionId):
                    if let section = environment.allSections.first(where: { $0.id == sectionId }) ?? environment.allSections.first(where: { $0.family == family }) {
                        ReplicaSectionDetailView(
                            section: section,
                            onOpenSizePicker: {
                                screenStack.append(.sizePicker(family: family, currentSectionId: section.id))
                            },
                            onOpenCalculator: {
                                screenStack.append(.calculator(family: family, sectionId: section.id))
                            }
                        )
                    }

                case .sizePicker(let family, let sectionId):
                    SizePickerGridView(
                        family: family,
                        currentSectionId: sectionId,
                        onSelectSection: { selectedSection in
                            currentSectionId = selectedSection.id
                            if !screenStack.isEmpty {
                                screenStack.removeLast()
                            }
                            screenStack.append(.detail(family: family, sectionId: selectedSection.id))
                        }
                    )

                case .calculator(let family, let sectionId):
                    if let section = environment.allSections.first(where: { $0.id == sectionId }) {
                        ReplicaCalculatorView(section: section)
                    }
                }
            }
        }
        .task {
            if environment.allSections.isEmpty {
                await environment.bootstrap()
            }
        }
        .accentColor(.white)
    }
}
