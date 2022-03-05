import UIKit

class FavoritesViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MKCFavoriteTableViewCell.self, forCellReuseIdentifier: MKCFavoriteTableViewCell.identifier())
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private var collectedMovies: [String: [String: String]] {
        MKCDataPersistence.collectedMovies()
    }
    
    private lazy var IDs = collectedMovies.keys.map { $0 }
    private lazy var values = collectedMovies.values.map { $0 }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        addObserver()
    }
    
}

// MARK: UITableViewDelegate & UITableViewDataSource
extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MKCFavoriteTableViewCell.identifier(), for: indexPath) as! MKCFavoriteTableViewCell
        cell.selectionStyle = .none
        
        cell.nameLabel.text = values[indexPath.row]["title"]
        if let image = values[indexPath.row]["image"] {
            cell.coverImageView.sd_setImage(with: URL(string: image))
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deleteID = IDs[indexPath.row]
            
            if let index = IDs.firstIndex(of: deleteID) {
                MKCDataPersistence.removeCollectedMovie(withTrackId: deleteID)
                IDs.remove(at: index)
                values.remove(at: index)
                
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
}

// MARK: Observer
extension FavoritesViewController {
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshTableViewData), name: NSNotification.Name.MKCCollectedMovieDidChange, object: nil)
    }
    
    @objc private func refreshTableViewData() {
        
        if let navigationController = tabBarController?.selectedViewController as? UINavigationController,
            navigationController.viewControllers.last == self {
            return
        }
        
        IDs = collectedMovies.keys.map { $0 }
        values = collectedMovies.values.map { $0 }
        tableView.reloadData()
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
