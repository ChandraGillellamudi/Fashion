import XCTest
@testable import Fashion

class StylesheetTests: XCTestCase {

  let stylesheet = TestEmptyStylesheet()
  let style = "red-button"

  override func setUp() {
    super.setUp()
  }

  override func tearDown() {
    Stylist.master.styles.removeAll()
    Stylist.master.sharedStyles.removeAll()
    super.tearDown()
  }

  func testRegister() {
    stylesheet.register(style, stylization: { (button: UIButton) in
      button.backgroundColor = UIColor.red
    })

    // It registers stylization closure with a specified style name
    XCTAssertNotNil(Stylist.master.styles[style])
  }

  func testUnregister() {
    stylesheet.register(style, stylization: { (button: UIButton) in
      button.backgroundColor = UIColor.red
    })

    XCTAssertNotNil(Stylist.master.styles[style])

    stylesheet.unregister(style)

    // It unregisters stylization closure
    XCTAssertNil(Stylist.master.styles[style])
  }

  func testShare() {
    stylesheet.share { (button: UIButton) in
      button.backgroundColor = UIColor.red
    }

    // It registers shared stylization closure for the specified type
    XCTAssertNotNil(Stylist.master.sharedStyles["UIButton"])
  }

  func testUnshare() {
    stylesheet.share { (button: UIButton) in
      button.backgroundColor = UIColor.red
    }

    XCTAssertNotNil(Stylist.master.sharedStyles["UIButton"])
    stylesheet.unshare(UIButton.self)

    // It unregisters shared stylization closure for the specified type
    XCTAssertNil(Stylist.master.sharedStyles["UIButton"])
  }
}
