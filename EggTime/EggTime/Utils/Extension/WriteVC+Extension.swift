//
//  WriteVC+Extension.swift
//  EggTime
//
//  Created by useok on 2022/09/11.
//

import Foundation
import UIKit

extension WriteViewController {
    
    
    @objc func saveButtonClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: 피커뷰 위한 툴바
    func configToolbar() {
          let toolBar = UIToolbar()
          toolBar.barStyle = UIBarStyle.default
          toolBar.isTranslucent = true
          toolBar.tintColor = UIColor.white
          toolBar.sizeToFit()
          
          let doneBT = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(self.donePicker))
          let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
          let cancelBT = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(self.cancelPicker))
          
          toolBar.setItems([cancelBT,flexibleSpace,doneBT], animated: false)
          toolBar.isUserInteractionEnabled = true
          
        writeView.opendateInput.inputAccessoryView = toolBar
      }

      @objc func donePicker() {
          let row = self.writeView.pickerView.selectedRow(inComponent: 0)
          self.writeView.pickerView.selectRow(row, inComponent: 0, animated: false)
          self.writeView.opendateInput.text = self.pickerSelect[row]
          self.writeView.opendateInput.resignFirstResponder()
      }

      @objc func cancelPicker() {
          self.writeView.opendateInput.text = nil
          self.writeView.opendateInput.resignFirstResponder()
      }

}
