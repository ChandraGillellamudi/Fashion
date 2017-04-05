![Fashion](https://github.com/vadymmarkov/Fashion/blob/master/Resources/FashionPresentation.png)

[![CI Status](http://img.shields.io/travis/vadymmarkov/Fashion.svg?style=flat)](https://travis-ci.org/vadymmarkov/Fashion)
[![Version](https://img.shields.io/cocoapods/v/Fashion.svg?style=flat)](http://cocoadocs.org/docsets/Fashion)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
![Swift](https://img.shields.io/badge/%20in-swift%203.0-orange.svg)
[![License](https://img.shields.io/cocoapods/l/Fashion.svg?style=flat)](http://cocoadocs.org/docsets/Fashion)
[![Platform](https://img.shields.io/cocoapods/p/Fashion.svg?style=flat)](http://cocoadocs.org/docsets/Fashion)

## Description

**Fashion** is your helper to share and reuse UI styles in a Swifty way. The
main goal is not to style your native apps in CSS, but use a set of convenience
helper functions to decouple your styles from a layout code, improving
customization and reusability. Also here we try to go beyond the `UIAppearance`
possibilities to customize appearance for all instance objects of the specified
type.

## Table of Contents

* [Usage](#usage)
  * [Conventional way](#conventional-way)
  * [Stylesheet](#stylesheet)
  * [Stylist](#stylist)
  * [UIView extensions](#uiview-extensions)
* [Installation](#installation)
* [Author](#author)
* [Contributing](#contributing)
* [License](#license)

## Usage

### Conventional way

**Define styles in a stylesheet**

```swift
enum Style: String, StringConvertible {
  case customButton

  var string: String {
    return rawValue
  }
}

struct MainStylesheet: Stylesheet {

  func define() {
    share { (label: UILabel) in
      label.textColor = .blue
      label.numberOfLines = 2
      label.adjustsFontSizeToFitWidth = true
    }

    // register("custom-button") { (button: UIButton) in
    register(Style.customButton) { (button: UIButton) in
      button.backgroundColor = .red
      button.setTitleColor(.white, for: .normal)
    }
  }
}
```

**Register a stylesheet**
```swift
Fashion.register([MainStylesheet()])
```

**Apply a style**

```swift
let button = UIButton() // let button = UIButton(styles: "custom-button")
button.stylize(Style.customButton) // backgroundColor => .red

let label = UILabel()
addSubview(label) // textColor => .blue
```

### Stylesheet

`Stylesheet` is a protocol that helps you to organize your styles by registering
them in `define` method:

**Register a style**

```swift
// Registers stylization closure with the specified name.
register("card-view") { (view: UIView) in
  view.backgroundColor = .white
  view.layer.masksToBounds = false
  view.layer.shadowColor = UIColor.black.cgColor
  view.layer.shadowOffset = CGSize(width: 0, height: 0.5)
  view.layer.shadowOpacity = 0.2
  view.layer.cornerRadius = 8
}
```

**Unregister a style**

```swift
// Unregisters stylization closure with the specified name.
unregister("card-view")
```

**Share a style**

The style will be shared across all objects of this type, considering
inheritance.

```swift
// All views will have red background color.
share { (view: UIView) in
  view.backgroundColor = .red
}

// All table views will have white background color, it overrides the red
// background registered above.
share { (tableView: UITableView) in
  tableView.backgroundColor = .white
  tableView.tableFooterView = UIView(frame: CGRect.zero)
  tableView.separatorStyle = .none
  tableView.separatorInset = .zero
}
```

**Unshare a style**

```swift
// Unregisters shared stylization closure for the specified type.
unshare(UITableView.self)
```

**UIAppearance**

`share` is the recommended method to customize the appearance of class's
instances, but sometimes we still have to use `UIAppearance` because of
default styles set on the class’s appearance proxy when a view enters a window.

```swift
shareAppearance { (barButtonItem: UIBarButtonItem) in
  barButtonItem.setTitleTextAttributes([
    NSFontAttributeName : UIFont(name: "HelveticaNeue-Light", size: 12)!,
    NSForegroundColorAttributeName : UIColor.red],
    for: .normal)
}
```

### Stylist

When you register/share your styles in the `Stylesheet` all the actual work is
done by `Stylist` under the hood, so if you want more freedom it's possible
to use `Stylist` class directly. You can create a new instance `Stylist()` or
use the global variable `Stylist.master` which is used in stylesheets.

```swift
let stylist = Stylist()

stylist.register("card-view") { (view: UIView) in
  view.backgroundColor = .white
  view.layer.cornerRadius = 8
}

stylist.unregister("card-view")

stylist.share { (tableView: UITableView) in
  tableView.backgroundColor = .white
  tableView.tableFooterView = UIView(frame: .zero)
}

stylist.unshare(UITableView.self)
```

### UIView extensions

It's super easy to apply previously registered styles with `UIView` extensions.

**With convenience initializer**

```swift
// A single style
let button = UIButton(styles: "custom-button")

// Multiple styles should be separated by a space
let label = UILabel(styles: "content-view cool-label")
```

```swift
// The initialized also accepts StringConvertible, so something other
// than magic String could also be used

enum Style: String, StringConvertible {
  case customButton
  case contentView
  case coolLabel

  var string: String {
    return rawValue
  }
}

// A single style
let button = UIButton(styles: Style.customButton)

// Multiple styles
let label = UILabel(styles: [Style.contentView, Style.coolLabel])
```

**With `stylize` function**

```swift
let label = UILabel()

// StringConvertible
label.stylize(Style.contentView, Style.coolLabel)

// String
label.stylize("content-view", "cool-label")
```

**With `@IBInspectable` property `styles`**

```swift
let button = UIButton()

// A single style
button.styles = "custom-button"

// Multiple styles
button.styles = "content-view custom-button"
```

## Author

Vadym Markov, markov.vadym@gmail.com

## Installation

**Fashion** is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Fashion'
```

**Fashion** is also available through [Carthage](https://github.com/Carthage/Carthage).
To install just write into your Cartfile:

```ruby
github "vadymmarkov/Fashion"
```

## Author

Vadym Markov, markov.vadym@gmail.com

## Contributing

We would love you to contribute to **Fashion**, check the [CONTRIBUTING](https://github.com/vadymmarkov/Fashion/blob/master/CONTRIBUTING.md) file for more info.

## License

**Fashion** is available under the MIT license. See the [LICENSE](https://github.com/vadymmarkov/Fashion/blob/master/LICENSE.md) file for more info.
