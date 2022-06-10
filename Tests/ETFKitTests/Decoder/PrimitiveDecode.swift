import XCTest
@testable import ETFKit

final class PrimitiveDecodeTests: XCTestCase {
    func testInteger() throws {
        XCTAssertEqual(
            try ETFDecoder().decode(Int.self, from: Data(base64Encoded: "g2GA")!),
            128,
            "UInt8"
        )

        XCTAssertEqual(
            try ETFDecoder().decode(Int.self, from: Data(base64Encoded: "g2IAAAgA")!),
            2048,
            "Int32 Positive"
        )
        XCTAssertEqual(
            try ETFDecoder().decode(Int.self, from: Data(base64Encoded: "g2L///4A")!),
            -512,
            "Int32 Negative"
        )

        XCTAssertEqual(
            try ETFDecoder().decode(Int8.self, from: Data(base64Encoded: "g2Ec")!),
            28,
            "Explicit Int8"
        )
        XCTAssertEqual(
            try ETFDecoder().decode(Int16.self, from: Data(base64Encoded: "g2FF")!),
            69,
            "Explicit Int16"
        )
        XCTAssertEqual(
            try ETFDecoder().decode(Int16.self, from: Data(base64Encoded: "g2IAAAGk")!),
            420,
            "Explicit Int32"
        )

        XCTAssertEqual(
            try ETFDecoder().decode(UInt16.self, from: Data(base64Encoded: "g2E0")!),
            52,
            "Explicit UInt"
        )
        XCTAssertEqual(
            try ETFDecoder().decode(UInt8.self, from: Data(base64Encoded: "g2GA")!),
            128,
            "Explicit UInt8"
        )
        XCTAssertEqual(
            try ETFDecoder().decode(UInt16.self, from: Data(base64Encoded: "g2GA")!),
            128,
            "Explicit UInt16"
        )
        XCTAssertEqual(
            try ETFDecoder().decode(UInt16.self, from: Data(base64Encoded: "g2IAAAgA")!),
            2048,
            "Explicit UInt32"
        )
    }

    func testString() throws {
        XCTAssertEqual(
            try ETFDecoder().decode(String.self, from: Data(base64Encoded: "g20AAAAMSGVsbG8gd29ybGQh")!),
            "Hello world!",
            "String (short)"
        )
        XCTAssertEqual(
            try ETFDecoder().decode(String.self, from: Data(base64Encoded: "g20AAAAe5L2g5aW977yM5LiW55WM77yBSGVsbG8gd29ybGQh")!),
            "你好，世界！Hello world!",
            "String (short with unicode)"
        )

        XCTAssertEqual(
            try ETFDecoder().decode(String.self, from: Data(base64Encoded: "g20AAAH7SGVyZSdzIHRvIHRoZSBjcmF6eSBvbmVzLiBUaGUgbWlzZml0cywgdGhlIHJlYmVscy4gVGhlIHRyb3VibGVtYWtlcnMuIFRoZSByb3VuZCBwZWdzIGluIHRoZSBzcXVhcmUgaG9sZXMuIFRoZSBvbmVzIHdobyBzZWUgdGhpbmdzIGRpZmZlcmVudGx5LiBUaGV5J3JlIG5vdCBmb25kIG9mIHJ1bGVzLiBZb3UgY2FuIHF1b3RlIHRoZW0sIGRpc2FncmVlIHdpdGggdGhlbSwgZ2xvcmlmeSBvciB2aWxpZnkgdGhlbS4gQWJvdXQgdGhlIG9ubHkgdGhpbmcgeW91IGNhbid0IGRvIGlzIGlnbm9yZSB0aGVtLiBCZWNhdXNlIHRoZXkgY2hhbmdlIHRoaW5ncy4gVGhleSBwdXNoIHRoZSBodW1hbiByYWNlIGZvcndhcmQuIEFuZCB3aGlsZSBzb21lIG1heSBzZWUgdGhlbSBhcyB0aGUgY3Jhenkgb25lcywgd2Ugc2VlIGdlbml1cy4gQmVjYXVzZSB0aGUgb25lcyB3aG8gYXJlIGNyYXp5IGVub3VnaCB0byB0aGluayB0aGF0IHRoZXkgY2FuIGNoYW5nZSB0aGUgd29ybGQsIGFyZSB0aGUgb25lcyB3aG8gZG8u")!),
            """
            Here's to the crazy ones. The misfits, the rebels. The troublemakers. \
            The round pegs in the square holes. The ones who see things differently. \
            They're not fond of rules. You can quote them, disagree with them, glorify \
            or vilify them. About the only thing you can't do is ignore them. Because \
            they change things. They push the human race forward. And while some may \
            see them as the crazy ones, we see genius. Because the ones who are crazy \
            enough to think that they can change the world, are the ones who do.
            """,
            "String (long, > 256 chars)"
        )
    }
    
    func testFloating() throws {
        XCTAssertEqual(
            try ETFDecoder().decode(Double.self, from: Data(base64Encoded: "g0ZACSH7VEQtGA==")!),
            Double.pi,
            "Max Double precision"
        )
        XCTAssertEqual(
            try ETFDecoder().decode(Double.self, from: Data(base64Encoded: "g0bACSH7VEQtGA==")!),
            -Double.pi,
            "Negative Double"
        )

        XCTAssertEqual(
            try ETFDecoder().decode(Float.self, from: Data(base64Encoded: "g0ZACSH7P6be/A==")!),
            Float.pi,
            "Max Float precision"
        )
    }
}
