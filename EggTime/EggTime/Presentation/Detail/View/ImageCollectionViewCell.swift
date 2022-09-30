//
//  ImageCollectionViewCell.swift
//  EggTime
//
//  Created by useok on 2022/09/11.
//

import UIKit
import SnapKit

class ImageCollectionViewCell: BaseCollectionViewCell {
    
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
        let imageView = UIImageView()
        
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
  
    
    //MARK: 컬렉션뷰 등록
    override func configure() {
        [imageView].forEach {
            contentView.addSubview($0)
        }
    }
    
    
    //MARK: 위치
    override func setConstrains() {
  
        imageView.snp.makeConstraints {
            $0.top.equalTo(0)
            $0.leading.equalTo(0)
            $0.trailing.equalTo(0)
            $0.bottom.equalTo(0)
        }
        
    }
    
    
    
    
    
    
    
    
}
