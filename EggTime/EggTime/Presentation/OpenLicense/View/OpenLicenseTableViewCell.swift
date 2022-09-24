//
//  OpenLicenseTableViewCell.swift
//  EggTime
//
//  Created by useok on 2022/09/14.
//

import UIKit

class OpenLicenseTableViewCell: BaseTableViewCell {

    //MARK: 연결
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        setConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: 크기
    let content: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = AllColor.textColor.color
        label.font = UIFont(name: "SongMyung-Regular", size: 16.0)

        return label
        
    }()
    //MARK: 뷰등록
    override func configure() {
        [content].forEach {
            self.addSubview($0) // contentView와 동일
        }
    }
    //MARK: 위치
    override func setConstrains() {
   
        content.snp.makeConstraints {
            $0.top.bottom.trailing.equalTo(self)
            $0.leading.equalTo(40)
            
        }
    }
}
