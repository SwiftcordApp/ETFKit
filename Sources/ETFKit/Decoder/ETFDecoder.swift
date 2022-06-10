//
//  ETFDecoder.swift
//  
//
//  Created by Vincent Kwok on 8/6/22.
//

import Foundation

open class ETFDecoder {
    open func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        let decoded: Any?
        do { decoded = try ETFKit.decode(data) } catch {
            throw DecodingError.dataCorrupted(.init(
                codingPath: [],
                debugDescription: "Could not decode provided data. It might not be valid ETF."
            ))
        }

        return try type.init(from: _ETFDecoder(with: decoded))
    }
}

internal class _ETFDecoder: Decoder {
    internal(set) public var codingPath: [CodingKey] = []

    /// Contextual user-provided information for use during encoding.
    public var userInfo: [CodingUserInfoKey : Any] = [:]
    
    internal let decoded: Any?

    func container<Key>(keyedBy: Key.Type) throws -> KeyedDecodingContainer<Key> {
        guard let decoded = decoded as? [String : Any?] else {
            throw DecodingError.typeMismatch(
                [String : Any].self,
                .init(codingPath: codingPath, debugDescription: "ETF data top level is not a map")
            )
        }
        return KeyedDecodingContainer(_ETFKeyedDecodingContainer(with: decoded))
    }

    func singleValueContainer() throws -> SingleValueDecodingContainer {
        return self
    }

    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        fatalError()
    }

    init(with decoded: Any?) {
        self.decoded = decoded
    }
}
