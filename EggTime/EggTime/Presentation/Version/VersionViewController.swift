//
//  VersionViewController.swift
//  EggTime
//
//  Created by useok on 2022/09/14.
//

import UIKit

class VersionViewController: BaseViewController {

    //MARK: 뷰 가져오기
    let versionView = VersionView()
    
    override func loadView() {
        super.view = versionView
    }
    
    //나중에수정
    var version: String? {
        guard let dictionary = Bundle.main.infoDictionary,
        let version = dictionary["CFBundleShortVersionString"] as? String,
        let build = dictionary["CFBundleVersion"] as? String else {return nil}

        let versionAndBuild: String = "vserion: \(version)"
        return versionAndBuild
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "버전확인"
        let attributes = [
            NSAttributedString.Key.foregroundColor: AllColor.textColor.color,
            NSAttributedString.Key.font: AllFont.font.name
        ]
        //2
        navigationController?.navigationBar.titleTextAttributes = attributes

        guard let version = version  else {
             showAlertMessage(title: "version 오류", button: "확인")
             return
        }
        versionView.presentLabel.text = "현재 버전: \(version.split(separator: " ")[1])"
        //MARK: 수정해야되는부분임.!!!!!!!!!
        versionView.recentLabel.text = "최신 버전: \(version.split(separator: " ")[1])"

    }

    


}
