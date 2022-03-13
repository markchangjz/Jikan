import UIKit

class FavoritesViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(FavoriteTableViewCell.self, forCellReuseIdentifier: FavoriteTableViewCell.identifier())
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var collectedMovies = DataPersistence.collectedMovies()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectedMovies.reverse()
        configureView()
        addObserver()
    }
    
}

// MARK: UITableViewDelegate & UITableViewDataSource
extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collectedMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteTableViewCell.identifier(), for: indexPath) as! FavoriteTableViewCell
        
        cell.nameLabel.text = collectedMovies[indexPath.row].title
        cell.coverImageView.sd_setImage(with: URL(string: collectedMovies[indexPath.row].image))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentWebView(collectedMovies[indexPath.row].url)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deleteID = collectedMovies[indexPath.row].id
            DataPersistence.removeCollectedMovie(withTrackId: deleteID)
            collectedMovies.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

// MARK: Observer
extension FavoritesViewController {
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshTableViewData(_:)), name: NSNotification.Name.MKCCollectedMovieDidChange, object: nil)
    }
    
    @objc private func refreshTableViewData(_ notification: Notification) {
        
        if let navigationController = tabBarController?.selectedViewController as? UINavigationController,
            navigationController.viewControllers.last == self {
            return
        }
        
        collectedMovies = DataPersistence.collectedMovies()
        collectedMovies.reverse()
        tableView.reloadData()
    }
}

// MARK: Private
extension FavoritesViewController {
    
    private func presentWebView(_ url: String) {
        let webViewController = WebViewController()
        webViewController.loadURLString(url)
        let webViewNavigationController = UINavigationController(rootViewController: webViewController)
        present(webViewNavigationController, animated: true)
    }
}

// MARK: UI Layout
extension FavoritesViewController {
    
    private func configureView() {
        view.addSubview(tableView)
        
        layoutViews()
    }
    
    private func layoutViews() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}
