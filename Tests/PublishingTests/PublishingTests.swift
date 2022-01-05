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

    func testCanInjectProjectValue() throws {
        @Publishing var spy = 1
        let sut = TestingView(i: $spy)
        var target = 0
        sut.set(to: &target)
        XCTAssertEqual(spy, 1)
        XCTAssertEqual(target, 1)
    }
}

private struct TestingView {
    @Binded var i: Int
    func set(to int: inout Int) {
        int = i
    }
}
