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
        var history: [Int] = []
        let cancelable = sut.$i.sink { value in
            history.append(value)
        }
        sut.set(2)
        XCTAssertEqual(spy, 2)
        XCTAssertEqual(history, [1,2])
        cancelable.cancel()
    }
}

private struct TestingView {
    @Binded var i: Int
    func set(to int: inout Int) {
        int = i
    }
    func set(_ newValue:Int) {
        i = newValue
    }
}
