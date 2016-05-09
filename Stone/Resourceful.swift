

// This code is autogenerated by Resourceful - do not modify

#if os(iOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

public protocol ResourceImageConvertible {}

public extension ResourceImageConvertible where Self: RawRepresentable, Self.RawValue == String {
#if os(iOS)
    public var image: UIImage? {
        return UIImage(named: self.rawValue)
    }
#elseif os(OSX)
    public var image: NSImage? {
        return NSImage(named: self.rawValue)
    }
#endif
}

public enum Resource {
    
public enum Image: String, ResourceImageConvertible {
    
    case Stone_Logo_Icon = "Stone-Logo-Icon"
    case Focus = "focus"
    case Footer = "footer"
    case Icon__close = "icon_close"
    case Meta = "meta"
    
}

}

