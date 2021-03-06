/*
 Add Load More Data Function into UITableView
 https://medium.com/@quangtqag/how-to-add-load-more-data-function-into-uitableview-a622e0282703
 
 How to add Load More / Infinite Scrolling in iOS using Swift
 https://johncodeos.com/how-to-add-load-more-infinite-scrolling-in-ios-using-swift/
 */

import UIKit

enum UIState {
    case loading
    case loadMoreLoading
    case partialLoaded
    case fullyLoaded
    case error(message: String)
}

enum APIResponseError: Error {
    case JSONFormatUnexpectable
    case unreachable
}

class TopRatedViewController: UIViewController {
    
    init(requestAPI: RequestAPI = RequestAPI.shared()) {
        super.init(nibName: nil, bundle: nil)
        self.requestAPI = requestAPI
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var type: String?
    var subtype: String?
    private var requestAPI: RequestAPI?
    private var data = [TopEntityModel]()
    private var fetchingPosition = 1
    
    private var state: UIState = .loading {
        didSet {
            OperationQueue.main.addOperation {
                self.configureStateView()
            }
        }
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.isHidden = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TopRatedTableViewCell.self, forCellReuseIdentifier: TopRatedTableViewCell.identifier())
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var activityIndicator = LoadMoreActivityIndicator(scrollView:tableView, spacingFromLastCell:10, spacingFromLastCellWhenLoadMoreActionStart:60)
    
    private lazy var loadingIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        addObserver()
        fetchData()
    }
}

// MARK: API
extension TopRatedViewController {
    
    private func fetchData() {
        
        if case .fullyLoaded = state {
            return
        }
        
        state = (fetchingPosition == 1) ? .loading : .loadMoreLoading
        
        fetchData(page: fetchingPosition) { result in
            switch result {
            case .success(let newData):
                self.insertNewData(newData)
                
                if newData.count == 0 {
                    self.state = .fullyLoaded
                } else {
                    self.state = .partialLoaded
                }
            case .failure(let error):
                var message = error.localizedDescription
                if error as? APIResponseError == APIResponseError.JSONFormatUnexpectable {
                    message = "Try again later"
                } else if error as? APIResponseError == APIResponseError.unreachable {
                    message = "Network connection lost"
                }
                
                self.state = .error(message: message)
            }
        }
    }
    
    private func insertNewData(_ newData: [TopEntityModel]) {
        if (newData.count > 0) {
            var newIndexPaths = [IndexPath]()
            for rowPosition in 0..<newData.count {
                let newIndexPath = IndexPath(row: self.data.count + rowPosition, section: 0)
                newIndexPaths.append(newIndexPath)
            }
            self.data += newData
            self.tableView.insertRows(at: newIndexPaths, with: .automatic)
        }
    }
    
    private func fetchData(page: Int, handler: ((Result<[TopEntityModel], Error>) -> Void)?) {
        
        self.requestAPI?.top(withType: type, subtype: subtype, page: page) { response, responseObject in
            
            guard let responseObject = responseObject else {
                handler?(.failure(APIResponseError.JSONFormatUnexpectable))
                return
            }
            
            do {
                let responseData = try JSONSerialization.data(withJSONObject: responseObject, options: .prettyPrinted)
                let model = try JSONDecoder().decode(TopModel.self, from: responseData)
                if let data = model.entities {
                    self.fetchingPosition += 1
                    handler?(.success(data))
                } else {
                    handler?(.success([]))
                }
            } catch {
                handler?(.failure(APIResponseError.JSONFormatUnexpectable))
            }
        } failureHandler: { error in
            let isReachedEnd = (error as NSError?)?.code == NSURLErrorBadServerResponse
            if isReachedEnd {
                handler?(.success([]))
            } else {
                handler?(.failure(APIResponseError.unreachable))
            }
        }
    }
}

