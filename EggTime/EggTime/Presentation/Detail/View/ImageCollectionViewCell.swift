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
    let imageButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Constants.imageBackground.color
        return button
    }()
    
    //MARK: 컬렉션뷰 등록
    override func configure() {
        [imageButton].forEach {
            contentView.addSubview($0)
        }
    }
    
    
    //MARK: 위치
    override func setConstrains() {
        imageButton.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
        
    }
    
    
    
    
    
    
    
    
}
