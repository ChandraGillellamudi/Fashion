import XCTest
@testable import Fashion

class StylistTests: XCTestCase {

  var stylist: Stylist!

  override func setUp() {
    super.setUp()
    stylist = Stylist()
  }

  override func tearDown() {
    Stylist.master.styles.removeAll()
    Stylist.master.sharedStyles.removeAll()
    super.tearDown()
  }

  func testApplyStyles() {
    let styles = ["label-1", "label-2"]

    stylist.register("label-1") { (label: UILabel) in
      label.textColor = UIColor.red
      label.numberOfLines = 10
    }

    stylist.register("label-2") { (label: UILabel) in
      label.backgroundColor = UIColor.yellow
      label.numberOfLines = 3
    }

    // When the model is of expected type
    // it applies the styles to the passed model
    let label = UILabel()
    label.backgroundColor = UIColor.red
    label.textColor = UIColor.white
    label.numberOfLines = 2

    stylist.apply(styles, model: label)

    XCTAssertEqual(label.backgroundColor, UIColor.yellow)
    XCTAssertEqual(label.textColor, UIColor.red)
    XCTAssertEqual(label.numberOfLines, 3)

    // When the model is of different type
    // it does not apply the styles to the passed model
    let view = UIView()
    view.backgroundColor = UIColor.red
    stylist.apply(styles, model: view)

    XCTAssertEqual(view.backgroundColor, UIColor.red)
  }

  func testApplyStyle() {
    let style = "label-3"

    stylist.register("label-3") { (label: UILabel) in
      label.textColor = UIColor.red
      label.backgroundColor = UIColor.yellow
      label.numberOfLines = 10
    }

    // When the model is of expected type
    // it applies the styles to the passed model
    let label = UILabel()
    label.backgroundColor = UIColor.red
    label.textColor = UIColor.white
    label.numberOfLines = 2

    stylist.apply(style, model: label)

    XCTAssertEqual(label.backgroundColor, UIColor.yellow)
    XCTAssertEqual(label.textColor, UIColor.red)
    XCTAssertEqual(label.numberOfLines, 10)

    // When the model is of different type
    // it does not apply the styles to the passed model
    let view = UIView()
    view.backgroundColor = UIColor.red
    stylist.apply(style, model: view)

    XCTAssertEqual(view.backgroundColor, UIColor.red)
  }

  func testApplyShared() {
    stylist.share { (label: UILabel) in
      label.textColor = UIColor.green
      label.layer.borderWidth = 2
    }

    stylist.share { (view: UIView) in
      view.backgroundColor = UIColor.yellow
      view.tintColor = UIColor.red
      view.layer.borderWidth = 3
    }

    // It applies shared styles to the passed model
    let label = UILabel()

    stylist.applyShared(label)

    XCTAssertEqual(label.backgroundColor, UIColor.yellow)
    XCTAssertEqual(label.tintColor, UIColor.red)
    XCTAssertEqual(label.textColor, UIColor.green)
    XCTAssertEqual(label.layer.borderWidth, 2)

    let textView = UITextView()
    stylist.applyShared(textView)

    XCTAssertEqual(textView.backgroundColor, UIColor.yellow)
    XCTAssertEqual(textView.tintColor, UIColor.red)
    XCTAssertNil(textView.textColor)
    XCTAssertEqual(textView.layer.borderWidth, 3)

    let button = Button()
    stylist.applyShared(button)

    XCTAssertEqual(button.backgroundColor, UIColor.yellow)
    XCTAssertEqual(button.tintColor, UIColor.red)
    XCTAssertEqual(button.layer.borderWidth, 3)
  }

  func testRegister() {
    let style = "red-button"

    stylist.register(style) { (button: UIButton) in
      button.backgroundColor = UIColor.red
    }

    // It registers stylization closure with a specified style name
    XCTAssertNotNil(stylist.styles[style])
  }

  func testUnregister() {
    let style = "red-button"

    stylist.register(style) { (button: UIButton) in
      button.backgroundColor = UIColor.red
    }

    XCTAssertNotNil(stylist.styles[style])

    stylist.unregister(style)

    // It unregisters stylization closure
    XCTAssertNil(stylist.styles[style])
  }

  func testShare() {
    stylist.share { (button: UIButton) in
      button.backgroundColor = UIColor.red
    }

    // It registers shared stylization closure for the specified type
    XCTAssertNotNil(stylist.sharedStyles["UIButton"])
  }

  func testUnshre() {
    stylist.share { (button: UIButton) in
      button.backgroundColor = UIColor.red
    }

    XCTAssertNotNil(stylist.sharedStyles["UIButton"])

    stylist.unshare(UIButton.self)

    // It unregisters shared stylization closure for the specified type
    XCTAssertNil(stylist.sharedStyles["UIButton"])
  }
}
