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
                IndexItems(context: context)
                SiteFooter()
            }
        )
    }

    func makeSectionHTML(for section: Section<Site>,
                         context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: section, on: context.site, titleSeparator: " — "),
            .body {
                SiteHeader(context: context)
                SectionItems(section: section, site: context.site)
                SiteFooter()
            }
        )
    }

    func makeItemHTML(for item: Item<Site>,
                      context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: item, on: context.site, titleSeparator: " — "),
            .body {
                SiteHeader(context: context)
                SiteItemPage(item: item)
                SiteFooter()
            }
        )
    }

    func makePageHTML(for page: Page,
                      context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: page, on: context.site, titleSeparator: " — "),
            .body {
                SiteHeader(context: context)
                SitePage(page: page)
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

private struct IndexItems<Site: Website>: Component {
    var context: PublishingContext<Site>

    private var items: [Item<Site>] {
        context.allItems(sortedBy: \.date, order: .descending)
    }

    var body: Component {
        MainElement {
            Wrapper {
                SectionElement {
                    heading
                    indexItems
                }
            }
        }
    }

    private var heading: Component {
        H2("Blog posts")
    }

    private var indexItems: Component {
        List(items) { item in
            Div {
                Span(DateFormatter.indexItem.string(from: item.date))
                Link(item.title, url: item.path.absoluteString)
            }
        }
        .id("index-items")
    }
}

private struct SectionItems<Site: Website>: Component {
    var section: Section<Site>
    var site: Site

    private var items: [Item<Site>] {
        section.items.sorted {
            $0[keyPath: \.date] > $1[keyPath: \.date]
        }
    }

    var body: Component {
        MainElement {
            Wrapper {
                SectionElement {
                    heading
                    sectionItems
                }
            }
        }
    }

    private var heading: Component {
        H2("Posts")
    }

    private var sectionItems: Component {
        List(items) { item in
            Article {
                H2(Link(item.title, url: item.path.absoluteString))
                Paragraph(item.description)
                TimeElement {
                    Link(DateFormatter.item.string(from: item.date), url: item.path.absoluteString)
                }
                .datetime(item.date)
            }
        }
        .id("section-items")
    }
}

private struct SiteFooter: Component {
    private struct Separator: Component {
        var body: Component {
            Span("/").class("separator")
        }
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
            Link("Glass", url: "https://glass.photo/laurentboileau")
            Separator()
            Link("Mastodon", url: "https://mastodon.social/@laurentboileau")
                .attribute(named: "rel", value: "me")
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
        Paragraph("© \(DateFormatter.copyright.string(from: Date.now))")
            .id("site-info")
    }
}

private struct SitePage: Component {
    var page: Page

    var body: Component {
        MainElement {
            Wrapper {
                Article {
                    header
                    content
                }
                .class("page")
            }
        }
    }

    private var header: Component {
        Header {
            H2(page.title)
        }
    }

    private var content: Component {
        page.body
    }
}

private struct SiteItemPage<Site: Website>: Component {
    var item: Item<Site>

    var body: Component {
        MainElement {
            Wrapper {
                Article {
                    header
                    item.body
                    footer
                }
                .class("post")
            }
        }
    }

    private var header: Component {
        Header {
            H2(item.title)
        }
    }

    private var footer: Component {
        Footer {
            TimeElement {
                Link(DateFormatter.item.string(from: item.date), url: item.path.absoluteString)
            }
            .datetime(item.date)
        }
    }
}

// MARK: - Date Formatters

private extension DateFormatter {
    static let indexItem: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        formatter.timeZone = .current
        return formatter
    }()

    static let item: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, YYYY"
        formatter.timeZone = .current
        return formatter
    }()

    static let copyright: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        formatter.timeZone = .current
        return formatter
    }()
}
