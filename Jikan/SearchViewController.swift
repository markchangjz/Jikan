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
    case loadMoreFinish
    case partialLoaded
    case fullyLoaded
    case error(message: String)
}

enum APIResponseError: Error {
    case JSONFormatUnexpectable
    case unreachable
}

class SearchViewController: UIViewController {
    
    var type: String?
    var subtype: String?
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
        tableView.register(MKCTopRatedTableViewCell.self, forCellReuseIdentifier: MKCTopRatedTableViewCell.identifier())
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
        
        fetchData()
    }
}

// MARK: API
extension SearchViewController {
    
    private func fetchData() {
        
        state = (fetchingPosition == 1) ? .loading : .loadMoreLoading
        
        fetchData(page: fetchingPosition) { result in
            switch result {
            case .success(let newData):
                self.insertNewData(newData: newData)
                
                if newData.count == 0 {
                    self.state = .fullyLoaded
                } else {
                    self.state = (self.fetchingPosition == 2) ? .partialLoaded : .loadMoreFinish
                }
            case .failure(let error):
                self.state = .error(message: error.localizedDescription)
            }
        }
    }
    
    private func insertNewData(newData: [TopEntityModel]) {
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
        
        MKCRequestAPI.shared().top(withType: type, subtype: subtype, page: page) { response, responseObject in
            
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
                    handler?(.success([])) // TODO: Error handle ?
                }
            } catch {
                handler?(.failure(APIResponseError.JSONFormatUnexpectable))
            }
        } failureHandler: { error in
            handler?(.success([])) // TODO: fullyLoaded
        }
    }
}

// MARK: UITableViewDelegate & UITableViewDataSource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MKCTopRatedTableViewCell.identifier(), for: indexPath) as! MKCTopRatedTableViewCell
        cell.configure(with: data[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = data[indexPath.row].url {
            presentViewView(url)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row == data.count - 1) {
            fetchData()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if case .fullyLoaded = state {
            return
        }
        
        activityIndicator.start(closure: nil)
    }
}

// MARK: Private
extension SearchViewController {
    
    private func presentViewView(_ url: String) {
        let webViewController = MKCWebViewController()
        webViewController.loadURLString(url)
        let webViewNavigationController = UINavigationController(rootViewController: webViewController)
        present(webViewNavigationController, animated: true)
    }
}

// MARK: UI Layout
extension SearchViewController {
    
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
            break
        case .loadMoreLoading:
            loadingIndicatorView.stopAnimating()
            tableView.isHidden = false
            activityIndicator.start(closure: nil)
            break
        case .loadMoreFinish:
            loadingIndicatorView.stopAnimating()
            tableView.isHidden = false
            activityIndicator.stop()
            break
        case .partialLoaded:
            loadingIndicatorView.stopAnimating()
            tableView.isHidden = false
            activityIndicator.stop()
        case .fullyLoaded:
            loadingIndicatorView.stopAnimating()
            tableView.isHidden = false
            activityIndicator.stop()
            break
        case .error(message: let message):
            loadingIndicatorView.stopAnimating()
            tableView.isHidden = true
            activityIndicator.stop()
            break
        }
    }
}
