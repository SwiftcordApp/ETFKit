//
//  ETFDecoder.swift
//  
//
//  Created by Vincent Kwok on 8/6/22.
//

import Foundation

open class ETFDecoder {
    open func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        return try type.init(from: _ETFDecoder())
    }
}

internal class _ETFDecoder: Decoder {
    internal(set) public var codingPath: [CodingKey]
    
    /// Contextual user-provided information for use during encoding.
    public var userInfo: [CodingUserInfoKey : Any] = [:]

    func container<Key>(keyedBy: Key.Type) throws -> KeyedDecodingContainer<Key> {
        fatalError()
    }

    func singleValueContainer() throws -> SingleValueDecodingContainer {
        fatalError()
    }

    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        fatalError()
    }

    init(at codingPath: [CodingKey] = []) {
        self.codingPath = codingPath
    }
}
