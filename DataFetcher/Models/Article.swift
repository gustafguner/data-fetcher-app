import Foundation

struct Article: Codable, Equatable {
    let section: String
    let subsection: String
    let title: String
    let abstract: String
    let url: String
    let uri: String
    let byline: String
    let itemType: String
    let updatedDate: String
    let createdDate: String
    let publishedDate: String
    let materialTypeFacet: String?
    let kicker: String
    let desFacet: [String]
    let orgFacet: [String]
    let perFacet: [String]
    let geoFacet: [String]
    let multimedia: [Multimedia]
    let shortUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case section
        case subsection
        case title
        case abstract
        case url
        case uri
        case byline
        case itemType = "item_type"
        case updatedDate = "updated_date"
        case createdDate = "created_date"
        case publishedDate = "published_date"
        case materialTypeFacet = "material_type_facet"
        case kicker
        case desFacet = "des_facet"
        case orgFacet = "org_facet"
        case perFacet = "per_facet"
        case geoFacet = "geo_facet"
        case multimedia
        case shortUrl = "short_url"
    }
}
