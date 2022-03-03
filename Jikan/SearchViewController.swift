import UIKit

enum UIState {
    case loading
    case finish
    case error(message: String)
}

class SearchViewController: UIViewController {
    
    var type: String?
    var subtype: String?
    var page: Int = 1
    var entities = [TopEntityModel]()
    
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
    
    private lazy var loadingIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        
        state = .loading
        
        MKCRequestAPI.shared().top(withType: type, subtype: subtype, page: 1) { response, responseObject in
            
            guard let responseObject = responseObject else {
                self.state = .error(message: "parse error")
                return
            }
            
            do {
                let responseData = try JSONSerialization.data(withJSONObject: responseObject, options: .prettyPrinted)
                let model = try JSONDecoder().decode(TopModel.self, from: responseData)
                if let entities = model.entities {
                    self.entities += entities
                }
                self.tableView.reloadData()
                self.state = .finish
            } catch {
                self.state = .error(message: "parse error")
            }
        } failureHandler: { error in
            self.state = .error(message: error?.localizedDescription ?? "Something wrong")
        }
    }
}

// MARK: UITableViewDelegate & UITableViewDataSource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entities.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MKCTopRatedTableViewCell.identifier(), for: indexPath) as! MKCTopRatedTableViewCell
        cell.selectionStyle = .none
        cell.configure(with: entities[indexPath.row])
        
        return cell
    }
}

// MARK: UI Layout
extension SearchViewController {
    
    private func configureView() {
        title = "Result"
        view.backgroundColor = .white
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
            break
        case .finish:
            loadingIndicatorView.stopAnimating()
            tableView.isHidden = false
            break
        case .error(message: let message):
            loadingIndicatorView.stopAnimating()
            tableView.isHidden = true
            break
        }
    }
}
