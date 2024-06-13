import Foundation

struct ArticlesResponse: Codable, Equatable {
    let status: String
    let copyright: String
    let section: String
    let lastUpdated: String
    let numResults: Int
    let results: [Article]
    
    enum CodingKeys: String, CodingKey {
        case status
        case copyright
        case section
        case lastUpdated = "last_updated"
        case numResults = "num_results"
        case results
    }
}
