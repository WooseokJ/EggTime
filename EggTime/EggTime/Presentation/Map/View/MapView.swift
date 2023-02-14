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
    
    //MARK: 크기
    let popup: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        view.isHidden = true
        return view
    }()
    
    let title: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = AppColor.textColor.color
        label.font = AppFont.font.title
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.isHidden = true
        return label
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    
    let centerView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.image = UIImage(named: "BackgroundImage")
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.isHidden = true
        return view
    }()
    
    let image: UIImageView = {
        let image = UIImageView()
        image.isHidden = true
        image.contentMode = .scaleToFill
        image.image = UIImage(named: "EggImage")
        return image
    }()
    let checkButton: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = .systemGray4
        button.titleLabel?.font = AppFont.font.name
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.layer.maskedCorners = CACornerMask.layerMinXMaxYCorner
        button.isHidden = true
        return button
    }()
    let detailButton: UIButton = {
       let button = UIButton()
        button.setTitle("자세히보기", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = .systemGray5
        button.titleLabel?.font = AppFont.font.name
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.layer.maskedCorners = CACornerMask.layerMaxXMaxYCorner
        button.isHidden = true
        return button
    }()
    
    let leaveDayLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.font.mapTime
        label.textColor = AppColor.textColor.color
        label.numberOfLines = 0
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    

    let leaveTitle: UILabel = {
        let label = UILabel()
        label.font = AppFont.font.title
        label.textColor = AppColor.textColor.color
        label.numberOfLines = 0
        label.textAlignment = .center
        label.isHidden = true
        label.text = "오픈까지 남은기간"
        return label
    }()
    
    let leaveTimeLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.font.mapTime
        label.textColor = AppColor.textColor.color
        label.numberOfLines = 0
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    let backGroundView2: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "BackgroundImage")
        image.isHidden = true
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
        [naverMapView,popup,centerView, image, checkButton, detailButton, title,lineView, leaveTitle, leaveDayLabel, leaveTimeLabel].forEach{
            self.addSubview($0)
        }
        

    }
    
    
    override func setConstrains() {
        naverMapView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(self.safeAreaLayoutGuide)
            $0.bottom.equalTo(0)
        }
        title.snp.remakeConstraints {
            $0.centerX.equalTo(centerView)
            $0.top.equalTo(centerView.snp.top)
            $0.width.equalTo(image.snp.width)
            $0.height.equalTo(centerView.snp.height).multipliedBy(0.1)
        }
        
        centerView.snp.remakeConstraints {
            $0.width.equalTo(300)
            $0.height.equalTo(500)
            $0.center.equalTo(self)
        }
        
        popup.snp.remakeConstraints {
            $0.edges.equalTo(self)
        }
        image.snp.remakeConstraints {
            $0.top.equalTo(title.snp.bottom)
            $0.leading.equalTo(centerView.snp.leading)
            $0.trailing.equalTo(centerView.snp.trailing)
            $0.bottom.equalTo(checkButton.snp.top)
        }
        checkButton.snp.remakeConstraints {
            $0.bottom.equalTo(centerView.snp.bottom)
            $0.height.equalTo(50)
            $0.width.equalTo(centerView.snp.width).multipliedBy(0.5)
            $0.leading.equalTo(centerView.snp.leading)
        }
        
        detailButton.snp.remakeConstraints {
            $0.height.equalTo(50)
            $0.width.equalTo(centerView.snp.width).multipliedBy(0.5)
            $0.trailing.equalTo(centerView.snp.trailing)
            $0.bottom.equalTo(centerView.snp.bottom)
        }
        lineView.snp.remakeConstraints {
            $0.height.equalTo(detailButton.snp.height)
            $0.width.equalTo(0.5)
            $0.centerX.equalTo(image)
            $0.top.equalTo(checkButton.snp.top)
            $0.bottom.equalTo(checkButton.snp.bottom)
        }
        
        leaveTimeLabel.snp.remakeConstraints {
            $0.centerY.equalTo(self).offset(30)
            $0.centerX.equalTo(self)
            $0.height.equalTo(50)
            $0.leading.equalTo(centerView.snp.leading)
            $0.trailing.equalTo(centerView.snp.trailing)
        }
        
        leaveDayLabel.snp.remakeConstraints {
            $0.height.equalTo(30)
            $0.leading.equalTo(centerView.snp.leading)
            $0.trailing.equalTo(centerView.snp.trailing)
            $0.bottom.equalTo(leaveTimeLabel.snp.top).offset(-5)
        }
        
        
        leaveTitle.snp.remakeConstraints {
            $0.bottom.equalTo(leaveTimeLabel.snp.top).offset(-30)
            $0.height.equalTo(50)
            $0.leading.equalTo(centerView.snp.leading)
            $0.trailing.equalTo(centerView.snp.trailing)
        }
    }
    
    func popupShow() {
        popup.isHidden = false
        image.isHidden = false
        checkButton.isHidden  = false
        detailButton.isHidden  = false
        centerView.isHidden  = false
        title.isHidden  = false
        lineView.isHidden = false
        leaveTitle.isHidden = false
        leaveTimeLabel.isHidden = false
        leaveDayLabel.isHidden = false
    }
    
    func popupHidden() {
        popup.isHidden = true
        image.isHidden = true
        checkButton.isHidden = true
        detailButton.isHidden = true
        centerView.isHidden = true
        title.isHidden = true
        lineView.isHidden = true
        leaveTitle.isHidden = true
        leaveTimeLabel.isHidden = true
        leaveDayLabel.isHidden = true
    }

}



