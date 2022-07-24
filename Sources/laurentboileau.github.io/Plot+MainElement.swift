import Plot

// HTMLComponents.swift

extension ElementDefinitions {
    /// Definition for the `<main>` element.
    enum Main: ElementDefinition { public static var wrapper = Node.main }
}

/// A container component that's rendered using the `<main>` element.
typealias MainElement = ElementComponent<ElementDefinitions.Main>
