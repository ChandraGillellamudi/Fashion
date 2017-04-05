/// Protocol that defined basic functions for style management.
public protocol StyleManaging {

  /**
   Registers stylization closure with the specified name.
   Type used in the closure should conform to `Styleable` protocol

   - Parameter name: The name of the style you can apply to your view afterwards.
   - Parameter stylization: Closure where you can apply styles.
   */
  func register<T: Styleable>(_ name: StringConvertible, stylization: @escaping (T) -> Void)

  /**
   Unregisters stylization closure with the specified name.

   - Parameter name: The name of the style you can apply to your view afterwards.
   */
  func unregister(_ name: StringConvertible)

  /**
   Registers stylization closure on type label.
   The style will be shared across all objects of this type, considering inheritance.
   Type used in the closure should conform to `Styleable` protocol

   - Parameter stylization: Closure where you can apply styles.
   */
  func share<T: Styleable>(_ stylization: @escaping (T) -> Void)

  /**
   Unregisters shared stylization closure for the specified type.

   - Parameter type: The type you want to unregister.
   */
  func unshare<T: Styleable>(_ type: T.Type)
}
