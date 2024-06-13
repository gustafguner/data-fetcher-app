import UIKit

final class HomeViewController: UIViewController {
    
    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = HomeViewModel()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        title = viewModel.navigationTitle
        view.addSubview(tableView)

        viewModel.didFinishLoadingArticles = { [weak self] result in
            switch result {
            case .success(let changed):
                if changed {
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                }
            case .failed(let error):
                DispatchQueue.main.async {
                    self?.alertManager.presentAlert(title: "Network Error", message: error.localizedDescription)
                }
            }

            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
            }
        }
        viewModel.loadArticles()
    }
    
    // MARK: - Private
    
    private var viewModel: HomeViewModel!
    private let alertManager = AlertService.provideAlertManager()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 64
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.refreshControl = refreshControl
        return tableView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        return refreshControl
    }()
    
    @objc private func refreshData(_ sender: UIRefreshControl) {
        viewModel.loadArticles(refresh: true)
    }
    
    private func loadArticles(refresh: Bool = false) {
        
    }
}

// MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = viewModel.article(at: indexPath.row)
        let articleViewModel = ArticleViewModel(article: article)
        let articleViewController = ArticleViewController(viewModel: articleViewModel)
        navigationController?.pushViewController(articleViewController, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfArticles
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeTableViewCell
        let cellModel = viewModel.cellModel(at: indexPath.row)
        cell.configure(with: cellModel)
        return cell
    }
}
