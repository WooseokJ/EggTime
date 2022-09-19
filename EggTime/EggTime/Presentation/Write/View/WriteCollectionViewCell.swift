//
//  WriteCollectionViewCell.swift
//  EggTime
//
//  Created by useok on 2022/09/11.
//

import UIKit

class WriteCollectionViewCell: BaseCollectionViewCell {
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
    var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    
    
    //MARK: 뷰등록
    override func configure() {
        self.addSubview(imageView)
    }
    
    
    
    //MARK: 위치
    override func setConstrains() {
        imageView.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
    }
    
    
}
