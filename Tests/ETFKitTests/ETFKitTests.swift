import XCTest
@testable import ETFKit

final class DecodeTests: XCTestCase {
    // These tests are just here for testing
    func testObject() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        // XCTAssertEqual(ETFKit().text, "Hello, World!")
        print(String(describing: try ETFKit.parseDict(data: Data(base64Encoded: "g3QAAAABbQAAAAFhbAAAAARtAAAAAWJtAAAAAWNhAXQAAAABbQAAAAVoZWxsb20AAAAFd29ybGRq")!)))
    }

    func testBigEndian() throws {
        print(String(describing: try ETFKit.parseDict(data: Data(base64Encoded: "g3QAAAACbQAAAAFhYjp7/1VtAAAAAWJtAAAAAWM=")!)))
    }

    func testList() throws {
        print(String(describing: try ETFKit.parseDict(data: Data(base64Encoded: "g3QAAAABbQAAAAFhbAAAAANtAAAAAWJtAAAAAWNtAAAAAWRq")!)))
    }

    func testDouble() throws {
        print(String(describing: try ETFKit.parseDict(data: Data(base64Encoded: "g3QAAAABbQAAAAF2RkAkMzMzMzMz")!)))
    }

    func testNil() throws {
        print(String(describing: try ETFKit.parseDict(data: Data(base64Encoded: "g3QAAAABbQAAAAFucwNuaWw=")!)))
    }

    func testBool() throws {
        print(String(describing: try ETFKit.parseDict(data: Data(base64Encoded: "g3QAAAABbQAAAAFicwVmYWxzZQ==")!)))
    }

    func testUnicode() throws {
        print(String(describing: try ETFKit.parseDict(data: Data(base64Encoded: "g3QAAAABbQAAAAFibQAAAAbkvaDlpb0=")!)))
    }
}
