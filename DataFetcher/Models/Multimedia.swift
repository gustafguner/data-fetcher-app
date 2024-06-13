import Foundation

struct Multimedia: Codable, Equatable {
    let url: String
    let format: String
    let height: Int
    let width: Int
    let type: String
    let subtype: String
    let caption: String?
    let copyright: String
}
