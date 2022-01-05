@testable import Publishing
import XCTest
final class PublishingTests: XCTestCase {
    func testPublishingAsInside() throws {
        @Publishing var sut = 1
        var history: [String] = []
        let cancelable = $sut.sink { history.append("sink \($0)") }
        sut += 1
        XCTAssertEqual(history, ["sink 1", "sink 2"])
        cancelable.cancel()
    }
}
