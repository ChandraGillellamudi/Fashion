#if os(iOS) || os(tvOS)
  import UIKit

  public typealias Styleable = UIAppearance
#elseif os(OSX)
  import Foundation

  public protocol Styleable: NSObjectProtocol {}
#endif

/// Convenience protocol for all types that could be styled.

public extension Styleable {

  /**
   Applies a stylization closure.

   - Parameter stylization: Closure where you can apply styles.
   */
  public func stylize(stylization: Self -> Void) -> Self {
    stylization(self)
    return self
  }
}