// MARK: UITableViewDelegate & UITableViewDataSource
extension TopRatedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TopRatedTableViewCell.identifier(), for: indexPath) as! TopRatedTableViewCell
        cell.tag = indexPath.row
        cell.delegate = self
        cell.configure(with: data[indexPath.row])
                
        let trackId = "\(data[indexPath.row].id)"
        cell.isCollected = DataPersistence.hasCollectdMovie(withTrackId: trackId)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = data[indexPath.row].url {
            presentWebView(url)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row == data.count - 1) {
            fetchData()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if case .partialLoaded = state {
            return
        }
        if case .fullyLoaded = state {
            return
        }
        
        activityIndicator.start(closure: nil)
    }
}

// MARK: TopRatedTableViewCellDelegate
extension TopRatedViewController: TopRatedTableViewCellDelegate {
    
    func tableViewCell(_ topRatedTableViewCell: TopRatedTableViewCell!, collectItemAt index: Int) {
        let trackId = "\(data[index].id)"
        
        if DataPersistence.hasCollectdMovie(withTrackId: trackId) {
            DataPersistence.removeCollectedMovie(withTrackId: trackId)
        } else {
            // Jikan API docs: Bulk Requests, You MUST use a delay of 4 (FOUR) SECONDS between each request
            let item = FavoriteItem(topItem: data[index])
            DataPersistence.collectMovie(with: item)
        }
        
        let indexPath = IndexPath(row: index, section: 0)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}

// MARK: Private
extension TopRatedViewController {
    
    private func presentWebView(_ url: String) {
        let webViewController = WebViewController()
        webViewController.loadURLString(url)
        let webViewNavigationController = UINavigationController(rootViewController: webViewController)
        present(webViewNavigationController, animated: true)
    }
    
    private func presentErrorAlert(message: String) {
        let feedbackGenerator = UINotificationFeedbackGenerator()
        feedbackGenerator.prepare()
        
        let alert = UIAlertController(title: "Ooops", message: message, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "Close", style: .cancel)
        let retryAction = UIAlertAction(title: "Retry", style: .default) { _ in
            self.fetchData()
        }
        alert.addAction(closeAction)
        alert.addAction(retryAction)
        present(alert, animated: true) {
            feedbackGenerator.notificationOccurred(.error)
        }
    }
}

// MARK: Observer
extension TopRatedViewController {
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshTableViewData(_:)), name: NSNotification.Name.MKCCollectedMovieDidChange, object: nil)
    }
    
    @objc private func refreshTableViewData(_ notification: Notification) {
        
        if let navigationController = tabBarController?.selectedViewController as? UINavigationController,
            navigationController.viewControllers.last == self {
            return
        }
        
        tableView.reloadData()
    }
}

// MARK: UI Layout
extension TopRatedViewController {
    
    private func configureView() {
        title = "Result"
        view.backgroundColor = .systemBackground
        view.addSubview(loadingIndicatorView)
        view.addSubview(tableView)
        
        layoutViews()
    }
    
    private func layoutViews() {
        NSLayoutConstraint.activate([
            loadingIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func configureStateView() {
        switch state {
        case .loading:
            loadingIndicatorView.startAnimating()
            tableView.isHidden = true
            activityIndicator.stop()
        case .loadMoreLoading:
            loadingIndicatorView.stopAnimating()
            tableView.isHidden = false
            activityIndicator.start(closure: nil)
        case .partialLoaded:
            loadingIndicatorView.stopAnimating()
            tableView.isHidden = false
            activityIndicator.stop()
        case .fullyLoaded:
            loadingIndicatorView.stopAnimating()
            tableView.isHidden = false
            activityIndicator.stop()
        case .error(message: let message):
            loadingIndicatorView.stopAnimating()
            tableView.isHidden = false
            activityIndicator.stop()
            presentErrorAlert(message: message)
        }
    }
}

#if DEBUG

// For unit test
extension TopRatedViewController {
    
    public var expose_state: UIState {
        self.state
    }
    
    public func expose_fetchData() {
        self.fetchData()
    }
}
#endif
