import XCTest
@testable import CTFeedbackSwift

class DeviceNameItemTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDeviceName() {
        let item = DeviceNameItem()
        XCTAssertEqual(item.deviceName, "Simulator")
    }
}
