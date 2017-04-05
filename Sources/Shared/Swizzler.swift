import Foundation

/**
 A helper struct for method swizzling.
 */
public struct Swizzler {

  public enum Kind {
    case Instance
    case Class
  }

  /**
   Swizzles method by name.

   - parameter method: Method
   - parameter cls: Class
   - parameter prefix: Unique prefix
   - parameter prefix: Swizzling type, instance or class
  */
  public static func swizzle(method: String,
                             cls: AnyClass!,
                             prefix: String = "swizzled",
                             kind: Kind = .Instance) {
    let originalSelector = Selector(method)
    let swizzledSelector = Selector("\(prefix)_\(method)")

    let originalMethod = kind == .Instance
      ? class_getInstanceMethod(cls, originalSelector)
      : class_getClassMethod(cls, originalSelector)

    let swizzledMethod = kind == .Instance
      ? class_getInstanceMethod(cls, swizzledSelector)
      : class_getClassMethod(cls, swizzledSelector)

    let didAddMethod = class_addMethod(cls, originalSelector,
                                       method_getImplementation(swizzledMethod),
                                       method_getTypeEncoding(swizzledMethod))

    if didAddMethod {
      class_replaceMethod(cls, swizzledSelector,
                          method_getImplementation(originalMethod),
                          method_getTypeEncoding(originalMethod))
    } else {
      method_exchangeImplementations(originalMethod, swizzledMethod)
    }
  }
}

/**
 DispatchQueue extension which implements dispatch_once functionality
 */
public extension DispatchQueue {

  private static var tokens = [String]()

  /**
   Executes a closure only once.

   - parameter token: A unique token
   - parameter closure: Closure to execute once
   */
  public class func once(token: String, closure: () -> Void) {
    objc_sync_enter(self)

    defer {
      objc_sync_exit(self)
    }

    guard !tokens.contains(token) else {
      return
    }

    tokens.append(token)
    closure()
  }
}
