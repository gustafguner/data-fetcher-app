import Foundation

final class ArticleViewModel {

    // MARK: - Init

    init(article: Article) {
        self.article = article
    }
    
    // MARK: - Internal
    
    /// The title.
    var title: String { article.title }
    
    /// The author.
    var author: String { article.byline }
    
    /// The publish date.
    var publishDate: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.date(from: article.publishedDate)
    }
    
    /// The description.
    var description: String { article.abstract }

    /// The image URL. Uses the first media object found.
    var imageURL: URL? {
        guard let multimedia = article.multimedia.first else {
            return nil
        }
        
        return URL(string: multimedia.url)
    }

    /// An external URL to the full article.
    var externalURL: URL? { .init(string: article.url) }
    
    // MARK: - Private
    
    private let article: Article
}
