//
//  PhoneBookViewController.swift
//  PoketmonAdress
//
//  Created by mac on 7/16/24.
//

import UIKit
import SnapKit
import CoreData

class PhoneBookViewController: UIViewController {
    
    var container: NSPersistentContainer!
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "연락처 추가"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 75
        image.layer.borderWidth = 3
        image.layer.borderColor = UIColor.lightGray.cgColor
        return image
    }()
    
    private lazy var randImgGenbutton: UIButton = {
        let button = UIButton()
        button.setTitle("랜덤 이미지 생성", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13)
        button.addTarget(self, action: #selector(randImgGenButtonTapped), for: .touchDown)
        return button
    }()
    
    private lazy var nameTextView: UITextView = createTextView()
    private lazy var phoneNumberTextView: UITextView = createTextView()
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNavigationBar()
        coreDataSet()
        configureUI()
        

        
    }
    
    // MARK: - TextView 공통초기화 함수
    private func createTextView() -> UITextView {
        let textView = UITextView()
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 10
        textView.layer.borderWidth = 2
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.font = .systemFont(ofSize: 20)
        textView.textColor = .black
        return textView
    }
    
    
    // MARK: - Nav Bar
    private func configureNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        
        let applyButton = UIBarButtonItem(title: "적용", style: .plain, target: self, action: #selector(applyButtonTapped))
        self.navigationItem.rightBarButtonItem = applyButton
    }

    // MARK: - configureUI
    
    private func configureUI() {
        view.backgroundColor = .white
        [
            titleLabel,
            image,
            randImgGenbutton,
            nameTextView,
            phoneNumberTextView
        ].forEach { view.addSubview($0) }
        
        
        // MARK: - 레이아웃
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(65)
        }
        
        image.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(40)
            $0.width.height.equalTo(150)
        }
        
        randImgGenbutton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(image.snp.bottom).offset(10)
        }
        
        nameTextView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(randImgGenbutton.snp.bottom).offset(10)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        
        phoneNumberTextView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(nameTextView.snp.bottom).offset(10)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
    }
    
    // MARK: - API 통신
    // 포켓몬 정보를 불러오는 메서드
    private func fetchData<T: Decodable>(url: URL, completion: @escaping (T?) -> Void) {
        let session = URLSession(configuration: .default)
        session.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data, error == nil else {
                print("데이터 로드 실패")
                completion(nil)
                return
            }
            let successRange = 200..<300
            if let response = response as? HTTPURLResponse, successRange.contains(response.statusCode) {
                guard let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
                    print("JSON 디코딩 실패")
                    print("받은 데이터: \(String(data: data, encoding: .utf8) ?? "nil")")
                    completion(nil)
                    return
                }
                completion(decodedData)
            } else {
                print("응답 오류")
                completion(nil)
            }
        }.resume()
    }
    
    private func fetchPoketmonData() {
        let randomPoketmon: Int = .random(in: 1...1000)
        let urlComponents = URLComponents(string: "https://pokeapi.co/api/v2/pokemon/\(randomPoketmon)/")
        
        guard let url = urlComponents?.url else {
            print("잘못된 url")
            return
        }
        
        fetchData(url: url) { [weak self] (result: PokeFile?) in
            guard let self, let result else { return }
            
            guard let imageURL = URL(string: result.sprites.front_default) else {
                print("잘못된 이미지 url")
                return
            }
            
            self.fetchImage(url: imageURL)
        }
    }
    
    private func fetchImage(url: URL) {
        let session = URLSession(configuration: .default)
        session.dataTask(with: url ) { data, response, error in
            guard let data = data, error == nil else {
                print("이미지 로드 실패")
                return
            }
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image.image = image
                }
            }
        }.resume()
    }
    
    // MARK: - CoreData
    private func coreDataSet() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.container = appDelegate.persistentContainer
    }

    private func createData(name: String, phoneNumber: String, image: UIImage?) {
        guard let entity = NSEntityDescription.entity(forEntityName: "PhoneBook", in: self.container.viewContext) else {
            return
        }
        let newPhoneBook = NSManagedObject(entity: entity, insertInto: self.container.viewContext)
        newPhoneBook.setValue(name, forKey: "name")
        newPhoneBook.setValue(phoneNumber, forKey: "phoneNumber")
        if let imageData = image?.pngData() {
            newPhoneBook.setValue(imageData, forKey: "image")
        }
        
        do {
            try self.container.viewContext.save()
            print("문맥 저장 성공")
        } catch {
            print("문맥 저장 실패")
        }
    }

    @objc
    private func applyButtonTapped() {
        createData(name: self.nameTextView.text ?? "", phoneNumber: self.phoneNumberTextView.text ?? "", image: self.image.image)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func randImgGenButtonTapped() {
        fetchPoketmonData()
    }
}

//#Preview {
//    let name = PhoneBookViewController()
//    return name
//}
