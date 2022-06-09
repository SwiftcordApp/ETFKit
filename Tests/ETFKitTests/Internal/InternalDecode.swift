import XCTest
@testable import ETFKit

final class InternalDecodeTests: XCTestCase {
    func testInteger() throws {
        XCTAssertEqual(
            try ETFKit.decode(Data(base64Encoded: "g2IAAeJA")!) as? Int,
            123456,
            "Positive Int32 big endian"
        )
        XCTAssertEqual(
            try ETFKit.decode(Data(base64Encoded: "g2L///AA")!) as? Int,
            -4096,
            "Negative Int32 big endian"
        )

        XCTAssertEqual(
            try ETFKit.decode(Data(base64Encoded: "g2EQ")!) as? Int,
            16,
            "UInt8"
        )
        XCTAssertEqual(
            try ETFKit.decode(Data(base64Encoded: "g2L////4")!) as? Int,
            -8,
            "Small negative Int32"
        )
    }

    func testList() throws {
        XCTAssertEqual(
            try ETFKit.decode(Data(base64Encoded: "g2wAAAAGbQAAAAVoZWxsb20AAAAFd29ybGRtAAAAAWFtAAAABGxpc3RtAAAAAm9mbQAAAAhlbGVtZW50c2o=")!) as? [String],
            ["hello", "world", "a", "list", "of", "elements"],
            "Strings"
        )

        XCTAssertEqual(
            try ETFKit.decode(Data(base64Encoded: "g2wAAAAHYgAAFi5hBGIAAAOYYgAABNJiNxI34GL////2Yv///ABq")!) as? [Int],
            [5678, 4, 920, 1234, 923940832, -10, -1024],
            "Mix of UInt8 and Int32"
        )

        XCTAssertEqual(
            try ETFKit.decode(Data(base64Encoded: "g2wAAAADcwR0cnVlcwVmYWxzZXMDbmlsag==")!) as? [Bool?],
            [true, false, nil],
            "Small atoms (true/false/nil)"
        )

        XCTAssertEqual(
            try ETFKit.decode(Data(base64Encoded: "g2wAAAADRkBe3S8an753Rj08JcJoSXaCRkD+JAyfv4M4ag==")!) as? [Double],
            [123.456, 0.0000000000001, 123456.789001],
            "Doubles"
        )

        XCTAssertEqual(
            try ETFKit.decode(Data(base64Encoded: "g2o=")!) as? [Int],
            [],
            "Empty list (NIL_EXT)"
        )
    }

    func testUnicode() throws {
        XCTAssertEqual(
            try ETFKit.decode(Data(base64Encoded: "g20AAAAV5L2g5aW977yBSGVsbG8gdGhlcmUh")!) as? String,
            "你好！Hello there!"
        )
    }
}
