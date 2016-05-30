import UIKit

extension UIView {

  private struct AssociatedKeys {
    static var stylesApplied = "fashion_StylesAppliedAssociatedKey"
  }

  // MARK: - Method Swizzling

  override public class func initialize() {
    struct Static {
      static var token: dispatch_once_t = 0
    }

    if self !== UIView.self { return }

    dispatch_once(&Static.token) {
      Swizzler.swizzle("willMoveToSuperview:", cls: self, prefix: "fashion")
    }
  }

  func fashion_willMoveToSuperview(newSuperview: UIView?) {
    fashion_willMoveToSuperview(newSuperview)

    guard runtimeStyles else {
      return
    }

    guard Stylist.master.applyShared(self) && stylesApplied != true else {
      return
    }

    stylesApplied = true

    if let styles = styles {
      self.styles = styles
    }
  }

  private var stylesApplied: Bool? {
    get {
      return objc_getAssociatedObject(self, &AssociatedKeys.stylesApplied) as? Bool
    }
    set (newValue) {
      objc_setAssociatedObject(self, &AssociatedKeys.stylesApplied,
        newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
}

public struct Swizzler {

    public enum Kind {
        case Instance
        case Class
    }

    public static func swizzle(method: String, cls: AnyClass!, prefix: String = "swizzled", kind: Kind = .Instance) {
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
