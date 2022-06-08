import Foundation

public struct ETFKit {
    static let VERSION = 131

    enum ETFTags: Int {
        case SMALL_INT = 97
        case INTEGER = 98
        case FLOAT = 99
        case LIST = 108
        case BINARY = 109
        case MAP = 116
    }
    
    enum ETFDecodingError: Error {
        case MismatchingVersion(String)
        case MismatchingTag(String)
        case UnhandledTag(String)
    }

    internal static func parseDict(data: Data) throws -> [String : Any] {
        // Decode header
        guard data[0] == ETFKit.VERSION else {
            throw ETFDecodingError.MismatchingTag("Expected version \(ETFKit.VERSION), got \(data[0])")
        }

        var idx = 1
        return try decodingMap(data: data, from: &idx)
    }
}

extension ETFKit {
    fileprivate static func decodingValue(data: Data, from idx: inout Int) throws -> UInt8 {
        guard data[idx] == ETFTags.SMALL_INT.rawValue else {
            throw ETFDecodingError.MismatchingTag("Expected tag \(ETFTags.SMALL_INT), got \(data[idx])")
        }
        idx += 2
        return data[idx - 1]
    }
    fileprivate static func decodingValue(data: Data, from idx: inout Int) throws -> Int32 {
        guard data[idx] == ETFTags.INTEGER.rawValue else {
            throw ETFDecodingError.MismatchingTag("Expected tag \(ETFTags.INTEGER), got \(data[idx])")
        }
        idx += 5
        return data.subdata(in: idx-4..<idx).toUInt32()
    }
    fileprivate static func decodingValue(data: Data, from idx: inout Int) throws -> Double {
        throw ETFDecodingError.MismatchingTag("")
    }
    fileprivate static func decodingValue(data: Data, from idx: inout Int) throws -> String {
        guard data[idx] == ETFTags.BINARY.rawValue else {
            throw ETFDecodingError.MismatchingTag("Expected tag \(ETFTags.BINARY), got \(data[idx])")
        }
        idx += 1
        let dataStart = idx + 4
        let to = dataStart + Int(data.subdata(in: idx..<dataStart).toUInt32())
        idx = to
        // Binaries are always strings, might as well decode them in this function itself
        return String(decoding: data.subdata(in: dataStart..<Data.Index(to)), as: UTF8.self)
    }

    fileprivate static func decodingArray(data: Data, from idx: inout Int) throws -> [Any] {
        guard data[idx] == ETFTags.LIST.rawValue else {
            throw ETFDecodingError.MismatchingTag("Expected tag \(ETFTags.LIST), got \(data[idx])")
        }
        
        idx += 1
        var len = Int(data.subdata(in: idx..<idx+4).toUInt32())
        var arr: [Any] = []
        idx += 4
        
        while len > 0 {
            switch ETFTags(rawValue: Int(data[idx])) {
            case .SMALL_INT:
                let val: UInt8 = try decodingValue(data: data, from: &idx)
                arr.append(val)
            case .INTEGER:
                let val: Int32 = try decodingValue(data: data, from: &idx)
                arr.append(val)
            case .MAP:
                arr.append(try decodingMap(data: data, from: &idx))
            case .LIST:
                arr.append(try decodingArray(data: data, from: &idx))
            case .BINARY:
                let val: String = try decodingValue(data: data, from: &idx)
                arr.append(val)
            default:
                throw ETFDecodingError.UnhandledTag("Tag \(data[idx]) is not handled")
            }
            len -= 1
        }
        return arr
    }

    fileprivate static func decodingMap(data: Data, from idx: inout Int) throws -> [String : Any] {
        guard data[idx] == ETFTags.MAP.rawValue else {
            throw ETFDecodingError.MismatchingTag("Expected tag \(ETFTags.MAP), got \(data[idx])")
        }

        idx += 4
        var pairs = data[idx]
        var dict: [String : Any] = [:]
        idx += 1
        
        while pairs > 0 {
            let key: String = try decodingValue(data: data, from: &idx)
            switch ETFTags(rawValue: Int(data[idx])) {
            case .SMALL_INT:
                let val: UInt8 = try decodingValue(data: data, from: &idx)
                dict.updateValue(val, forKey: key)
            case .INTEGER:
                let val: Int32 = try decodingValue(data: data, from: &idx)
                dict.updateValue(val, forKey: key)
            case .MAP:
                dict.updateValue(try decodingMap(data: data, from: &idx), forKey: key)
            case .LIST:
                dict.updateValue(try decodingArray(data: data, from: &idx), forKey: key)
            case .BINARY:
                // Binaries are always strings
                let val: String = try decodingValue(data: data, from: &idx)
                dict.updateValue(val, forKey: key)
            default:
                throw ETFDecodingError.UnhandledTag("Tag \(data[idx]) is not handled")
            }
            pairs -= 1
        }

        return dict
    }
}
