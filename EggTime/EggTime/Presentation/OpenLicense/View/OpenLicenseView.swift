//
//  OpenLicenseView.swift
//  EggTime
//
//  Created by useok on 2022/09/14.
//

import Foundation
import UIKit
import SnapKit

class OpenLicenseView: BaseView {
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
    let tableView: UITableView = {
        let tableview = UITableView()
        tableview.register(OpenLicenseTableViewCell.self, forCellReuseIdentifier: OpenLicenseTableViewCell.reuseIdentifier)
        tableview.rowHeight = 60
        tableview.backgroundColor = .clear
        return tableview
    }()
    
    //MARK: 뷰등록
    
    override func configure() {
        [backGroundView,tableView].forEach {
            self.addSubview($0)
        }
    }
    
    
    //MARK: 위치
    override func setConstrains() {
        backGroundView.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
        tableView.snp.makeConstraints {
            $0.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
}


extension OpenLicenseViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OpenLicense.allCases[section].list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OpenLicenseTableViewCell.reuseIdentifier, for: indexPath) as? OpenLicenseTableViewCell else {return UITableViewCell()}
        cell.content.text = OpenLicense.allCases[indexPath.section].list[indexPath.row]
        // 테이블뷰 선택 색상없애기
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
    }
    
    
}

