import Plot

// HTMLComponents.swift

extension ElementDefinitions {
    /// Definition for the `<section>` element.
    enum Section: ElementDefinition { public static var wrapper = Node.section }
}

/// A container component that's rendered using the `<section>` element.
typealias SectionElement = ElementComponent<ElementDefinitions.Section>
