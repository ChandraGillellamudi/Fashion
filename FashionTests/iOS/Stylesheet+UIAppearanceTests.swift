import XCTest
@testable import Fashion

class StylesheetUIAppearanceTests: XCTestCase {

  override func tearDown() {
    Stylist.master.styles.removeAll()
    Stylist.master.sharedStyles.removeAll()
    super.tearDown()
  }

  func testShare() {
    let stylesheet = TestEmptyStylesheet()

    // It applies a stylization closure to UIAppearance context
    stylesheet.shareAppearance({ (navigationBar: UINavigationBar) in
      navigationBar.alpha = 0.5
    })

    XCTAssertEqual(UINavigationBar.appearance().alpha, 0.5)
  }
}
