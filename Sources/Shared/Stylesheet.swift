/// Convenience protocol for all types where you register your styles.
public protocol Stylesheet: StyleManaging {

  /**
   Convenience function to register your styles.
   */
  func define()
}

// MARK: - StyleManaging

public extension Stylesheet {

  /**
   Registers stylization closure with the specified name.
   Type used in the closure should conform to `Styleable` protocol

   - Parameter name: The name of the style you can apply to your view afterwards.
   - Parameter stylization: Closure where you can apply styles.
   */
  public func register<T: Styleable>(_ name: StringConvertible, stylization: @escaping (T) -> Void) {
    Stylist.master.register(name, stylization: stylization)
  }

  /**
   Unregisters stylization closure with the specified name.

   - Parameter name: The name of the style you want to unregister.
   */
  public func unregister(_ name: StringConvertible) {
    Stylist.master.unregister(name)
  }

  /**
   Registers stylization closure on type label.
   The style will be shared across all objects of this type, considering inheritance.
   Type used in the closure should conform to `Styleable` protocol

   - Parameter stylization: Closure where you can apply styles.
   */
  public func share<T: Styleable>(_ stylization: @escaping (T) -> Void) {
    Stylist.master.share(stylization)
  }

  /**
   Unregisters shared stylization closure for the specified type.

   - Parameter type: The type you want to unregister.
   */
  public func unshare<T: Styleable>(_ type: T.Type) {
    Stylist.master.unshare(type)
  }
}
