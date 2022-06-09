//
//  Numeric+.swift
//  
//
//  Created by Vincent Kwok on 9/6/22.
//

import Foundation

internal extension Numeric {
    var data: Data {
        var source = self
        return Data(bytes: &source, count: MemoryLayout<Self>.size)
    }
}
