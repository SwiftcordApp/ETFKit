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
    internal(set) public var codingPath: [CodingKey]

    /// Contextual user-provided information for use during encoding.
    public var userInfo: [CodingUserInfoKey : Any] = [:]

    internal let decoded: Any?

    func container<Key>(keyedBy: Key.Type) throws -> KeyedDecodingContainer<Key> {
        guard let decoded = decoded as? [String : Any?] else {
            throw DecodingError.typeMismatch(
                [String : Any?].self,
                .init(codingPath: codingPath, debugDescription: "Top level data type is not a map")
            )
        }
        return KeyedDecodingContainer(_ETFKeyedDecodingContainer(with: decoded, referencing: self))
    }

    func singleValueContainer() throws -> SingleValueDecodingContainer {
        self
    }

    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        guard let decoded = decoded as? [Any?] else {
            throw DecodingError.typeMismatch(
                [Any?].self,
                .init(codingPath: codingPath, debugDescription: "Top level data type is not a list")
            )
        }
        return _ETFUnkeyedDecodingContainer(with: decoded, referencing: self)
    }

    init(with decoded: Any?, at codingPath: [CodingKey] = []) {
        self.decoded = decoded
        self.codingPath = codingPath
    }
}
