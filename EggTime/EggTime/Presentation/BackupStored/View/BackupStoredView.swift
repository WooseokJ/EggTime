//
//  BackupStoredView.swift
//  EggTime
//
//  Created by useok on 2022/09/14.
//

import Foundation
import UIKit

import SnapKit
class BackupStoredView: BaseView {
    
    //MARK: 연결
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: 크기
    let backupButton: UIButton = {
        let button = UIButton()
        button.setTitle("백업", for: .normal)
        button.setTitleColor(AllColor.textColor.color, for: .normal)
        button.titleLabel?.font = UIFont(name: "SongMyung-Regular", size: 16.0)

        button.layer.cornerRadius = 20
        button.layer.borderWidth = 3
        button.layer.borderColor = AllColor.textColor.color.cgColor
        return button
    }()
    let storedButton: UIButton = {
        let button = UIButton()
        button.setTitle("복구", for: .normal)
        button.setTitleColor(AllColor.textColor.color, for: .normal)
        button.titleLabel?.font = UIFont(name: "SongMyung-Regular", size: 16.0)

        button.layer.cornerRadius = 20
        button.layer.borderWidth = 3
        button.layer.borderColor = AllColor.textColor.color.cgColor
        return button
    }()
    let imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "tray.and.arrow.up")
        image.tintColor = AllColor.textColor.color
        return image
    }()
    
    //MARK: 뷰등록
    override func configure() {
        [backGroundView,backupButton,storedButton,imageView].forEach {
            self.addSubview($0)
        }
    }
    //MARK: 위치
    override func setConstrains() {
        backGroundView.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
        imageView.snp.makeConstraints {
            $0.top.equalTo(200)
            $0.width.height.equalTo(200)
            $0.leading.equalTo(100)
            $0.trailing.equalTo(-100)
        }
        
        backupButton.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(30)
            $0.centerX.equalTo(self).multipliedBy(0.7)
            $0.width.height.equalTo(100)
        }
        
        storedButton.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(30)
            $0.centerX.equalTo(self).multipliedBy(1.3)
            $0.width.height.equalTo(100)
        }
        
      
    }
    
    
    
    
    
    
}
