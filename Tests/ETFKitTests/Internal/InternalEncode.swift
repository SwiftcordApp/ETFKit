import XCTest
@testable import ETFKit

final class InternalEncodeTests: XCTestCase {
    func testInteger() throws {
        XCTAssertEqual(
            try ETFKit.encode(16).base64EncodedString(),
            "g2EQ",
            "UInt8"
        )
        XCTAssertEqual(
            try ETFKit.encode(-8).base64EncodedString(),
            "g2L////4",
            "Small negative Int32"
        )

        XCTAssertEqual(
            try ETFKit.encode(-1024).base64EncodedString(),
            "g2L///wA",
            "Positive Int32"
        )
    }

    func testList() throws {
        // Basically the opposite of the list decode tests
        XCTAssertEqual(
            try ETFKit.encode(["hello", "world", "a", "list", "of", "elements"]).base64EncodedString(),
            "g2wAAAAGbQAAAAVoZWxsb20AAAAFd29ybGRtAAAAAWFtAAAABGxpc3RtAAAAAm9mbQAAAAhlbGVtZW50c2o=",
            "Strings"
        )

        XCTAssertEqual(
            try ETFKit.encode([5678, 4, 920, 1234, 923940832, -10, -1024]).base64EncodedString(),
            "g2wAAAAHYgAAFi5hBGIAAAOYYgAABNJiNxI34GL////2Yv///ABq",
            "Mix of UInt8 and Int32"
        )

        XCTAssertEqual(
            try ETFKit.encode([true, false, nil]).base64EncodedString(),
            "g2wAAAADcwR0cnVlcwVmYWxzZXMDbmlsag==",
            "Small atoms (true/false/nil)"
        )

        XCTAssertEqual(
            try ETFKit.encode([123.456, 0.0000000000001, 123456.789001]).base64EncodedString(),
            "g2wAAAADRkBe3S8an753Rj08JcJoSXaCRkD+JAyfv4M4ag==" ,
            "Doubles"
        )

        XCTAssertEqual(
            try ETFKit.encode([]).base64EncodedString(),
            "g2o=",
            "Empty list (NIL_EXT)"
        )
    }
    
    func testDictionary() throws {
        XCTAssertEqual(
            try ETFKit.encode(["hello": "world"]).base64EncodedString(),
            "g3QAAAABbQAAAAVoZWxsb20AAAAFd29ybGQ=",
            "Basic dictionary"
        )

        let kitchenSinkEncoded = try ETFKit.encode([
            "list": ["of some numbers", 4096, 4, -257, -1, "to", "pack", nil, ["is": nil], true],
            "a": "string",
        ]).base64EncodedString()
        let validEncodings = [
            "g3QAAAACbQAAAAFhbQAAAAZzdHJpbmdtAAAABGxpc3RsAAAACm0AAAAPb2Ygc29tZSBudW1iZXJzYgAAEABhBGL///7/Yv////9tAAAAAnRvbQAAAARwYWNrcwNuaWx0AAAAAW0AAAACaXNzA25pbHMEdHJ1ZWo=",
            "g3QAAAACbQAAAARsaXN0bAAAAAptAAAAD29mIHNvbWUgbnVtYmVyc2IAABAAYQRi///+/2L/////bQAAAAJ0b20AAAAEcGFja3MDbmlsdAAAAAFtAAAAAmlzcwNuaWxzBHRydWVqbQAAAAFhbQAAAAZzdHJpbmc="
        ] // All possible combinations that might be produced since dicts are unordered
        XCTAssert(validEncodings.contains(kitchenSinkEncoded), "Kitchen sink dictionary")
    }

    func testEncodingFailure() {
        XCTAssertThrowsError(try ETFKit.encode(Date()), "Unencodable root element")
        XCTAssertThrowsError(try ETFKit.encode(["oh", "no", UUID()]), "Unencodable list element")
        XCTAssertThrowsError(try ETFKit.encode(["my": "love", "a": Data()]), "Unencodable dict element")
    }
}
