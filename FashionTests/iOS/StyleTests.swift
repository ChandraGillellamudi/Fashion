import XCTest
@testable import Fashion

class StyleTests: XCTestCase {

  var style: Style<UILabel>!

  override func setUp() {
    super.setUp()
    style = Style<UILabel>{ label in
      label.backgroundColor = UIColor.white
      label.textColor = UIColor.red
      label.numberOfLines = 10
    }
  }

  override func tearDown() {
    super.tearDown()
    Stylist.master.styles.removeAll()
    Stylist.master.sharedStyles.removeAll()
  }

  func testApplyToWithCorrectModelType() {
    let label = UILabel()
    label.backgroundColor = UIColor.red
    label.textColor = UIColor.white
    label.numberOfLines = 2

    style.applyTo(label)

    // It applies the style to the passed model
    XCTAssertEqual(label.backgroundColor, UIColor.white)
    XCTAssertEqual(label.textColor, UIColor.red)
    XCTAssertEqual(label.numberOfLines, 10)
  }

  func testApplyToWithWrongModelType() {
    let view = UIView()
    view.backgroundColor = UIColor.red

    style.applyTo(view)

    // It does not apply the style to the passed model
    XCTAssertEqual(view.backgroundColor, UIColor.red)
  }
}
