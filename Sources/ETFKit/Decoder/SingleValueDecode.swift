//
//  SingleValueDecode.swift
//  
//
//  Created by Vincent Kwok on 10/6/22.
//

import Foundation

extension _ETFDecoder: SingleValueDecodingContainer {
    func decodeNil() -> Bool {
        decoded == nil
    }

    func decode(_ type: Bool.Type) throws -> Bool {
        guard let val = decoded as? Bool else {
            throw DecodingError.typeMismatch(Bool.self, .init(codingPath: codingPath, debugDescription: ""))
        }
        return val
    }

    func decode(_ type: String.Type) throws -> String {
        guard let val = decoded as? String else {
            throw DecodingError.typeMismatch(String.self, .init(codingPath: codingPath, debugDescription: ""))
        }
        return val
    }

    func decode(_ type: Double.Type) throws -> Double {
        guard let val = decoded as? Double else {
            throw DecodingError.typeMismatch(Double.self, .init(codingPath: codingPath, debugDescription: ""))
        }
        return val
    }

    func decode(_ type: Float.Type) throws -> Float {
        Float(try decode(Double.self))
    }
    
    func decode(_ type: Int.Type) throws -> Int {
        guard let val = decoded as? Int else {
            throw DecodingError.typeMismatch(Int.self, .init(codingPath: codingPath, debugDescription: ""))
        }
        return val
    }

    func decode(_ type: Int8.Type) throws -> Int8 {
        Int8(try decode(Int.self))
    }

    func decode(_ type: Int16.Type) throws -> Int16 {
        Int16(try decode(Int.self))
    }

    func decode(_ type: Int32.Type) throws -> Int32 {
        Int32(try decode(Int.self))
    }

    func decode(_ type: Int64.Type) throws -> Int64 {
        throw DecodingError.typeMismatch(
            Int64.self,
            .init(codingPath: codingPath, debugDescription: "Int64 decoding is currently unsupported")
        )
    }

    func decode(_ type: UInt.Type) throws -> UInt {
        UInt(try decode(Int.self))
    }

    func decode(_ type: UInt8.Type) throws -> UInt8 {
        UInt8(try decode(Int.self))
    }

    func decode(_ type: UInt16.Type) throws -> UInt16 {
        UInt16(try decode(Int.self))
    }

    func decode(_ type: UInt32.Type) throws -> UInt32 {
        UInt32(try decode(Int.self))
    }

    func decode(_ type: UInt64.Type) throws -> UInt64 {
        throw DecodingError.typeMismatch(
            UInt64.self,
            .init(codingPath: codingPath, debugDescription: "UInt64 decoding is currently unsupported")
        )
    }

    func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        guard let val = decoded as? T else {
            throw DecodingError.typeMismatch(Int.self, .init(codingPath: codingPath, debugDescription: ""))
        }
        return val
    }
}
