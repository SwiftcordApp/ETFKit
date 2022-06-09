//
//  Parse.swift
//  
//
//  Created by Vincent Kwok on 9/6/22.
//

import Foundation

// Primitive decoding functions
extension ETFKit {
    // SMALL_INTEGER_EXT
    internal static func decodingValue(data: Data, from idx: inout Int) throws -> UInt8 {
        guard data[idx] == ETFTags.SMALL_INT.rawValue else {
            throw ETFDecodingError.MismatchingTag("Expected tag \(ETFTags.SMALL_INT), got \(data[idx])")
        }
        idx += 2
        return data[idx - 1]
    }
    // INTEGER_EXT
    internal static func decodingValue(data: Data, from idx: inout Int) throws -> Int32 {
        guard data[idx] == ETFTags.INTEGER.rawValue else {
            throw ETFDecodingError.MismatchingTag("Expected tag \(ETFTags.INTEGER), got \(data[idx])")
        }
        idx += 5
        return data.subdata(in: idx-4..<idx).toInt32()
    }
    // SMALL_BIG_EXT (Unused)
    internal static func decodingValue(data: Data, from idx: inout Int) throws -> Decimal {
        guard data[idx] == ETFTags.SMALL_BIG.rawValue else {
            throw ETFDecodingError.MismatchingTag("Expected tag \(ETFTags.SMALL_BIG), got \(data[idx])")
        }
        idx += 3
        let num = Int(data[idx - 2])
        let sign = data[idx - 1]
        var sum: Decimal = 0
        for n in 0..<num {
            sum += Decimal(data[idx])*pow(256,n)
            idx += 1
        }
        if sign == 1 { sum *= -1 }
        return sum
    }
    // NEW_FLOAT_EXT
    internal static func decodingValue(data: Data, from idx: inout Int) throws -> Double {
        guard data[idx] == ETFTags.NEW_FLOAT.rawValue else {
            throw ETFDecodingError.MismatchingTag("Expected tag \(ETFTags.NEW_FLOAT), got \(data[idx])")
        }
        idx += 9
        return data.subdata(in: idx-8..<idx).toDouble()
    }
    // BINARY_EXT
    internal static func decodingValue(data: Data, from idx: inout Int) throws -> String {
        guard data[idx] == ETFTags.BINARY.rawValue else {
            throw ETFDecodingError.MismatchingTag("Expected tag \(ETFTags.BINARY), got \(data[idx])")
        }
        idx += 1
        let dataStart = idx + 4
        let to = dataStart + Int(data.subdata(in: idx..<dataStart).toInt32())
        idx = to
        // Binaries are always strings, might as well decode them in this function itself
        return String(decoding: data.subdata(in: dataStart..<Data.Index(to)), as: UTF8.self)
    }
}

extension ETFKit {
    internal static func decodingSmallAtom(data: Data, from idx: inout Int) throws -> Any? {
        guard data[idx] == ETFTags.SMALL_AROM.rawValue else {
            throw ETFDecodingError.MismatchingTag("Expected tag \(ETFTags.SMALL_AROM), got \(data[idx])")
        }
        idx += 2
        let from = idx
        let to = from + Int(data[idx-1])
        idx = to

        let atomName = String(decoding: data.subdata(in: from..<to), as: UTF8.self)
        switch atomName {
        case "nil": return nil
        case "false": return false
        case "true": return true
        default: throw ETFDecodingError.UnknownAtom("Unknown atom name '\(atomName)'")
        }
    }

    internal static func decodingAny(data: Data, from idx: inout Int) throws -> Any {
        switch ETFTags(rawValue: data[idx]) {
        case .NEW_FLOAT: return try decodingValue(data: data, from: &idx) as Double
        case .SMALL_INT: return try decodingValue(data: data, from: &idx) as UInt8
        case .INTEGER: return try decodingValue(data: data, from: &idx) as Int32
        case .MAP: return try decodingMap(data: data, from: &idx)
        case .EMPTY_LIST: fallthrough
        case .LIST: return try decodingArray(data: data, from: &idx)
        case .BINARY: return try decodingValue(data: data, from: &idx) as String
        case .SMALL_AROM: return try decodingSmallAtom(data: data, from: &idx) as Any
        default: throw ETFDecodingError.UnhandledTag("Tag \(data[idx]) is not handled")
        }
    }
    
    internal static func decodingArray(data: Data, from idx: inout Int) throws -> [Any] {
        if data[idx] == ETFTags.EMPTY_LIST.rawValue {
            idx += 1
            return []
        }

        guard data[idx] == ETFTags.LIST.rawValue else {
            throw ETFDecodingError.MismatchingTag("Expected tag \(ETFTags.LIST), got \(data[idx])")
        }

        idx += 1
        var len = Int(data.subdata(in: idx..<idx+4).toInt32())
        var arr: [Any] = []
        idx += 4

        while len > 0 {
            arr.append(try decodingAny(data: data, from: &idx))
            len -= 1
        }
        return arr
    }

    internal static func decodingMap(data: Data, from idx: inout Int) throws -> [String : Any] {
        guard data[idx] == ETFTags.MAP.rawValue else {
            throw ETFDecodingError.MismatchingTag("Expected tag \(ETFTags.MAP), got \(data[idx])")
        }

        idx += 4
        var pairs = data[idx]
        var dict: [String : Any] = [:]
        idx += 1

        while pairs > 0 {
            let key: String = try decodingValue(data: data, from: &idx)
            dict.updateValue(try decodingAny(data: data, from: &idx), forKey: key)
            pairs -= 1
        }

        return dict
    }
}
