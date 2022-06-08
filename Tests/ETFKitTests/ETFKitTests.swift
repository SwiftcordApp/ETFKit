import XCTest
@testable import ETFKit

final class DecodeTests: XCTestCase {
    // These tests are just here for testing
    func testObject() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        // XCTAssertEqual(ETFKit().text, "Hello, World!")
        print(String(describing: try ETFKit.parseDict(data: Data(base64Encoded: "g3QAAAACbQAAAAFhYjp7/1VtAAAAAWJtAAABWWNpb2V3aGpmZ2lvZXdqZmlvZXdqaW9mYWV3dWlmaGF3ZWlvZmhhaXV3ZW9oZml1YWV3aGZ1aXdhZW5idWl2aHdhZXVpdmh3ZWF1aWZoaW93ZWFoZmlvd2VhamZpb3dlYWpmaW9ld2phaW9mandlYWlvZndlYWlvaGlvaGllb2F2d2huYXdldWlvdm5iaHV3ZWFiaG51aW9ld2FoZm5pb3dhZWhudmlvZndlYWhmb2phZXdvaWZqZXdhaW9mamF3ZWlvdm5oZWl3b2FoamZpb2p3YWZpb3dhZWpmb2lld2FvZmF3ZWZhd2VmaXdvZmpod2Vpb2hmaWVvd2hmaW9ld2hmb2lld2pmaW9ld2hucWdvaWhlbnF3b2dpaHF3ZWlvZ2poZXdxaW9naGV3aW9xaGdpb2Vxd2hnaW9ld2hxZ2lvZXdxaGdpb2V3cWhnaW9ld3FoZ2lvcWV3Zw==")!)))
    }
    
    func testBigEndian() throws {
        print(String(describing: try ETFKit.parseDict(data: Data(base64Encoded: "g3QAAAACbQAAAAFhYjp7/1VtAAAAAWJtAAAAAWM=")!)))
    }
    
    func testList() throws {
        print(String(describing: try ETFKit.parseDict(data: Data(base64Encoded: "g3QAAAABbQAAAAFhbAAAAANtAAAAAWJtAAAAAWNtAAAAAWRq")!)))
    }
}
