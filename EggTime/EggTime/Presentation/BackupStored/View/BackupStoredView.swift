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
        button.setTitle("백업33", for: .normal)
        button.backgroundColor = .red
        return button
    }()
    let storedButton: UIButton = {
        let button = UIButton()
        button.setTitle("복구23", for: .normal)
        button.backgroundColor = .yellow
        return button
    }()
    //MARK: 뷰등록
    override func configure() {
        [backupButton,storedButton].forEach {
            self.addSubview($0)
        }
    }
    //MARK: 위치
    override func setConstrains() {
        backupButton.snp.makeConstraints {
            $0.top.equalTo(300)
            $0.leading.equalTo(100)
            $0.width.height.equalTo(100)
        }
        
        storedButton.snp.makeConstraints {
            $0.top.equalTo(300)
            $0.leading.equalTo(backupButton.snp.leading).offset(150)
            $0.width.height.equalTo(100)
        }
    }
    
    
    
    
    
    
}
