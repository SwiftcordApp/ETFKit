//
//  PackingData+.swift
//  
//
//  Created by Vincent Kwok on 9/6/22.
//

import Foundation

internal extension Data {
    mutating func insertHeader() {
        insert(ETFKit.VERSION, at: 0)
    }
}

internal extension Data {
    // SMALL_INTEGER_EXT
    mutating func appendValue(_ val: UInt8) {
        append(ETFKit.Tag.SMALL_INT.rawValue) // Tag
        append(val) // Val
    }
    // INTEGER_EXT
    mutating func appendValue(_ val: Int32) {
        append(ETFKit.Tag.INTEGER.rawValue) // Tag
        append(val.bigEndian.data) // 32-bit val
    }
    // NEW_FLOAT_EXT
    mutating func appendValue(_ val: Double) {
        append(ETFKit.Tag.NEW_FLOAT.rawValue) // Tag
        append(val.bitPattern.bigEndian.data) // 64-bit IEEE big-endian float
    }
    // BINARY_EXT
    mutating func appendValue(_ val: String) {
        append(ETFKit.Tag.BINARY.rawValue) // Tag
        append(UInt32(val.count).bigEndian.data) // Length
        append(contentsOf: val.utf8) // Data
    }
}

internal extension Data {
    enum AtomName: String {
        case NIL = "nil"
        case FALSE = "false"
        case TRUE = "true"
    }

    // SMALL_AROM_EXT
    mutating func appendSmallAtom(_ data: Any?) {
        if let data = data as? Bool {
            appendSmallAtom(data ? .TRUE : .FALSE)
        } else if data == nil { appendSmallAtom(.NIL) }
    }
    mutating func appendSmallAtom(_ name: AtomName) {
        append(ETFKit.Tag.SMALL_AROM.rawValue) // Tag
        append(UInt8(name.rawValue.count)) // Len (8-bit)
        append(contentsOf: name.rawValue.utf8) // Atom name
    }

    mutating func appendAny(_ data: Any) throws {
        if let data = data as? Int {
            if data >= 0, data <= UInt8.max {
                appendValue(UInt8(data))
            } else { appendValue(Int32(data)) }
        } else if let data = data as? Double {
            appendValue(data)
        } else if let data = data as? String {
            appendValue(data)
        } else if let data = data as? Bool? {
            appendSmallAtom(data)
        } else if let data = data as? [Any] {
            try appendList(data)
        } else if let data = data as? [String : Any] {
            try appendDict(data)
        } else {
            throw ETFKit.ETFEncodingError.UnencodableType("Unsupported data type for packing")
        }
    }
}

internal extension Data {
    // LIST_EXT
    mutating func appendList(_ arr: [Any]) throws {
        if arr.isEmpty {
            append(ETFKit.Tag.EMPTY_LIST.rawValue)
            return
        }
        append(ETFKit.Tag.LIST.rawValue) // Tag
        append(UInt32(arr.count).bigEndian.data) // Length (32-bit)
        for elem in arr { try appendAny(elem) } // Elems
        append(ETFKit.Tag.EMPTY_LIST.rawValue)
    }

    // MAP_EXT
    mutating func appendDict(_ dict: [String : Any]) throws {
        append(ETFKit.Tag.MAP.rawValue) // Tag
        append(UInt32(dict.count).bigEndian.data) // Length (32-bit)
        for (key, elem) in dict {
            appendValue(key)
            try appendAny(elem)
        }
    }
}
