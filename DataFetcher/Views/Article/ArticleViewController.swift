import UIKit

final class ArticleViewController: UIViewController {
    
    // MARK: - Init
    
    init(viewModel: ArticleViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = nil
        navigationItem.largeTitleDisplayMode = .never
        setup()
    }
    
    // MARK: - Private
    
    private func setup() {
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        [imageView, titleLabel, authorLabel, publishDateLabel, descriptionLabel, externalURLButton]
            .compactMap { $0 }
            .forEach { stackView.addArrangedSubview($0) }
    }
    
    private let viewModel: ArticleViewModel
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    private lazy var imageView: RemoteImageView = {
        let imageView = RemoteImageView()
        imageView.url = viewModel.imageURL
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 240),
        ])
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = viewModel.title
        label.font = UIFont.boldSystemFont(ofSize: 26)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel(frame: .zero)
        
        let symbolAttachment = NSTextAttachment()
        symbolAttachment.image = UIImage(systemName: "person.fill")?.withRenderingMode(.alwaysTemplate)
        let attributedString = NSAttributedString(attachment: symbolAttachment)
        
        let text = NSMutableAttributedString(attributedString: attributedString)
        text.append(NSAttributedString(string: " \(viewModel.author)"))
        
        label.attributedText = text
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var publishDateLabel: UILabel? = {
        guard let publishDate = viewModel.publishDate else { return nil }
        
        let label = UILabel(frame: .zero)
        
        let symbolAttachment = NSTextAttachment()
        symbolAttachment.image = UIImage(systemName: "clock.fill")?.withRenderingMode(.alwaysTemplate)
        let attributedString = NSAttributedString(attachment: symbolAttachment)
        
        let text = NSMutableAttributedString(attributedString: attributedString)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = dateFormatter.string(from: publishDate)
        text.append(NSAttributedString(string: " \(dateString)"))
        
        label.attributedText = text
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = viewModel.description
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var externalURLButton: UIButton? = {
        guard viewModel.externalURL != nil else { return nil }
        let button = UIButton(type: .system)
        var configuration = UIButton.Configuration.bordered()
        configuration.title = "Full article"
        configuration.image = UIImage(systemName: "safari")?.withRenderingMode(.alwaysTemplate)
        configuration.imagePadding = 8
        button.configuration = configuration
        button.addTarget(self, action: #selector(didTapExternalURLButton(_:)), for: .touchUpInside)
        return button
    }()
    
    @objc private func didTapExternalURLButton(_ sender: UIButton) {
        guard let url = viewModel.externalURL else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
