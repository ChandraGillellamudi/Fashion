import UIKit

extension DispatchQueue {
    
    private static var _onceTracker = [String]()
    
    /**
     Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
     only execute the code once even in the presence of multithreaded calls.
     
     - parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
     - parameter block: Block to execute once
     */
    public class func once(_ token: String, block: (Void)->Void) {
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        
        if _onceTracker.contains(token) {
            return
        }
        
        _onceTracker.append(token)
        block()
    }
}


extension UIView {

  fileprivate struct AssociatedKeys {
    static var stylesApplied = "fashion_StylesAppliedAssociatedKey"
  }

  // MARK: - Method Swizzling

  override open class func initialize() {
    struct Static {
      static var token: Int = 0
    }

    if self !== UIView.self { return }
    DispatchQueue.once(AssociatedKeys.stylesApplied) {
      Swizzler.swizzle("willMoveToSuperview:", cls: self, prefix: "fashion")
    }
  }

  func fashion_willMoveToSuperview(_ newSuperview: UIView?) {
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

  fileprivate var stylesApplied: Bool? {
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
        case instance
        case `class`
    }

    public static func swizzle(_ method: String, cls: AnyClass!, prefix: String = "swizzled", kind: Kind = .instance) {
        let originalSelector = Selector(method)
        let swizzledSelector = Selector("\(prefix)_\(method)")

        let originalMethod = kind == .instance
            ? class_getInstanceMethod(cls, originalSelector)
            : class_getClassMethod(cls, originalSelector)

        let swizzledMethod = kind == .instance
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
