import Foundation

final class HomeViewModel {
    
    // MARK: - Init

    init(newsClient: NewsClient = WebAPIService.provideNewsClient()) {
        self.newsClient = newsClient
    }

    // MARK: - Internal
    
    /// The title of the page.
    let navigationTitle: String = "Tech News"
    
    /// The number of articles.
    var numberOfArticles: Int { data.count }
    
    enum Result {
        /// Result was successful.
        /// - Parameter changed: Whether the data changed from before.
        case success(changed: Bool)
        /// Result resolved with an error.
        /// - Parameter error: The error.
        case failed(error: Error)
    }
    
    /// A closure which is invoked after the loading of articles is complete.
    var didFinishLoadingArticles: ((Result) -> Void)?
    
    /// Retrieves the table view cell model at a given index.
    /// - Parameter index: The index to retrieve the model from.
    /// - Returns: The table view cell model.
    ///
    /// - Warning: It is the consumer’s responsibility to only request articles for valid indicies.
    func cellModel(at index: Int) -> HomeTableViewCellModel {
        HomeTableViewCellModel(article: article(at: index))
    }
    
    /// Retrieves the article at a given index.
    /// - Parameter index: The index to retrieve data from.
    /// - Returns: The article.
    ///
    /// - Warning: It is the consumer’s responsibility to only request articles for valid indicies.
    func article(at index: Int) -> Article {
        data[index]
    }
    
    /// Starts fetching news articles.
    /// - Parameter refresh: Whether the request should refresh the data, effecticely ignorig any cache. Defaults to `false`.
    func loadArticles(refresh: Bool = false) {
        Task.detached { [weak self] in
            guard let self else { return }
            do {
                let articles = try await self.newsClient.getArticles(refresh: refresh)
                
                let newData = articles.results.sorted {
                    $0.publishedDate > $1.publishedDate
                }
                let changed = newData != self.data
                self.data = newData
                self.didFinishLoadingArticles?(.success(changed: changed))
            } catch {
                self.didFinishLoadingArticles?(.failed(error: error))
            }
        }
    }
    
    // MARK: - Private
    
    private let newsClient: NewsClient
    private var data = [Article]()
}

struct HomeTableViewCellModel: Equatable {
    let title: String
    let imageURL: URL?
    let publishDate: Date?
    
    init(article: Article) {
        title = article.title
        
        let sortedMultimedia = article.multimedia.sorted {
            $0.width * $0.height > $1.width * $1.height
        }
        
        if let smallestMultimedia = sortedMultimedia.last {
            imageURL = URL(string: smallestMultimedia.url)
        } else {
            imageURL = nil
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        dateFormatter.timeZone = TimeZone.current
        publishDate = dateFormatter.date(from: article.publishedDate)
    }
}
