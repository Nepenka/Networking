//
//  ViewController.swift
//  Networking(URLSession)
//
//  Created by 123 on 4.07.23.
//


import UIKit
import SnapKit


class ViewController: UIViewController {
    
    
    private let tableView = UITableView()
    let button: UIButton = .init()
    var posts: [Post] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView.delegate = self //- нужен для обработчика нажатия на ячейку
        tableView.dataSource = self
        setupUI()
        buttonAction()
    }
    func setupUI() {
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(named: "eject.circle.fill"), for: .normal)
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.snp.makeConstraints { make in
            make.right.left.equalToSuperview().inset(170)
            make.bottom.equalToSuperview().inset(130)
        }
        
    }
    @objc func buttonAction() {
        UIView.animate(withDuration: 0.1, animations: {
            self.button.setBackgroundImage(UIImage(named: "eject.circle.fill"), for: .normal)
        }) { _ in
            UIView.animate(withDuration: 0.5) {
                self.button.setBackgroundImage(UIImage(named: "eject.circle.fill.gray"), for: .normal)
            }
        }
        fetchData()
        
    }
    func fetchData() {
        guard let url = URL(string: "https://api.github.com/repositories?") else {return}
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else if let usableData = data,
                        let response = response as?
                        HTTPURLResponse, response.statusCode == 200 {
                    do {
                        let decoder = JSONDecoder()
                        let posts = try decoder.decode([Post].self, from: usableData)
                        
                        DispatchQueue.main.async {
                            self?.tableView.reloadData()
                            self?.posts = posts
                        }
                        
                    }catch {
                        print("Error decoding: \(error.localizedDescription)")
                    }
                }
                
        }.resume()
    }
}
        

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
}

//MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        let button = button
        button.isHidden = true
        let post = posts[indexPath.row]
        
        cell.nodeLabel.text = post.node_id
        cell.nameLabel.text = post.name
        cell.idLabel.text = String(describing: post.id)
        cell.fullNameLabel.text = post.full_name
        
        
        return cell
    }
    
    
}

class TableViewCell: UITableViewCell {
    var fullNameLabel: UILabel = {
        let label = UILabel()
        // Дополнительные настройки метки
        return label
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        // Дополнительные настройки метки
        return label
    }()
    
    var nodeLabel: UILabel = {
        let label = UILabel()
        // Дополнительные настройки метки
        return label
    }()
    
    var idLabel: UILabel = {
        let label = UILabel()
        // Дополнительные настройки метки
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Добавление меток в иерархию ячейки
        addSubview(fullNameLabel)
        addSubview(nameLabel)
        addSubview(nodeLabel)
        addSubview(idLabel)
        
        // Настройка расположения меток с использованием SnapKit
        fullNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(8)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(fullNameLabel.snp.bottom).offset(8)
        }
        
        nodeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
        }
        
        idLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(nodeLabel.snp.bottom).offset(8)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
