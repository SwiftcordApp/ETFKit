//
//  Encode.swift
//  
//
//  Created by Vincent Kwok on 9/6/22.
//

import Foundation

extension ETFKit {
    internal static func encode(_ data: Any) throws -> Data {
        var d = Data()
        d.insertHeader()
        try d.appendAny(data)
        return d
    }
}
