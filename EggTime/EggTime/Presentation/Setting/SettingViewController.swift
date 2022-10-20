

import UIKit

class SettingViewController: BaseViewController {
    
    //MARK: 뷰 가져오기
    let settingview = SettingView()
    
    private var dataSource: UICollectionViewDiffableDataSource<Int,String>!
    
    override func loadView() {
        super.view = settingview
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "설정"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil) // title 부분 수정
        
        
        self.navigationItem.backBarButtonItem = backBarButtonItem
        
        settingview.collectionview.collectionViewLayout = createLayout()
        
        configureDataSource()
        settingview.collectionview.delegate = self
    }
}



extension SettingViewController {
    private func createLayout() -> UICollectionViewLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        config.backgroundColor = .clear
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        return layout
    }
    
    private func configureDataSource() {
        var cellRegisteration = UICollectionView.CellRegistration<UICollectionViewCell,String> (handler: {cell, indexPath, itemIdentifier in
            var content = UIListContentConfiguration.valueCell()
            content.text = Setting.allCases[indexPath.section].list[indexPath.row]
            content.textProperties.color = .white
            cell.contentConfiguration = content
            cell.backgroundConfiguration?.backgroundColor = .green
            
            var background = UIBackgroundConfiguration.listPlainCell()
            background.backgroundColor = .clear
            
            cell.backgroundConfiguration = background
            
        })
        
        // cv.
        dataSource = UICollectionViewDiffableDataSource(collectionView: settingview.collectionview, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegisteration, for: indexPath, item: itemIdentifier) // indexPath, itemIdentifier 둘다 이용해서 cell에 접근가능
            return cell
        })
        
        var snapShot = NSDiffableDataSourceSnapshot<Int,String>()
        snapShot.appendSections([0])
        snapShot.appendItems(Setting.content.list)
        dataSource.apply(snapShot)
        
        
    }
}

extension SettingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.item {
        case 0 :
            let vc = BackupStoredViewController()
            transition(vc,transitionStyle: .push)
        case 1:
            let vc = OpenLicenseViewController()
            transition(vc,transitionStyle: .push)
        case 2:
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
