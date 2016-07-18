import Foundation

/// Style keeper, resolver and manager.
public class Stylist {

  public static let master = Stylist()

  typealias Stylization = (model: Styleable) -> Void

  var sharedStyles: [String: Stylization] = [:]
  var styles: [String: [Stylization]] = [:]

  // MARK: - Initialization

  public init() {}

  // MARK: - Stylization

  /**
  Applies set of styles to the passed `Styleable` model.

  - Parameter styles: Names of the style you want to apply in the specified order.
  - Parameter model: `Styleable` view/model.
  */
  func apply(styles: [String], model: Styleable) -> Void {
    for style in styles {
      apply(style, model: model)
    }
  }

  /**
   Applies a single style to the passed `Styleable` model.

   - Parameter style: Name of the style you want to apply.
   - Parameter model: `Styleable` view/model.
   */
  func apply(style: String, model: Styleable) -> Void {
    guard let styleList = styles[style] else { return }
    for style in styleList {
        style(model: model)
    }
  }

  /**
   Applies shared stylization closures, considering inheritance.

   - Parameter model: `Styleable` view/model.
   */
  func applyShared(model: Styleable) -> Bool {
    var resolved = false
    var type: AnyClass = model.dynamicType
    var typeHierarchy = [type]

    while let superclass = class_getSuperclass(type) {
      type = superclass
      typeHierarchy.insert(type, atIndex: 0)
    }

    for modelType in typeHierarchy {
      guard let style = sharedStyles[String(modelType)] else { continue }

      style(model: model)
      resolved = true
    }

    return resolved
  }
}

// MARK: - StyleManaging

extension Stylist: StyleManaging {

  /**
   Registers stylization closure with the specified name.
   Type used in the closure should conform to `Styleable` protocol

   - Parameter name: The name of the style you can apply to your view afterwards.
   - Parameter stylization: Closure where you can apply styles.
   */
  public func register<T: Styleable>(name: StringConvertible, stylization: T -> Void) {
    let style = Style(process: stylization)
    if styles[name.string] == nil {
        styles[name.string] = []
    }
    styles[name.string]!.append(style.applyTo)
  }

  /**
   Unregisters stylization closure with the specified name.

   - Parameter name: The name of the style you want to unregister.
   */
  public func unregister(name: StringConvertible) {
    styles.removeValueForKey(name.string)
  }

  /**
   Registers stylization closure on type level.
   The style will be shared across all objects of this type, considering inheritance.
   Type used in the closure should conform to `Styleable` protocol

   - Parameter stylization: Closure where you can apply styles.
   */
  public func share<T: Styleable>(stylization: T -> Void) {
    let style = Style(process: stylization)

    sharedStyles[String(T.self)] = style.applyTo
  }

  /**
   Unregisters shared stylization closure for the specified type.

   - Parameter type: The type you want to unregister.
   */
  public func unshare<T: Styleable>(type: T.Type) {
    sharedStyles.removeValueForKey(String(type))
  }
}
