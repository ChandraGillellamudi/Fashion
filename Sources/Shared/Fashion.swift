/**
 Registers passed stylesheets by calling `define` function where
 all styling closures should be added.

 - Parameter stylesheets: Array of stylesheets to be registered.
 */
public func register(_ stylesheets: [Stylesheet]) {
  stylesheets.forEach {
    $0.define()
  }
}

/**
Must be set to `true` to get shared styles working automatically.
*/
public var runtimeStyles = true
