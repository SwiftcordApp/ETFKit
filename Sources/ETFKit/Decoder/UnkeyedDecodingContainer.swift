//
//  UnkeyedDecodingContainer.swift
//  
//
//  Created by Vincent Kwok on 10/6/22.
//

import Foundation

internal struct _ETFUnkeyedDecodingContainer : UnkeyedDecodingContainer {
    internal let decoded: [Any?]
    private let decoder: _ETFDecoder

    private(set) public var codingPath: [CodingKey]

    /// The number of elements contained within this container.
    ///
    /// If the number of elements is unknown, the value is `nil`.
    var count: Int? {
        decoded.count
    }

    /// A Boolean value indicating whether there are no more elements left to be
    /// decoded in the container.
    var isAtEnd: Bool {
        currentIndex == decoded.count - 1
    }

    /// The current decoding index of the container (i.e. the index of the next
    /// element to be decoded.) Incremented after every successful decode call.
    private(set) public var currentIndex = 0

    init(with decoded: [Any?], referencing decoder: _ETFDecoder) {
        self.decoder = decoder
        self.decoded = decoded
        codingPath = decoder.codingPath
    }

    private func ensureNotAtEnd<T>(_ type: T.Type) throws {
        guard !isAtEnd else {
            throw DecodingError.valueNotFound(
                type,
                .init(codingPath: decoder.codingPath, debugDescription: "No more values to decode")
            )
        }
    }

    /// Decodes a null value.
    ///
    /// If the value is not null, does not increment currentIndex.
    ///
    /// - returns: Whether the encountered value was null.
    /// - throws: `DecodingError.valueNotFound` if there are no more values to
    ///   decode.
    mutating func decodeNil() throws -> Bool {
        try ensureNotAtEnd(Any?.self)
        if decoded[currentIndex] == nil {
            currentIndex += 1
            return true
        } else { return false }
    }

    mutating func decode(_ type: Float.Type) throws -> Float {
        Float(try decode(Double.self))
    }

    mutating func decode(_ type: Int8.Type) throws -> Int8 {
        Int8(try decode(Int.self))
    }

    mutating func decode(_ type: Int16.Type) throws -> Int16 {
        Int16(try decode(Int.self))
    }

    mutating func decode(_ type: Int32.Type) throws -> Int32 {
        Int32(try decode(Int.self))
    }

    mutating func decode(_ type: Int64.Type) throws -> Int64 {
        decoder.codingPath.append(_ETFKey(index: currentIndex))
        defer { decoder.codingPath.removeLast() }

        throw DecodingError.typeMismatch(
            type,
            .init(codingPath: decoder.codingPath, debugDescription: "Int64 decode is not supported")
        )
    }

    mutating func decode(_ type: UInt.Type) throws -> UInt {
        UInt(try decode(Int.self))
    }

    mutating func decode(_ type: UInt8.Type) throws -> UInt8 {
        UInt8(try decode(Int.self))
    }

    mutating func decode(_ type: UInt16.Type) throws -> UInt16 {
        UInt16(try decode(Int.self))
    }

    mutating func decode(_ type: UInt32.Type) throws -> UInt32 {
        UInt32(try decode(Int.self))
    }

    mutating func decode(_ type: UInt64.Type) throws -> UInt64 {
        decoder.codingPath.append(_ETFKey(index: currentIndex))
        defer { decoder.codingPath.removeLast() }

        throw DecodingError.typeMismatch(
            type,
            .init(codingPath: decoder.codingPath, debugDescription: "UInt64 decode is not supported")
        )
    }

    /// Decodes a value of the given type.
    ///
    /// - parameter type: The type of value to decode.
    /// - returns: A value of the requested type, if present for the given key
    ///   and convertible to the requested type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to the requested type.
    /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
    ///   is null, or of there are no more values to decode.
    mutating func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        guard !(try decodeNil()) else {
            throw DecodingError.valueNotFound(
                type,
                .init(codingPath: codingPath, debugDescription: "")
            )
        }
        
        decoder.codingPath.append(_ETFKey(index: currentIndex))
        defer { decoder.codingPath.removeLast() }
        
