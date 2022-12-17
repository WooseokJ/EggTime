

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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: 크기
    
    lazy var tempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = AppFont.font.name
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = AppFont.font.name
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    

    lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = AppFont.font.time
        label.textAlignment = .center
        return label
    }()
    
    lazy var timelabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = AppFont.font.time
        label.textAlignment = .center
        return label
    }()
    
    lazy var plusButton: UIButton = {
        var button = UIButton()
   
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        button.backgroundColor = .white
        return button
        
    }()

    //MARK: 뷰 등록
    override func configure() {
        
        [tempLabel,dayLabel,titleLabel,timelabel,plusButton].forEach {
            self.addSubview($0)
        }
        
    }
    
    
    //MARK: 위치
    
    override func setConstrains() {

        tempLabel.snp.makeConstraints {
            $0.centerX.equalTo(self)
            $0.bottom.equalTo(titleLabel.snp.top).offset(-10)
            $0.height.equalTo(titleLabel.snp.height)
            $0.leading.trailing.equalTo(0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalTo(self)
            $0.centerY.equalTo(self).offset(-100)
            $0.height.equalTo(50)
            $0.leading.trailing.equalTo(0)
        }
        
        dayLabel.snp.makeConstraints {
            $0.centerX.equalTo(self)
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.height.equalTo(50)
            $0.leading.trailing.equalTo(0)
        }
        
        timelabel.snp.makeConstraints {
            $0.centerX.equalTo(self)
            $0.top.equalTo(dayLabel.snp.bottom).offset(10)
            $0.height.equalTo(100)
            $0.leading.trailing.equalTo(0)
        }
        plusButton.snp.makeConstraints {
            $0.bottom.equalTo(-55)
            $0.trailing.equalTo(-35)
            $0.height.width.equalTo(60)
        }

        
    }
    
    
}
