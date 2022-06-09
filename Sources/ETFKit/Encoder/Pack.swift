//
//  Pack.swift
//  
//
//  Created by Vincent Kwok on 9/6/22.
//

import Foundation

extension ETFKit {
    internal static func packMap() -> Data {
        var d = Data()
        d.insertHeader()
        d.appendValue("Hello world")
        return d
    }
}
