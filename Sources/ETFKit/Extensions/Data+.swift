//
//  Data+.swift
//  
//
//  Created by Vincent Kwok on 8/6/22.
//

import Foundation

extension Data {
    internal func toUInt32() -> Int32 {
        Int32(bigEndian: self.withUnsafeBytes { $0.pointee })
    }
}
