import UIKit

public extension Stylesheet {

  /**
   Wrapper function to set UIAppearance.
   Use `share` method instead.
   `share` is the recommended method to achieve the same behavior and even more.

   - Parameter stylization: Closure where you can apply styles.
   */
  public func shareAppearance<T: Styleable>(_ stylization: (T) -> Void) {
    stylization(T.appearance())
  }
}
