//
//  MainVC+Extension.swift
//  EggTime
//
//  Created by useok on 2022/09/11.
//

import Foundation
import UIKit

extension MainViewController {
    
    
    @objc func soakButtonClicked() {
        let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        let soakButton = UIAlertAction(title: "타임 캡슐 묻기", style: .default) { (action) in
            self.tapsoakButton()
        }
        let modifyButton = UIAlertAction(title: "수정하기", style: .default) { (action) in
            self.tapModifyButton()
        }
        let cancel = UIAlertAction(title: "취소하기", style: .cancel)
        
        alert.addAction(soakButton)
        alert.addAction(modifyButton)
        alert.addAction(cancel)
        present(alert,animated: true)
    }
    func tapsoakButton(){
        let vc = WriteViewController()
        transition(vc,transitionStyle: .push)
        vc.select = true


    }
    
 
    
    
    
    func tapModifyButton() {
        let vc = WriteViewController()
        transition(vc,transitionStyle: .push)
        vc.select = false
    }
 
}
