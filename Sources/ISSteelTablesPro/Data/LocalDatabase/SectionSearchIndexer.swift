import Foundation

/// Fast in-memory search indexer for structural steel sections.
public struct SectionSearchIndexer: Sendable {
    private let sections: [SteelSection]

    public init(sections: [SteelSection]) {
        self.sections = sections
    }

    /// Searches sections with fuzzy query normalization, prefix matching, and category filtering.
    public func search(query: String, family: SectionFamily? = nil) -> [SteelSection] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            if let fam = family {
                return sections.filter { $0.family == fam }
            }
            return sections
        }

        let normalizedQuery = normalize(trimmed)
        let queryTokens = trimmed.lowercased().split(separator: " ").map(String.init)

        var filtered = sections
        if let fam = family {
            filtered = filtered.filter { $0.family == fam }
        }

        return filtered.filter { section in
            // Match normalized designation (e.g. "ISMB300" contains "300" or "ISMB")
            if section.normalizedDesignation.contains(normalizedQuery) {
                return true
            }

            // Match all query tokens across aliases and designation
            let fullText = "\(section.designation) \(section.series) \(section.family.rawValue) \(section.standard)".lowercased()
            if queryTokens.allSatisfy({ fullText.contains($0) }) {
                return true
            }

            // Match aliases
            for alias in section.aliases {
                if normalize(alias).contains(normalizedQuery) {
                    return true
                }
            }

            return false
        }
    }

    /// Normalizes a steel designation query string (e.g., "ISMB 300" -> "ISMB300", "50 x 50 x 6" -> "50X50X6")
    public func normalize(_ input: String) -> String {
        input
            .uppercased()
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: "X", with: "X")
            .replacingOccurrences(of: "Ø", with: "")
            .replacingOccurrences(of: "MM", with: "")
    }
}
