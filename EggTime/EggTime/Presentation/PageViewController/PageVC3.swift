//
//  PageVC3.swift
//  EggTime
//
//  Created by useok on 2022/09/19.
//

import UIKit
import SnapKit

class PageVC3: UIViewController {
    
    let button: UIButton = {
        let bt = UIButton()
        let text = UserDefaults.standard.bool(forKey: "first") ? "확인" : "시작하기"
        bt.setTitle(text, for: .normal)
        bt.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        bt.layer.borderWidth = 4
        return bt
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        view.addSubview(button)
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        
        button.snp.makeConstraints {
            $0.width.equalTo(240)
            $0.height.equalTo(50)
            $0.bottom.equalTo(-80)
            $0.centerX.equalTo(view)
            
        }

    }
    @objc func buttonClicked() {
        if UserDefaults.standard.bool(forKey: "first") {
            dismiss(animated: true)
        }else {
            UserDefaults.standard.set(true,forKey: "first")
            let vc = TabBarController()
            
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false)
            
        }
        
        
    }
    



}
