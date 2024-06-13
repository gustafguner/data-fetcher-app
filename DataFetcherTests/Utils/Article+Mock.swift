@testable import DataFetcher
import Foundation

extension Article {
    static func mock(
        section: String = "section",
        subsection: String = "subsection",
        title: String = "title",
        abstract: String = "abstract",
        url: String = "https://example.com/article",
        uri: String = "uri",
        byline: String = "byline",
        itemType: String = "itemType",
        updatedDate: String = "2023-01-01T00:00:00Z",
        createdDate: String = "2023-01-01T00:00:00Z",
        publishedDate: String = "2023-01-01T00:00:00Z",
        materialTypeFacet: String? = nil,
        kicker: String = "kicker",
        desFacet: [String] = [],
        orgFacet: [String] = [],
        perFacet: [String] = [],
        geoFacet: [String] = [],
        multimedia: [Multimedia] = [],
        shortUrl: String? = nil
    ) -> Self {
        return .init(
            section: section,
            subsection: subsection,
            title: title,
            abstract: abstract,
            url: url,
            uri: uri,
            byline: byline,
            itemType: itemType,
            updatedDate: updatedDate,
            createdDate: createdDate,
            publishedDate: publishedDate,
            materialTypeFacet: materialTypeFacet,
            kicker: kicker,
            desFacet: desFacet,
            orgFacet: orgFacet,
            perFacet: perFacet,
            geoFacet: geoFacet,
            multimedia: multimedia,
            shortUrl: shortUrl
        )
    }
}
