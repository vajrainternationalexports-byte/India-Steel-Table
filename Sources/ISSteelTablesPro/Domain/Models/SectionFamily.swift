import Foundation

/// Granular 14 Indian Standard structural steel families according to Bureau of Indian Standards (BIS) specifications.
public enum SectionFamily: String, Codable, CaseIterable, Identifiable, Sendable {
    case equalAngles = "Equal Angles"
    case unequalAngles = "Unequal Angles"
    case regularBeams = "Regular Beams"
    case heavyBeams = "Heavy Weight Beams"
    case slopingChannels = "Sloping Flange Channels"
    case parallelChannels = "Parallel Flange Channels"
    case pipes = "Pipes"
    case rectangularTubes = "Rectangular Tubes"
    case squareTubes = "Square Tubes"
    case squareBars = "Square Bars"
    case roundBars = "Round Bars"
    case flats = "Flats"
    case hrPlates = "HR Plates"
    case tees = "Tee Sections"

    public var id: String { rawValue }

    /// Standard BIS code reference
    public var standardReference: String {
        switch self {
        case .equalAngles, .unequalAngles:
            return "IS 808:1989 / IS 800"
        case .regularBeams:
            return "IS 808:1989 (ISMB, ISJB, ISLB, ISWB)"
        case .heavyBeams:
            return "IS 808:1989 / IS 12778 (ISHB, NPB)"
        case .slopingChannels:
            return "IS 808:1989 (ISMC, ISJC, ISLC)"
        case .parallelChannels:
            return "IS 808:1989 / IS 12778 (ISPC, NPFC)"
        case .pipes:
            return "IS 1161:2014 / IS 1239"
        case .rectangularTubes, .squareTubes:
            return "IS 4923:1997"
        case .squareBars, .roundBars:
            return "IS 1732:1989"
        case .flats:
            return "IS 1731:1971"
        case .hrPlates:
            return "IS 2062:2011"
        case .tees:
            return "IS 808:1989 (ISNT, ISHT, ISST)"
        }
    }

    /// Symbol prefix / short designation code
    public var symbolCode: String {
        switch self {
        case .equalAngles: return "ISA (Eq)"
        case .unequalAngles: return "ISA (Uneq)"
        case .regularBeams: return "ISMB/LB"
        case .heavyBeams: return "ISHB/NPB"
        case .slopingChannels: return "ISMC/LC"
        case .parallelChannels: return "ISPC/PFC"
        case .pipes: return "PIPE (NB)"
        case .rectangularTubes: return "RHS"
        case .squareTubes: return "SHS"
        case .squareBars: return "SQ BAR"
        case .roundBars: return "RD BAR"
        case .flats: return "FLAT"
        case .hrPlates: return "PLATE"
        case .tees: return "TEE"
        }
    }

    /// SF Symbol icon name for native iOS rendering
    public var sfSymbolName: String {
        switch self {
        case .equalAngles, .unequalAngles:
            return "angle"
        case .regularBeams:
            return "square.split.1x2"
        case .heavyBeams:
            return "rectangle.split.3x1"
        case .slopingChannels, .parallelChannels:
            return "bracket.square"
        case .pipes:
            return "circle.circle"
        case .rectangularTubes:
            return "rectangle"
        case .squareTubes:
            return "square"
        case .squareBars:
            return "square.fill"
        case .roundBars:
            return "circle.fill"
        case .flats:
            return "rectangle.fill"
        case .hrPlates:
            return "square.stack.3d.up.fill"
        case .tees:
            return "t.square"
        }
    }

    /// Short human-readable title for tabs and compact headers
    public var shortTitle: String {
        switch self {
        case .equalAngles: return "Equal Angles"
        case .unequalAngles: return "Unequal Angles"
        case .regularBeams: return "Regular Beams"
        case .heavyBeams: return "Heavy Beams"
        case .slopingChannels: return "Sloping Channels"
        case .parallelChannels: return "Parallel Channels"
        case .pipes: return "Pipes"
        case .rectangularTubes: return "RHS Tubes"
        case .squareTubes: return "SHS Tubes"
        case .squareBars: return "Square Bars"
        case .roundBars: return "Round Bars"
        case .flats: return "Flats"
        case .hrPlates: return "HR Plates"
        case .tees: return "Tees"
        }
    }
}
