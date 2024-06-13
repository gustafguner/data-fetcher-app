import UIKit

final class HomeTableViewCell: UITableViewCell {

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UITableViewCell
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        remoteImageView.url = nil
    }
    
    // MARK: - Internal
    
    func configure(with model: HomeTableViewCellModel) {
        remoteImageView.url = model.imageURL
        titleLabel.text = model.title
        
        if let publishDate = model.publishDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            publishDateLabel.text = dateFormatter.string(from: publishDate)
        } else {
            publishDateLabel.text = nil
        }
    }
    
    // MARK: - Private
    
    private func setup() {
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
        
        stackView.addArrangedSubview(remoteImageView)
        stackView.addArrangedSubview(textStackView)
        
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(publishDateLabel)
    }
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .top
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private lazy var publishDateLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var remoteImageView: RemoteImageView = {
        let remoteImageView = RemoteImageView()
        remoteImageView.translatesAutoresizingMaskIntoConstraints = false
        remoteImageView.layer.cornerRadius = 4
        
        NSLayoutConstraint.activate([
            remoteImageView.widthAnchor.constraint(equalToConstant: 48),
            remoteImageView.heightAnchor.constraint(equalToConstant: 48),
        ])
        
        return remoteImageView
    }()
}
