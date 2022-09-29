//
//  VersionView.swift
//  EggTime
//
//  Created by useok on 2022/09/14.
//

import Foundation
import UIKit

import SnapKit
class VersionView: BaseView {
    
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
    let imageView: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "Egg")
        return imageview
    }()
    
    // 최신버전
    let recentLabel: UILabel = {
        let label = UILabel()
        label.textColor = AllColor.textColor.color
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        label.font = AllFont.font.name
        return label
    }()
    // 현재버전
    let presentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = AllColor.textColor.color
        label.textAlignment = .center
        label.font = AllFont.font.name

        return label
    }()
    
    //MARK: 뷰등록
    override func configure() {
        [backGroundView,imageView,recentLabel,presentLabel].forEach {
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
            $0.height.equalTo(200)
            $0.centerX.equalTo(self)
            $0.width.equalTo(150)
            
        }
        
        recentLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(60)
            $0.width.equalTo(200)
            $0.height.equalTo(20)
            $0.centerX.equalTo(self)
        }
        presentLabel.snp.makeConstraints {
            $0.top.equalTo(recentLabel.snp.bottom).offset(20)
            $0.width.equalTo(recentLabel.snp.width)
            $0.height.equalTo(recentLabel.snp.height)
            $0.centerX.equalTo(self)

        }
        
    }
    
    
}
