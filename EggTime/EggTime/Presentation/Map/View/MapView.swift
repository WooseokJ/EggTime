//
//  MapView.swift
//  EggTime
//
//  Created by useok on 2022/09/14.
//

import Foundation
import UIKit
import SnapKit
import NMapsMap

class MapView: BaseView {
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
    let popup: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        return view
    }()
    
    let title: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 0
        label.font = UIFont(name: "SongMyung-Regular", size: 16.0)
        label.backgroundColor = .yellow
        return label
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    let centerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        
        return view
    }()
    
    let image: UIImageView = {
        let image = UIImageView()
        return image
    }()
    let checkButton: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = .systemGray5
        button.titleLabel?.font = UIFont(name: "SongMyung-Regular", size: 16.0)

        return button
    }()
    let detailButton: UIButton = {
       let button = UIButton()
        button.setTitle("자세히보기", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = .systemGray5
        button.titleLabel?.font = UIFont(name: "SongMyung-Regular", size: 16.0)
        
        return button
    }()
    
    let backGroundView2: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "BackgroundImage")
        return image
    }()

 
    override func configure() {
//        backGroundView.addSubview(self)
    }
    
    
    override func setConstrains() {
        
//        backGroundView.snp.makeConstraints {
//            $0.top.equalTo(0)
//            $0.height.equalTo(30)
//            $0.leading.trailing.equalTo(0)
//        }
        
    }
    
    
    
    
    
}
