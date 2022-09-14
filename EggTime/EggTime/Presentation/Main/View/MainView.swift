

import Foundation
import SnapKit
import UIKit

import NMapsMap
class MainView: BaseView {
    
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
    let eggBackGround : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 210
        view.clipsToBounds = true
        view.backgroundColor = Constants.imageBackground.color
        return view
    }()
    
    let soakButton : UIButton = {
        let button = UIButton()
        button.setTitle("타임 캡슐 묻기", for: .normal)
        button.setTitleColor(Constants.background.color, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 25, weight: .bold)
        return button
    }()
    
    
    
    //MARK: 뷰 등록
    override func configure() {
        
        [eggBackGround,soakButton].forEach {
            self.addSubview($0)
        }
        
    }
    
    
    //MARK: 위치
    
    override func setConstrains() {
        eggBackGround.snp.makeConstraints {
            $0.leading.trailing.equalTo(0)
            $0.centerX.equalTo(self)
            $0.top.equalTo(100)
            $0.bottom.equalTo(-100)
        }
        soakButton.snp.makeConstraints {
            $0.bottom.equalTo(eggBackGround.snp.bottom).multipliedBy(0.9)
            $0.leading.equalTo(100)
            $0.trailing.equalTo(-100)
        }

    }
    
    
}
