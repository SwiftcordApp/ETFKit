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
        append(ETFKit.ETFTags.SMALL_INT.rawValue) // Tag
        append(val) // Val
    }
    // INTEGER_EXT
    mutating func appendValue(_ val: Int32) {
        append(ETFKit.ETFTags.INTEGER.rawValue) // Tag
        append(val.bigEndian.data) // 32-bit val
    }
    // NEW_FLOAT_EXT
    mutating func appendValue(_ val: Double) {
        append(ETFKit.ETFTags.NEW_FLOAT.rawValue) // Tag
        append(val.bitPattern.bigEndian.data) // 64-bit IEEE big-endian float
    }
    // BINARY_EXT
    mutating func appendValue(_ val: String) {
        append(ETFKit.ETFTags.BINARY.rawValue) // Tag
        append(Int32(val.count).bigEndian.data) // Length
        append(contentsOf: val.utf8) // Data
    }
}

internal extension Data {

}
