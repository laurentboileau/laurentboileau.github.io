import Plot

extension Node {
    /// Add a `<main>` HTML element within the current context.
    /// - parameter nodes: The element's attributes and child elements.
    static func main(_ nodes: Node<HTML.BodyContext>...) -> Node {
        .element(named: "main", nodes: nodes)
    }
    /// Add a `<section>` HTML element within the current context.
    /// - parameter nodes: The element's attributes and child elements.
    static func section(_ nodes: Node<HTML.BodyContext>...) -> Node {
        .element(named: "section", nodes: nodes)
    }
}

extension ElementDefinitions {
    /// Definition for the `<main>` element.
    public enum Main: ElementDefinition { public static var wrapper = Node.main }
    /// Definition for the `<section>` element.
    public enum Section: ElementDefinition { public static var wrapper = Node.section }
}

/// A container component that's rendered using the `<main>` element.
typealias MainElement = ElementComponent<ElementDefinitions.Main>
/// A container component that's rendered using the `<section>` element.
typealias SectionElement = ElementComponent<ElementDefinitions.Section>
