

import Foundation
import SnapKit
import UIKit

import NMapsMap
class MainView: BaseView {
    
    //MARK: 연결
    override init(frame: CGRect) {
        super.init(frame: frame)
        super.configure()
        super.setConstrains()
        configure()
        setConstrains()
    }
    
    //MARK: 크기
    
    let titleLabel = CustomLabel(title: "오픈가능한 타임캡슐이 없습니다.", type: .noEggTimeLabel)
    lazy var plusButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        button.backgroundColor = .white
        return button
    }()
    
    
    let desctibeLabel = CustomLabel(title: "가장 빨리 열수있는 캡슐까지 남은기간", type: .titleLabel)
    let writerLabel = CustomLabel(title: "", type: .titleLabel)
    let leaveDay = CustomLabel(title: "", type: .lageLabel)
    let timerLabel = CustomLabel(title: "", type: .lageLabel)

    //MARK: 뷰 등록
    override func configure() {
        
        [titleLabel,plusButton, desctibeLabel, writerLabel, leaveDay, timerLabel].forEach {
            self.addSubview($0)
        }
        
    }
    
    //MARK: 위치
    override func setConstrains() {
        titleLabel.snp.makeConstraints {
            $0.width.equalTo(self.safeAreaLayoutGuide.snp.width).multipliedBy(0.7)
            $0.height.equalTo(self.safeAreaLayoutGuide.snp.height).multipliedBy(0.1)
            $0.centerY.equalTo(self.safeAreaLayoutGuide.snp.centerY).multipliedBy(0.8)
            $0.centerX.equalTo(self)
        }
        plusButton.snp.makeConstraints {
            $0.bottom.equalTo(-55)
            $0.trailing.equalTo(-35)
            $0.height.width.equalTo(60)
        }
        writerLabel.snp.makeConstraints {
            $0.width.equalTo(self.safeAreaLayoutGuide.snp.width).multipliedBy(0.7)
            $0.height.equalTo(self.safeAreaLayoutGuide.snp.height).multipliedBy(0.1)
            $0.centerY.equalTo(self.safeAreaLayoutGuide.snp.centerY).multipliedBy(0.6)
            $0.centerX.equalTo(self)
        }
        
        desctibeLabel.snp.makeConstraints {
            $0.width.equalTo(self.safeAreaLayoutGuide.snp.width).multipliedBy(0.7)
            $0.height.equalTo(self.safeAreaLayoutGuide.snp.height).multipliedBy(0.1)
            $0.centerY.equalTo(self.safeAreaLayoutGuide.snp.centerY).multipliedBy(0.7)
            $0.centerX.equalTo(self)
        }
  
        leaveDay.snp.makeConstraints {
            $0.width.equalTo(self.safeAreaLayoutGuide.snp.width).multipliedBy(0.7)
            $0.height.equalTo(self.safeAreaLayoutGuide.snp.height).multipliedBy(0.1)
            $0.centerY.equalTo(self.safeAreaLayoutGuide.snp.centerY).multipliedBy(0.9)
            $0.centerX.equalTo(self)
        }
        timerLabel.snp.makeConstraints {
            $0.width.equalTo(self.safeAreaLayoutGuide.snp.width).multipliedBy(0.7)
            $0.height.equalTo(self.safeAreaLayoutGuide.snp.height).multipliedBy(0.1)
            $0.centerY.equalTo(self.safeAreaLayoutGuide.snp.centerY).multipliedBy(1.1)
            $0.centerX.equalTo(self)
        }
    }
    func EggShow() { // 캡슐있을떄 보여주기
        titleLabel.isHidden = true
        desctibeLabel.isHidden = false
        writerLabel.isHidden = false
        leaveDay.isHidden = false
        timerLabel.isHidden = false
    }
    func EggHidden() { // 캡슐없을떄 
        titleLabel.isHidden = false
        desctibeLabel.isHidden = true
        writerLabel.isHidden = true
        leaveDay.isHidden = true
        timerLabel.isHidden = true
    }
    
    
}


