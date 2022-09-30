
import Foundation

import SnapKit
import UIKit

class SettingView: BaseView {
    
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
    let tableView : UITableView = {
        let tableview = UITableView(frame: .zero, style: .insetGrouped)
        tableview.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.reuseIdentifier )
//        tableview.backgroundColor = Constants.background.color
        tableview.rowHeight = 80
//        tableview.backgroundView = UIImageView(image: UIImage(named: "BackgroundImage"))
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
//        cell.backgroundView = UIImageView(image: UIImage(named: "BackgroundImage"))
        

        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }
    
    
    //MARK:  테이블뷰 색션 텍스트 정보
//    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
//        let header = view as! UITableViewHeaderFooterView
//        header.textLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
//        header.textLabel?.textColor = .white
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //나중에수정
        
        //MARK: 백업복구기능
        if (indexPath.row == 0) {
            let vc = BackupStoredViewController()
            transition(vc,transitionStyle: .push)
        }
        
//        //MARK: 사용법
//        if (indexPath.row == 1) {
//            let vc = PageViewController()
//            let nav = UINavigationController(rootViewController: vc)
//            nav.modalPresentationStyle = .overFullScreen
//            self.present(nav, animated: true)
//        }
        //MARK: 오픈소스
        if (indexPath.row == 1) {
            let vc = OpenLicenseViewController()
            transition(vc,transitionStyle: .push)
        }
        
        //MARK: 버전 앨럿
        if (indexPath.row == 2) {
            let vc = VersionViewController()
            transition(vc,transitionStyle: .push)
        }
        
        //MARK: 리뷰쓰기
        if (indexPath.row == 3)  {
            if let reviewURL = URL(string: "itms-apps://itunes.apple.com/app/itunes-u/idwooseokJo?ls=1&mt=8&action=write-review"), UIApplication.shared.canOpenURL(reviewURL) { // 유효한 URL인지 검사합니다.
                if #available(iOS 10.0, *) { //iOS 10.0부터 URL를 오픈하는 방법이 변경 되었습니다.
                    UIApplication.shared.open(reviewURL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(reviewURL)
                }
            }
            
        }
        
    }
    
}

