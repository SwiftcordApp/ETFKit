import XCTest
@testable import ETFKit

final class CodableDecodeTests: XCTestCase {
    struct Primitive: Codable, Equatable {
        let someString: String
        let funnyInt: Int
        let aFloat: Float
        let thisIs: Bool
        let wrong: Double
        let a: Int8
        let b: Int16
        let c: Int32
        let d: UInt
        let e: UInt8
        let f: UInt16
        let g: UInt32
    }
    struct PrimitiveOptionals: Codable, Equatable {
        let someString: String?
        let funnyInt: Int?
        let aFloat: Float?
        let thisIs: Bool?
        let wrong: Double?
        let a: Int8?
        let b: Int16?
        let c: Int32?
        let d: UInt?
        let e: UInt8?
        let f: UInt16?
        let g: UInt32?
    }

    struct UnsupportedPrimitive: Codable {
        let signed: Int64
        let unsigned: UInt64
    }
    struct UnsupportedPrimitiveOptionals: Codable {
        let signed: Int64?
        let unsigned: UInt64?
    }

    func testDecodePrimitiveStruct() throws {
        XCTAssertEqual(
            try ETFDecoder().decode(Primitive.self, from: Data(base64Encoded: "g3QAAAAMbQAAAApzb21lU3RyaW5nbQAAAAtoZWxsbyB3b3JsZG0AAAAIZnVubnlJbnRi///8AG0AAAAGYUZsb2F0RkAJHrhR64UfbQAAAAZ0aGlzSXNzBWZhbHNlbQAAAAV3cm9uZ0Y/v+OuZjZDiG0AAAABYWL////+bQAAAAFiYgAAAgttAAAAAWNiAAAQAG0AAAABZGEDbQAAAAFlYWZtAAAAAWZiAABQAG0AAAABZ2IADIAA")!),
            Primitive(
                someString: "hello world",
                funnyInt: -1024,
                aFloat: 3.14,
                thisIs: false,
                wrong: 0.1245678901234567,
                a: -2,
                b: 523,
                c: 4096,
                d: 3,
                e: 102,
                f: 20480,
                g: 819200
            ),
            "Struct with primitive types"
        )

        XCTAssertEqual(
            try ETFDecoder().decode(PrimitiveOptionals.self, from: Data(base64Encoded: "g3QAAAAMbQAAAApzb21lU3RyaW5nbQAAAAtoZWxsbyB3b3JsZG0AAAAIZnVubnlJbnRi///8AG0AAAAGYUZsb2F0RkAJHrhR64UfbQAAAAZ0aGlzSXNzBWZhbHNlbQAAAAV3cm9uZ0Y/v+OuZjZDiG0AAAABYWL////+bQAAAAFiYgAAAgttAAAAAWNiAAAQAG0AAAABZGEDbQAAAAFlYWZtAAAAAWZiAABQAG0AAAABZ2IADIAA")!),
            PrimitiveOptionals(
                someString: "hello world",
                funnyInt: -1024,
                aFloat: 3.14,
                thisIs: false,
                wrong: 0.1245678901234567,
                a: -2,
                b: 523,
                c: 4096,
                d: 3,
                e: 102,
                f: 20480,
                g: 819200
            ),
            "Struct with optional primitive types, with all values"
        )
        XCTAssertEqual(
            try ETFDecoder().decode(PrimitiveOptionals.self, from: Data(base64Encoded: "g3QAAAAMbQAAAApzb21lU3RyaW5ncwNuaWxtAAAACGZ1bm55SW50cwNuaWxtAAAABmFGbG9hdHMDbmlsbQAAAAZ0aGlzSXNzA25pbG0AAAAFd3JvbmdzA25pbG0AAAABYXMDbmlsbQAAAAFicwNuaWxtAAAAAWNzA25pbG0AAAABZHMDbmlsbQAAAAFlcwNuaWxtAAAAAWZzA25pbG0AAAABZ3MDbmls")!),
            PrimitiveOptionals(
                someString: nil,
                funnyInt: nil,
                aFloat: nil,
                thisIs: nil,
                wrong: nil,
                a: nil,
                b: nil,
                c: nil,
                d: nil,
                e: nil,
                f: nil,
                g: nil
            ),
            "Struct with optional primitive types, with all encoded values nil"
        )
        XCTAssertEqual(
            try ETFDecoder().decode(PrimitiveOptionals.self, from: Data(base64Encoded: "g3QAAAAA")!),
            PrimitiveOptionals(
                someString: nil,
                funnyInt: nil,
                aFloat: nil,
                thisIs: nil,
                wrong: nil,
                a: nil,
                b: nil,
                c: nil,
                d: nil,
                e: nil,
                f: nil,
                g: nil
            ),
            "Struct with optional primitive types, with empty map"
        )

        XCTAssertThrowsError(
            try ETFDecoder().decode(UnsupportedPrimitive.self, from: Data(base64Encoded: "g3QAAAACbQAAAAZzaWduZWRGw3R4GuHGLrNtAAAACHVuc2lnbmVkRkI1PHHgIgAA")!),
            "Unsupported 64-bit types"
        )
        XCTAssertThrowsError(
            try ETFDecoder().decode(UnsupportedPrimitiveOptionals.self, from: Data(base64Encoded: "g3QAAAAA")!),
            "Unsupported 64-bit types (optionals)"
        )
    }

    struct ComplexWithArray: Codable, Equatable {
        let a: [String]
    }
    func testDecodeComplexStruct() throws {
        XCTAssertEqual(
            try ETFDecoder().decode(ComplexWithArray.self, from: Data(base64Encoded: "g3QAAAABbQAAAAFhbAAAAARtAAAABGxpc3RtAAAAAm9mbQAAAAE0bQAAAAdTdHJpbmdzag==")!),
            ComplexWithArray(
                a: ["list", "of", "4", "Strings"]
            ),
            "Struct with one [String] property"
        )
    }
}
