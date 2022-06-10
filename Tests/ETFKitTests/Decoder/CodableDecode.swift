import XCTest
@testable import ETFKit

final class CodableDecodeTests: XCTestCase {
    struct SimplePrimitive: Codable, Equatable {
        let someString: String
        let funnyInt: Int
    }

    func testDecodeStruct() throws {
        XCTAssertEqual(
            try ETFDecoder().decode(SimplePrimitive.self, from: Data(base64Encoded: "g3QAAAACbQAAAApzb21lU3RyaW5nbQAAAAtoZWxsbyB3b3JsZG0AAAAIZnVubnlJbnRiAAAE0g==")!),
            SimplePrimitive(someString: "hello world", funnyInt: 1234),
            "Simple struct with primitive types"
        )
    }
}
