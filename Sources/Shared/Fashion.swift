#if os(iOS) || os(tvOS)
  import UIKit
#endif

/**
 Registers passed stylesheets by calling `define` function where
 all styling closures should be added.

 - Parameter stylesheets: Array of stylesheets to be registered.
 */
public func register(stylesheets: [Stylesheet]) {

  #if os(iOS) || os(tvOS)
    UIView.setupSwizzling()
  #endif

  stylesheets.forEach {
    $0.define()
  }
}

/**
Must be set to `true` to get shared styles working automatically.
*/
public var runtimeStyles = true
