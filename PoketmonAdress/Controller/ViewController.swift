//
//  ViewController.swift
//  PoketmonAdress
//
//  Created by mac on 7/15/24.
//

import UIKit
import SnapKit
import CoreData

class ViewController: UIViewController {
    
    var container: NSPersistentContainer!
    var phoneBooks: [PhoneBook] = []
    
    // MARK: - UI 생성
    private let mainPageLabel: UILabel = {
        let label = UILabel()
        label.text = "친구 목록"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setTitle("추가", for: .normal)
        button.setTitleColor(.black, for: .normal)
        // 타겟은 인스턴스로
        button.addTarget(self, action: #selector(buttonTapped), for: .touchDown)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.id)
        return tableView
    }()
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        coreDataSet()
        configureUI()
    }
    
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        fetchPhoneBooks()
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - configureUI
    private func configureUI() {
        
        
        
        view.backgroundColor = .white
        [
            mainPageLabel,
            addButton,
            tableView
        ].forEach { view.addSubview($0) }
        
        
        // MARK: - 레이아웃
        mainPageLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(65)
        }
        
        addButton.snp.makeConstraints {
            $0.centerY.equalTo(mainPageLabel.snp.centerY)
            $0.trailing.equalToSuperview().inset(22)
        }
        
        tableView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(mainPageLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(50)
        }
    }
    // MARK: - CoreData
    private func coreDataSet() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.container = appDelegate.persistentContainer
    }
    
    private func fetchPhoneBooks() {
            let context = container.viewContext
            let fetchRequest: NSFetchRequest<PhoneBook> = PhoneBook.fetchRequest()

            // 이름순으로 정렬
            let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
        
            do {
                phoneBooks = try context.fetch(fetchRequest)
                tableView.reloadData()
            } catch {
                print("Fetch failed")
            }
        }
    
    @objc
    private func buttonTapped() {
        let phoneBookViewController = PhoneBookViewController()
        self.navigationController?.pushViewController(phoneBookViewController, animated: true)
    }
}

// MARK: - 확장
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.id) as? TableViewCell else {
            return UITableViewCell()
        }
        let phoneBook = phoneBooks[indexPath.row]
        cell.configureCell(with: phoneBook)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        phoneBooks.count
    }
    
}

//#Preview {
//    let name = ViewController()
//    return name
//}
