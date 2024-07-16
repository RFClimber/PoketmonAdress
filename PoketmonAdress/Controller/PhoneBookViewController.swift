//
//  PhoneBookViewController.swift
//  PoketmonAdress
//
//  Created by mac on 7/16/24.
//

import UIKit
import SnapKit

class PhoneBookViewController: UIViewController {
    
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
    
    
    @objc
    private func applyButtonTapped() {
        
    }
    
    @objc
    private func randImgGenButtonTapped() {
        
    }
}

#Preview {
    let name = PhoneBookViewController()
    return name
}
