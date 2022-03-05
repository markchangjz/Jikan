import UIKit

class FilterViewController: UIViewController {
    
    typealias Option = (name: String, value: String, subOption: [SubOption])
    typealias SubOption = (name: String, value: String)
    
    private let options = [
        Option("Anime", "anime", [
            ("Airing", "airing"),
            ("Upcoming", "upcoming"),
            ("TV", "tv"),
            ("Movie", "movie"),
            ("Ova", "ova"),
            ("Special", "special"),
            ("Bypopularity", "bypopularity"),
            ("Favorite", "favorite"),
        ]),
        Option("Manga", "manga", [
            ("Manga", "manga"),
            ("Novels", "novels"),
            ("One shots", "oneshots"),
            ("Doujin", "doujin"),
            ("Manhwa", "manhwa"),
            ("Manhua", "manhua"),
            ("Bypopularity", "bypopularity"),
            ("Favorite", "favorite"),
        ]),
    ]
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MKCBasicTableViewCell.self, forCellReuseIdentifier: MKCBasicTableViewCell.identifier())
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private var selectedTypeIndex: Int = 0
    private var selectedSubtypeIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }
    
    @IBAction func searchButtonDidTap(_ sender: UIBarButtonItem) {
        let selectedType = options[selectedTypeIndex].value
        let selectedSubtype = options[selectedTypeIndex].subOption[selectedSubtypeIndex].value
        
        let searchViewController = SearchViewController()
        searchViewController.type = selectedType
        searchViewController.subtype = selectedSubtype
//        searchViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(searchViewController, animated: true)
    }
}

// MARK: UITableViewDelegate & UITableViewDataSource
extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "type"
        } else {
            return "subtype"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return options.count
        } else {
            return options[selectedTypeIndex].subOption.map { $0.name }.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MKCBasicTableViewCell.identifier(), for: indexPath) as! MKCBasicTableViewCell
        cell.selectionStyle = .none
        
        if indexPath.section == 0 {
            cell.textLabel?.text = options.map { $0.name }[indexPath.row]
            cell.accessoryType = (indexPath.row == selectedTypeIndex) ? .checkmark : .none
        } else {
            cell.textLabel?.text = options[selectedTypeIndex].subOption.map { $0.name }[indexPath.row]
            cell.accessoryType = (indexPath.row == selectedSubtypeIndex) ? .checkmark : .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            selectedTypeIndex = indexPath.row
            selectedSubtypeIndex = 0
        } else {
            selectedSubtypeIndex = indexPath.row
        }
        
        tableView.reloadData()
    }
}

// MARK: UI Layout
extension FilterViewController {
    
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
