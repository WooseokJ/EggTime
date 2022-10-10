
import Foundation

import SnapKit
import UIKit

class SettingView: BaseView {
    
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
    let tableView : UITableView = {
        let tableview = UITableView(frame: .zero, style: .insetGrouped)
        tableview.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.reuseIdentifier )
        tableview.rowHeight = 80
        tableview.backgroundColor = .clear
        return tableview
        
    }()
    //MARK: 뷰등록
    
    override func configure() {
        [tableView].forEach {
            self.addSubview($0)
        }
    }
    
    
    //MARK: 위치
    override func setConstrains() {
        tableView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.leading.trailing.equalTo(self.safeAreaLayoutGuide)
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
}


extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Setting.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Setting.allCases[section].list.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.reuseIdentifier, for: indexPath) as? SettingTableViewCell else {
            return UITableViewCell()
        }
        cell.content.text = Setting.allCases[indexPath.section].list[indexPath.row]
        cell.backgroundColor = .clear
        cell.selectionStyle = .none // 버튼클릭시 색상변화 x
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: // 백업하기
            let vc = BackupStoredViewController()
            transition(vc,transitionStyle: .push)
        case 1: //오픈라인센스
            let vc = OpenLicenseViewController()
            transition(vc,transitionStyle: .push)
        case 2: //리뷰쓰기
            if let appstoreUrl = URL(string: "https://apps.apple.com/app/id\(1645004650)") {
                var urlComp = URLComponents(url: appstoreUrl, resolvingAgainstBaseURL: false)
                urlComp?.queryItems = [
                    URLQueryItem(name: "action", value: "write-review")
                ]
                guard let reviewUrl = urlComp?.url else {
                    return
                }
                UIApplication.shared.open(reviewUrl, options: [:], completionHandler: nil)
            }
        default:
            break
        }
    }
    
    
}
