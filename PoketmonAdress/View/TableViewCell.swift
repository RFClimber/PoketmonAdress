//
//  TableViewCell.swift
//  PoketmonAdress
//
//  Created by mac on 7/15/24.
//

import UIKit
import SnapKit
import CoreData

final class TableViewCell: UITableViewCell {
    
    var container: NSPersistentContainer!
    
    static let id = "TableViewCell"
    
    private let poketmonImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.borderWidth = 1
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 17)
        return label
    }()
    
    private let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 17)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        contentView.backgroundColor = .white
        [
            poketmonImage,
            nameLabel,
            phoneNumberLabel
        ].forEach { contentView.addSubview($0) }
        
        poketmonImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(10)
            $0.width.height.equalTo(70)
        }
        
        nameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(poketmonImage.snp.trailing).offset(70)
        }
        
        phoneNumberLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(30)
        }
    }
    
    public func configureCell(with phoneBook: PhoneBook) {
        nameLabel.text = phoneBook.name
        phoneNumberLabel.text = phoneBook.phoneNumber
        
        if let imageData = phoneBook.image, let image = UIImage(data: imageData) {
            poketmonImage.image = image
        } else {
            poketmonImage.image = nil
            print("이미지 로드 실패")
        }
    }
}

//#Preview {
// let name = ViewController()
// return name
//}
