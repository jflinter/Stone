

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
    
    case Fatty = "Fatty"
    case Gradient = "Gradient"
    case LaunchIcon = "LaunchIcon"
    case LaunchTitle = "LaunchTitle"
    case Stone_Logo_Icon = "Stone-Logo-Icon"
    case Icon__close = "icon_close"
    case Icon__share = "icon_share"
    case ScrollIndicator = "scrollIndicator"
    case Share = "share"
    
    
public enum Icons: String, ResourceImageConvertible {
    
    case Balance = "Balance"
    case Calm = "Calm"
    case Clarity = "Clarity"
    case Cleansing = "Cleansing"
    case Communication = "Communication"
    case Confidence = "Confidence"
    case Courage = "Courage"
    case Creativity = "Creativity"
    case Dreamwork = "Dreamwork"
    case Focus = "Focus"
    case Grounding = "Grounding"
    case Insight = "Insight"
    case Intuition = "Intuition"
    case Joy = "Joy"
    case Love = "Love"
    case Manifestation = "Manifestation"
    case Motivation = "Motivation"
    case OldPassion = "OldPassion"
    case Passion = "Passion"
    case Peace = "Peace"
    case Protection = "Protection"
    case Strength = "Strength"
    case Transformation = "Transformation"
    case Vitality = "Vitality"
    
}

}

}

