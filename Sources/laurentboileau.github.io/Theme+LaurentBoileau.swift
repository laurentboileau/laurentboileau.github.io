import Foundation
import Plot
import Publish

public extension Theme {
    static var laurentboileau: Self {
        Theme(
            htmlFactory: LaurentBoileauHTMLFactory(),
            resourcePaths: ["Resources/assets/css/styles.css"]
        )
    }
}

private struct LaurentBoileauHTMLFactory<Site: Website>: HTMLFactory {
    func makeIndexHTML(for index: Index,
                       context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: index, on: context.site),
            .body {
                SiteHeader(context: context)
                IndexBlogPosts(context: context)
                SiteFooter()
            }
        )
    }

    func makeSectionHTML(for section: Section<Site>,
                         context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: section, on: context.site),
            .body {
                SiteHeader(context: context)
                Wrapper {
                    H1(section.title)
                    ItemList(items: section.items, site: context.site)
                }
                SiteFooter()
            }
        )
    }

    func makeItemHTML(for item: Item<Site>,
                      context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: item, on: context.site),
            .body(
                .class("item-page"),
                .components {
                    SiteHeader(context: context)
                    Wrapper {
                        Article {
                            Div(item.content.body).class("content")
                            Span("Tagged with: ")
                            ItemTagList(item: item, site: context.site)
                        }
                    }
                    SiteFooter()
                }
            )
        )
    }

    func makePageHTML(for page: Page,
                      context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: page, on: context.site),
            .body {
                SiteHeader(context: context)
                Wrapper(page.body)
                SiteFooter()
            }
        )
    }

    func makeTagListHTML(for page: TagListPage,
                         context: PublishingContext<Site>) throws -> HTML? {
        nil
    }

    func makeTagDetailsHTML(for page: TagDetailsPage,
                            context: PublishingContext<Site>) throws -> HTML? {
        nil
    }
}

private struct Wrapper: ComponentContainer {
    @ComponentBuilder var content: ContentProvider

    var body: Component {
        Div(content: content).class("wrapper")
    }
}

private struct SiteHeader<Site: Website>: Component {
    var context: PublishingContext<Site>

    var body: Component {
        Header {
            Wrapper {
                heading
                description
                learnMore
            }
        }
        .id("main-header")
    }
    
    private var heading: Component {
        H1(
            Link(context.site.name, url: "/")
                .class("site-title")
        )
    }
    
    private var description: Component {
        Paragraph(context.site.description)
    }
    
    private var learnMore: Component {
        Paragraph(
            Link("Learn more", url: "/about")
        )
    }
}

private struct IndexBlogPosts<Site: Website>: Component {
    var context: PublishingContext<Site>

    private var items: [Item<Site>] {
        context.allItems(sortedBy: \.date, order: .descending)
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter
    }

    var body: Component {
        MainElement {
            Wrapper {
                SectionElement {
                    heading
                    posts
                }
                .id("posts")
            }
        }
    }

    private var heading: Component {
        H2("Blog posts")
    }

    private var posts: Component {
        List(items) { item in
            Div {
                Span(dateFormatter.string(from: item.date))
                Link(item.title, url: item.path.absoluteString)
            }
        }
        .id("posts-list")
    }
}

private struct ItemList<Site: Website>: Component {
    var items: [Item<Site>]
    var site: Site

    var body: Component {
        List(items) { item in
            Article {
                H1(Link(item.title, url: item.path.absoluteString))
                ItemTagList(item: item, site: site)
                Paragraph(item.description)
            }
        }
        .class("item-list")
    }
}

private struct ItemTagList<Site: Website>: Component {
    var item: Item<Site>
    var site: Site

    var body: Component {
        List(item.tags) { tag in
            Link(tag.string, url: site.path(for: tag).absoluteString)
        }
        .class("tag-list")
    }
}

private struct SiteFooter: Component {
    private struct Separator: Component {
        var body: Component {
            Span("/").class("separator")
        }
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }

    var body: Component {
        Footer {
            Wrapper {
                projects
                elsewhere
                syndication
                siteInfo
            }
        }
        .id("colophon")
    }

    private var projects: Component {
        Navigation {
            Link("Stations for iPhone", url: "https://stationsmontreal.app")
        }
        .id("project-nav")
    }

    private var elsewhere: Component {
        Navigation {
            Link("GitHub", url: "https://github.com/laurentboileau")
            Separator()
            Link("Twitter", url: "https://twitter.com/laurentboileau")
        }
        .id("elsewhere-nav")
    }

    private var syndication: Component {
        Navigation {
            Link("RSS", url: "/feed.rss")
        }
        .id("syndication-nav")
    }

    private var siteInfo: Component {
        Paragraph("© \(dateFormatter.string(from: Date.now))")
            .id("site-info")
    }
}
