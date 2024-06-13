import UIKit

final class RemoteImageView: UIImageView {
    
    // MARK: - Init/Deinit
    
    init(networkClient: NetworkClient = NetworkService.provideNetworkClient()) {
        self.networkClient = networkClient
        super.init(frame: .zero)
        contentMode = .scaleAspectFill
        clipsToBounds = true
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal
    
    var url: URL? {
        didSet {
            guard url != oldValue else { return }
            // task?.cancel()
            image = nil
            placeholderView.show()
            Task.detached { [weak self] in
                await self?.fetchImage()
            }
        }
    }
    
    // MARK: - Private
    
    private let networkClient: NetworkClient
    
    private lazy var placeholderView: PlaceholderView = {
        let view = PlaceholderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private func setup() {
        addSubview(placeholderView)
        NSLayoutConstraint.activate([
            placeholderView.leadingAnchor.constraint(equalTo: leadingAnchor),
            placeholderView.trailingAnchor.constraint(equalTo: trailingAnchor),
            placeholderView.topAnchor.constraint(equalTo: topAnchor),
            placeholderView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func fetchImage() async {
        guard let url else { return }
        
        do {
            let data = try await networkClient.request(url: url, refresh: false)
            
            guard let image = UIImage(data: data) else {
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.image = image
                self?.placeholderView.hide()
            }
        } catch {
            
        }
    }
}

private final class PlaceholderView: UIView {
    
    // MARK: - Init

    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal
    
    func show() {
        activityIndicatorView.startAnimating()
        isHidden = false
    }
    
    func hide() {
        activityIndicatorView.stopAnimating()
        isHidden = true
    }
    
    // MARK: - Private
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.color = .tertiaryLabel
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private func setup() {
        backgroundColor = .systemGroupedBackground
        addSubview(activityIndicatorView)
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
