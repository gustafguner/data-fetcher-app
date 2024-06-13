@testable import DataFetcher
import Foundation

extension ArticlesResponse {
    static func mock(
        status: String = "status",
        copyright: String = "copyright",
        section: String = "section",
        lastUpdated: String = "lastUpdated",
        numResults: Int = 1,
        results: [Article] = []
    ) -> Self {
        .init(
            status: status,
            copyright: copyright,
            section: section,
            lastUpdated: lastUpdated,
            numResults: numResults,
            results: results
        )
    }
}