        guard let val = decoded[currentIndex] as? T else {
            throw DecodingError.typeMismatch(
                type,
                .init(codingPath: decoder.codingPath, debugDescription: "")
            )
        }
        return val
    }

    /// Decodes a value of the given type, if present.
    ///
    /// This method returns `nil` if the container has no elements left to
    /// decode, or if the value is null. The difference between these states can
    /// be distinguished by checking `isAtEnd`.
    ///
    /// - parameter type: The type of value to decode.
    /// - returns: A decoded value of the requested type, or `nil` if the value
    ///   is a null value, or if there are no more elements to decode.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to the requested type.
    mutating func decodeIfPresent(_ type: Float.Type) throws -> Float? {
        if let val = try decodeIfPresent(Double.self) {
            return Float(val)
        }
        return nil
    }

    mutating func decodeIfPresent(_ type: Int8.Type) throws -> Int8? {
        if let val = try decodeIfPresent(Int.self) {
            return Int8(val)
        }
        return nil
    }

    mutating func decodeIfPresent(_ type: Int16.Type) throws -> Int16? {
        if let val = try decodeIfPresent(Int.self) {
            return Int16(val)
        }
        return nil
    }

    mutating func decodeIfPresent(_ type: Int32.Type) throws -> Int32? {
        if let val = try decodeIfPresent(Int.self) {
            return Int32(val)
        }
        return nil
    }

    mutating func decodeIfPresent(_ type: Int64.Type) throws -> Int64? {
        decoder.codingPath.append(_ETFKey(index: currentIndex))
        defer { decoder.codingPath.removeLast() }

        throw DecodingError.typeMismatch(
            type,
            .init(codingPath: decoder.codingPath, debugDescription: "Int64 decode is not supported")
        )
    }

    mutating func decodeIfPresent(_ type: UInt.Type) throws -> UInt? {
        if let val = try decodeIfPresent(Int.self) {
            return UInt(val)
        }
        return nil
    }

    mutating func decodeIfPresent(_ type: UInt8.Type) throws -> UInt8? {
        if let val = try decodeIfPresent(Int.self) {
            return UInt8(val)
        }
        return nil
    }

    mutating func decodeIfPresent(_ type: UInt16.Type) throws -> UInt16? {
        if let val = try decodeIfPresent(Int.self) {
            return UInt16(val)
        }
        return nil
    }

    mutating func decodeIfPresent(_ type: UInt32.Type) throws -> UInt32? {
        if let val = try decodeIfPresent(Int.self) {
            return UInt32(val)
        }
        return nil
    }

    mutating func decodeIfPresent(_ type: UInt64.Type) throws -> UInt64? {
        decoder.codingPath.append(_ETFKey(index: currentIndex))
        defer { decoder.codingPath.removeLast() }

        throw DecodingError.typeMismatch(
            type,
            .init(codingPath: decoder.codingPath, debugDescription: "UInt64 decode is not supported")
        )
    }

    /// Decodes a value of the given type, if present.
    ///
    /// This method returns `nil` if the container has no elements left to
    /// decode, or if the value is null. The difference between these states can
    /// be distinguished by checking `isAtEnd`.
    ///
    /// - parameter type: The type of value to decode.
    /// - returns: A decoded value of the requested type, or `nil` if the value
    ///   is a null value, or if there are no more elements to decode.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to the requested type.
    mutating func decodeIfPresent<T>(_ type: T.Type) throws -> T? where T : Decodable {
        if currentIndex == decoded.count - 1 { return nil }

        if let val = decoded[currentIndex], let val = val as? T { return val }
        return nil
    }

    /// Decodes a nested container keyed by the given type.
    ///
    /// - parameter type: The key type to use for the container.
    /// - returns: A keyed decoding container view into `self`.
    /// - throws: `DecodingError.typeMismatch` if the encountered stored value is
    ///   not a keyed container.
    mutating func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        fatalError("TODO")
    }

    /// Decodes an unkeyed nested container.
    ///
    /// - returns: An unkeyed decoding container view into `self`.
    /// - throws: `DecodingError.typeMismatch` if the encountered stored value is
    ///   not an unkeyed container.
    mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
        fatalError("TODO")
    }

    /// Decodes a nested container and returns a `Decoder` instance for decoding
    /// `super` from that container.
    ///
    /// - returns: A new `Decoder` to pass to `super.init(from:)`.
    /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
    ///   is null, or of there are no more values to decode.
    mutating func superDecoder() throws -> Decoder {
        fatalError("TODO")
    }
}
