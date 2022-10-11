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
        super.configure()
        super.setConstrains()
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
        label.textColor = AllColor.textColor.color
        label.font = AllFont.font.title
        label.numberOfLines = 0
        label.backgroundColor = .clear
        
        return label
    }()
    
    let lineView: UIView = {
        let view = UIView()
//        view.backgroundColor = .sy
        return view
    }()
    
    let centerView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.image = UIImage(named: "BackgroundImage")
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
        button.backgroundColor = .systemGray4
        button.titleLabel?.font = AllFont.font.name
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.roundCorners(cornerRadius: 10, maskedCorners: [.layerMinXMaxYCorner])

        return button
    }()
    let detailButton: UIButton = {
       let button = UIButton()
        button.setTitle("자세히보기", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = .systemGray5
        button.titleLabel?.font = AllFont.font.name
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.roundCorners(cornerRadius: 10, maskedCorners: [.layerMaxXMaxYCorner])
        return button
    }()
    
    let leaveDayLabel: UILabel = {
        let label = UILabel()
        label.font = AllFont.font.mapTime
        label.textColor = AllColor.textColor.color
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    

    let leaveTitle: UILabel = {
        let label = UILabel()
        label.font = AllFont.font.title
        label.textColor = AllColor.textColor.color
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let leaveTimeLabel: UILabel = {
        let label = UILabel()
        label.font = AllFont.font.mapTime
        label.textColor = AllColor.textColor.color
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let backGroundView2: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "BackgroundImage")
        return image
    }()
    
    lazy var naverMapView: NMFNaverMapView = {
        let naverMapview = NMFNaverMapView(frame: self.frame)
        naverMapview.showLocationButton = true
        naverMapview.mapView.zoomLevel = 10
        naverMapview.mapView.positionMode = .direction
        return naverMapview
    }()

 
    override func configure() {
        [naverMapView].forEach{
            self.addSubview($0)
        }
        

    }
    
    
    override func setConstrains() {
        naverMapView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(self.safeAreaLayoutGuide)
            $0.bottom.equalTo(0)
        }
    }
    
    
    
    
    
}
