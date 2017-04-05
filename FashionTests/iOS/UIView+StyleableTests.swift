import XCTest
@testable import Fashion

class UIViewStyleableTests: XCTestCase {

  var label: UILabel!

  override func setUp() {
    super.setUp()

    label = UILabel()
    label.backgroundColor = UIColor.red
    label.textColor = UIColor.white
    label.numberOfLines = 2

    Stylist.master.register("label-1") { (label: UILabel) in
      label.textColor = UIColor.red
      label.numberOfLines = 10
    }

    Stylist.master.register("label-2") { (label: UILabel) in
      label.backgroundColor = UIColor.yellow
      label.numberOfLines = 3
    }
  }

  override func tearDown() {
    Stylist.master.styles.removeAll()
    Stylist.master.sharedStyles.removeAll()
    super.tearDown()
  }

  func testInitFrameStyles() {
    // It applies styles
    label = UILabel(styles: "label-1 label-2")

    XCTAssertEqual(label.backgroundColor, UIColor.yellow)
    XCTAssertEqual(label.textColor, UIColor.red)
    XCTAssertEqual(label.numberOfLines, 3)
  }

  func testStylizeWithRegisteredStyles() {
    // It applies previously registered styles
    label.stylize("label-1", "label-2")

    XCTAssertEqual(label.backgroundColor, UIColor.yellow)
    XCTAssertEqual(label.textColor, UIColor.red)
    XCTAssertEqual(label.numberOfLines, 3)
  }

  func testStylizeWithNotRegisteredStyles() {
    // It does not apply not registered styles
    label.stylize("label-3", "label-4")

    XCTAssertEqual(label.backgroundColor, UIColor.red)
    XCTAssertEqual(label.textColor, UIColor.white)
    XCTAssertEqual(label.numberOfLines, 2)
  }

  func testStylesGetter() {
    // It returns a style that has been previously set
    label.styles = "label-1"
    XCTAssertEqual(label.styles, "label-1")
  }

  func testStylesWithSingleRegisteredStyle() {
    // It applies previously registered style"
    label.styles = "label-1"

    XCTAssertEqual(label.backgroundColor, UIColor.red)
    XCTAssertEqual(label.textColor, UIColor.red)
    XCTAssertEqual(label.numberOfLines, 10)
  }

  func testStylesWithSingleNotRegisteredStyle() {
    // It  does not apply not registered style
    label.styles = "label-3 label-4"

    XCTAssertEqual(label.backgroundColor, UIColor.red)
    XCTAssertEqual(label.textColor, UIColor.white)
    XCTAssertEqual(label.numberOfLines, 2)
  }

  func testStylesWithMultipleRegisteredStyles() {
    // It  applies previously registered styles
    label.styles = "label-1 label-2"

    XCTAssertEqual(label.backgroundColor, UIColor.yellow)
    XCTAssertEqual(label.textColor, UIColor.red)
    XCTAssertEqual(label.numberOfLines, 3)
  }

  func testStylesWithMultipleNotRegisteredStyle() {
    // It  does not apply not registered styles
    label.styles = "label-3 label-4"

    XCTAssertEqual(label.backgroundColor, UIColor.red)
    XCTAssertEqual(label.textColor, UIColor.white)
    XCTAssertEqual(label.numberOfLines, 2)
  }
}
