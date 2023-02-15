

import UIKit

final class SettingViewController: BaseViewController {
    
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
        let cellRegisteration = UICollectionView.CellRegistration<UICollectionViewCell,String> (handler: {cell, indexPath, itemIdentifier in
            var content = UIListContentConfiguration.valueCell()
            content.text = Setting.allCases[indexPath.section].list[indexPath.row]
            content.textProperties.color = .white
            content.textProperties.font = AppFont.font.name!
            
            cell.contentConfiguration = content
            
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
