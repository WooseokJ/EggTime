

import UIKit
import SnapKit

class SettingTableViewCell: BaseTableViewCell {

    //MARK: 연결
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        setConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: 테이블뷰 구성요소 크기
    
    let content : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = AppColor.textColor.color
        label.font = AppFont.font.name

        return label
    }()
    
    
    //MARK: 테이블뷰 안에 등록
    override func configure() {
        [content].forEach {
            self.addSubview($0)
        }
    }
    
    
    //MARK: 테이블뷰 안에 위치 등록
    override func setConstrains() {

        content.snp.makeConstraints {
            $0.leading.equalTo(10)
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    

}
