

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

    //MARK: 뷰 등록
    override func configure() {
        
        [backGroundView].forEach {
            self.addSubview($0)
        }
        
    }
    
    
    //MARK: 위치
    
    override func setConstrains() {
        backGroundView.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
    }
    
    
}
