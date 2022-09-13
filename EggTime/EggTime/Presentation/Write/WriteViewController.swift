//
//  WriteViewController.swift
//  EggTime
//
//  Created by useok on 2022/09/11.
//

import UIKit
//import YPImagePicker

class WriteViewController: BaseViewController, UITextFieldDelegate {

    let writeView = WriteView()
    
    override func loadView() {
        super.view = writeView
    }
    
    let repository = RealmRepository()
    var select: Bool? = nil
    let picker = UIImagePickerController()

    var imageArrayString: [String]?
    var tag: Int = 0
    
    override func viewWillAppear(_ animated: Bool) {
        picker.delegate = self

        guard select == true else {
            navigationItem.rightBarButtonItem =  UIBarButtonItem(title: "수정", style: .plain, target: self, action: #selector(modifyButtonClicked))
            return
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonClicked))
        
    }
    
    lazy var pickerSelect: [String] = PickerEnum.allCases.map{$0.pickerLisk[0]}

    override func viewDidLoad() {
        super.viewDidLoad()
        writeView.pickerView.dataSource = self
        writeView.pickerView.delegate = self
        
        writeView.opendateInput.inputView = writeView.pickerView
        
        writeView.collectionview.delegate = self
        writeView.collectionview.dataSource = self
        
        configToolbar()
        
    }

}

