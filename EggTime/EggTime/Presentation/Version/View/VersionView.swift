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
        imageview.image = UIImage(named: "sampleAppIcon")
        return imageview
    }()
    
    // 최신버전
    let recentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    // 현재버전
    let presentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .white
        label.textAlignment = .center
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
            $0.width.height.equalTo(200)
            $0.leading.equalTo(100)
            $0.trailing.equalTo(-100)
        }
        
        recentLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(60)
            $0.width.equalTo(200)
            $0.height.equalTo(20)
            $0.leading.equalTo(imageView.snp.leading)
        }
        presentLabel.snp.makeConstraints {
            $0.top.equalTo(recentLabel.snp.bottom).offset(20)
            $0.width.equalTo(recentLabel.snp.width)
            $0.height.equalTo(recentLabel.snp.height)
            $0.leading.equalTo(recentLabel.snp.leading)
            
        }
        
    }
    
    
}
