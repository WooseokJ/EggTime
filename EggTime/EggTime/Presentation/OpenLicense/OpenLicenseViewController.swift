//
//  OpenLicenseViewController.swift
//  EggTime
//
//  Created by useok on 2022/09/14.
//

import UIKit

class OpenLicenseViewController: BaseViewController {

    //MARK: 뷰 가져오기
    private let openLicenseView = OpenLicenseView()
    
    override func loadView() {
        super.view = openLicenseView
    }
    private var dataSource: UICollectionViewDiffableDataSource<Int,String>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "OpenLicense"
        let attributes = [
            NSAttributedString.Key.foregroundColor: AllColor.textColor.color,
            NSAttributedString.Key.font: AllFont.font.name
        ]
        navigationController?.navigationBar.titleTextAttributes = attributes as [NSAttributedString.Key : Any]
        
        openLicenseView.collectionView.collectionViewLayout = createLayout()
        configureDataSource()
                
    }

}

extension OpenLicenseViewController {
    private func createLayout() -> UICollectionViewLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        config.backgroundColor = .clear
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        return layout
    }
    
    private func configureDataSource() {
        var cellRegistration = UICollectionView.CellRegistration<UICollectionViewCell,String>  { cell, indexPath, itemIdentifier in
            var content = UIListContentConfiguration.valueCell()
            content.text = OpenLicense.allCases[indexPath.section].list[indexPath.row]
            content.textProperties.color = .white
            content.textProperties.font = AllFont.font.name!
            cell.contentConfiguration = content
            
            var background = UIBackgroundConfiguration.listPlainCell()
            background.backgroundColor = .clear
            cell.backgroundConfiguration = background
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: openLicenseView.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
        var snapShot = NSDiffableDataSourceSnapshot<Int,String>()
        snapShot.appendSections([0])
        snapShot.appendItems(OpenLicense.license.list)
        dataSource.apply(snapShot)
    }
    
}
