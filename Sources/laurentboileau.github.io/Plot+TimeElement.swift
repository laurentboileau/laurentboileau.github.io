import Foundation
import Plot

// HTML.swift

/// Context shared among all HTML elements that support the `datetime`
/// attribute, for example `<time>.
protocol HTMLDatetimeContext: HTMLContext {}

extension HTML {
    /// The context within a `<time>` element.
    enum TimeContext: HTMLDatetimeContext {}
}

// ComponentAttributes.swift

extension Component {
    /// Add a `datetime` attribute to this component's element.
    /// - parameter date: The attribute's date value.
    /// - parameter timeZone: The time zone of the given `Date` (default: `.current`).
    func datetime(_ date: Date, timeZone: TimeZone = .current) -> Component {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = timeZone
        let dateString = formatter.string(from: date)
        return datetime(value: dateString)
    }
    /// Add a `datetime` attribute to this component's element.
    /// - parameter date: The attribute's string value.
    func datetime(value: String) -> Component {
        attribute(named: "datetime", value: value)
    }
}

// HTMLElements.swift

extension Node where Context: HTML.BodyContext {
    /// Add a `<time>` HTML element within the current context.
    /// - parameter nodes: The element's attributes and child elements.
    static func time(nodes: Node<HTML.TimeContext>...) -> Node {
        .element(named: "time", nodes: nodes)
    }
}

// HTMLComponents.swift

enum ElementDefinitions {
    /// Definition for the `<time>` element.
    enum Time: ElementDefinition { public static var wrapper = Node.time }
}

/// A container component that's rendered using the `<time>` element.
typealias TimeElement = ElementComponent<ElementDefinitions.Time>
