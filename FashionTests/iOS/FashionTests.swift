import XCTest
@testable import Fashion

class FashionTests: XCTestCase {

  override func setUp() {
    super.setUp()
  }

  override func tearDown() {
    Stylist.master.styles.removeAll()
    Stylist.master.sharedStyles.removeAll()
    super.tearDown()
  }

  func testRegister() {
    let stylesheet = TestStylesheet()
    Fashion.register(stylesheets: [stylesheet])
    // It registers passed stylesheets
    XCTAssertNotNil(Stylist.master.styles[stylesheet.style])
  }
}
