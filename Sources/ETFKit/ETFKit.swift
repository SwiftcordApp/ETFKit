import Foundation

public struct ETFKit {
    static let VERSION: UInt8 = 131

    enum ETFTags: UInt8 {
        case NEW_FLOAT = 70
        case SMALL_INT = 97
        case INTEGER = 98
        case FLOAT = 99
        case EMPTY_LIST = 106 // NIL_EXT (Empty list in erlang)
        case LIST = 108
        case BINARY = 109
        case SMALL_BIG = 110
        case SMALL_AROM = 115
        case MAP = 116
    }

    enum ETFDecodingError: Error {
        case MismatchingVersion(String)
        case MismatchingTag(String)
        case UnhandledTag(String)
        case UnknownAtom(String)
    }

    internal static func parseDict(data: Data) throws -> [String : Any] {
        // Decode header
        guard data[0] == ETFKit.VERSION else {
            throw ETFDecodingError.MismatchingTag("Expected version \(ETFKit.VERSION), got \(data[0])")
        }

        var idx = 1
        return try decodingMap(data: data, from: &idx)
    }

    internal static func packDict(dict: [String : Any]) {
        
    }
}
