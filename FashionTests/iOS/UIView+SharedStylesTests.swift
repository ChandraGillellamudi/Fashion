import XCTest
@testable import Fashion

class UIViewSharedStylesTests: XCTestCase {

  override func setUp() {
    super.setUp()

    Stylist.master.register("label-1") { (label: UILabel) in
      label.textColor = UIColor.red
    }

    Stylist.master.share { (label: UILabel) in
      label.textColor = UIColor.green
      label.layer.borderWidth = 2
    }

    Stylist.master.share { (view: UIView) in
      view.backgroundColor = UIColor.yellow
      view.tintColor = UIColor.red
      view.layer.borderWidth = 3
    }
  }

  override func tearDown() {
    Stylist.master.styles.removeAll()
    Stylist.master.sharedStyles.removeAll()
    super.tearDown()
  }

  func testWillMoveToSuperview() {
    Fashion.runtimeStyles = true

    // It applies shared styles when the view is added to superview
    var label = UILabel()
    var view = UIView()

    view.addSubview(label)

    XCTAssertEqual(label.backgroundColor, UIColor.yellow)
    XCTAssertEqual(label.tintColor, UIColor.red)
    XCTAssertEqual(label.textColor, UIColor.green)
    XCTAssertEqual(label.layer.borderWidth, 2)

    let textView = UITextView()
    view.addSubview(textView)

    XCTAssertEqual(textView.backgroundColor, UIColor.yellow)
    XCTAssertEqual(textView.tintColor, UIColor.red)
    XCTAssertNil(textView.textColor)
    XCTAssertEqual(textView.layer.borderWidth, 3)

    let button = Button()
    view.addSubview(button)

    XCTAssertEqual(button.backgroundColor, UIColor.yellow)
    XCTAssertEqual(button.tintColor, UIColor.red)
    XCTAssertEqual(button.layer.borderWidth, 3)

    // It does not override view-specific styles
    label = UILabel()
    label.styles = "label-1"
    view = UIView()
    view.addSubview(label)

    XCTAssertEqual(label.backgroundColor, UIColor.yellow)
    XCTAssertEqual(label.tintColor, UIColor.red)
    XCTAssertEqual(label.textColor, UIColor.red)
    XCTAssertEqual(label.layer.borderWidth, 2)
  }

  func testWillMoveToSuperviewWithDisabledRuntimeStyles() {
    Fashion.runtimeStyles = false

    // It does not apply shared styles"
    Fashion.runtimeStyles = false

    let label = UILabel()
    let view = UIView()

    view.addSubview(label)

    XCTAssertNotEqual(label.backgroundColor, UIColor.yellow)
    XCTAssertNotEqual(label.tintColor, UIColor.red)
    XCTAssertNotEqual(label.textColor, UIColor.green)
    XCTAssertNotEqual(label.layer.borderWidth, 2)
  }
}
