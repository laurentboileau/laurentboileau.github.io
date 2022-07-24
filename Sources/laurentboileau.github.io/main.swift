import Foundation
import Publish
import Plot

// This type acts as the configuration for your website.
struct LaurentBoileau: Website {
    enum SectionID: String, WebsiteSectionID {
        // Add the sections that you want your website to contain here:
        case posts
    }

    struct ItemMetadata: WebsiteItemMetadata {
        // Add any site-specific metadata that you want to use here.
    }

    // Update these properties to configure your website:
    var url = URL(string: "https://laurentboileau.com")!
    var name = "Laurent Boileau"
    var description = "Software developer in Montréal, Canada"
    var language: Language { .english }
    var imagePath: Path? { nil }
    var favicon: Favicon? { .init(path: "/assets/images/favicon.png") }
}

try LaurentBoileau().publish(
    withTheme: .laurentboileau,
    deployedUsing: .gitHub("laurentboileau/laurentboileau.github.io", branch: "main")
)
