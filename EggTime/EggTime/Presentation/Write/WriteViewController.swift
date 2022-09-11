//
//  WriteViewController.swift
//  EggTime
//
//  Created by useok on 2022/09/11.
//

import UIKit

class WriteViewController: BaseViewController, UITextFieldDelegate {

    let writeView = WriteView()
    
    override func loadView() {
        super.view = writeView
    }

    
    let pickerSelect: [String] = ["A","B"]

    override func viewDidLoad() {
        super.viewDidLoad()
        writeView.pickerView.dataSource = self
        writeView.pickerView.delegate = self
        
        writeView.opendateInput.inputView = writeView.pickerView
        
        writeView.collectionview.delegate = self
        writeView.collectionview.dataSource = self
        
        configToolbar()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonClicked))
        
    }
  
}

