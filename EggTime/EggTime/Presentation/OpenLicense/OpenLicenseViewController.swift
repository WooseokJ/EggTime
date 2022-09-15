//
//  OpenLicenseViewController.swift
//  EggTime
//
//  Created by useok on 2022/09/14.
//

import UIKit

class OpenLicenseViewController: BaseViewController {

    //MARK: 뷰 가져오기
    let openLicenseView = OpenLicenseView()
    
    override func loadView() {
        super.view = openLicenseView
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        openLicenseView.tableView.delegate = self
        openLicenseView.tableView.dataSource = self
    }

}
