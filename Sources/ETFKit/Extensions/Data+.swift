//
//  Data+.swift
//  
//
//  Created by Vincent Kwok on 8/6/22.
//

import Foundation

internal extension Data {
    func toInt32() -> Int32 {
        Int32(bigEndian: self.withUnsafeBytes { $0.load(as: Int32.self) })
    }

    func toDouble() -> Double {
        self.withUnsafeBytes { Double(bitPattern: UInt64(bigEndian: $0.load(as: UInt64.self))) }
    }
}
