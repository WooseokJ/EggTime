//
//  WriteVC+Extension.swift
//  EggTime
//
//  Created by useok on 2022/09/11.
//

import Foundation
import UIKit
//import YPImagePicker

//import Kingfisher
extension WriteViewController {
    
    //MARK: 피커뷰 위한 툴바
    func configToolbar() {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.white
        toolBar.backgroundColor = .black
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
    
    //MARK: 저장하기 버튼클릭
    @objc func saveButtonClicked() {
        guard let title = writeView.titleInput.text else {
            showAlertMessage(title: "제목을 입력해주세요", button: "확인")
            return
        }
        print(repository.localRealm.configuration.fileURL!)
        
        
        let task = RealmModel(title: title, regDate: repository.stringToDate(string: writeView.dateInput.text ?? ""), openDate: repository.stringToDate(string: writeView.opendateInput.text ?? "")  , content: writeView.writeTextView.text, imageString: ["eee","dsadf"] )
        do {
            try repository.localRealm.write {
                repository.localRealm.add(task)
            }
        } catch let error {
            print(error)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: 수정하기 버튼클릭
    @objc func modifyButtonClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func photoSelect() {
        print(#function)
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { // .camera
            print("사용불가+사용자에게 토스트/얼럿띄움")
            return
        }
        picker.sourceType = .photoLibrary //카메라로 띄우겟다 // photolibrary로하면 갤러리가 뜸 camera하면 camera뜸
        picker.allowsEditing = true // 카메라 찍은뒤 편집할수있냐없냐 default는 false임. //이게있어서 찍은뒤 편집화면이 보일수있는거
        present(picker, animated: true)
    }
    @objc func cameraStart() {
//        let picker = YPImagePicker() //권한요청 메소드는 안에있어.
//        picker.didFinishPicking { [unowned picker] items, _ in
//            if let photo = items.singlePhoto {
//                WriteCollectionViewCell().imageView.image = photo.image
//            }
//            picker.dismiss(animated: true, completion: nil)
//        }
//        present(picker, animated: true, completion: nil)
    }
}


extension WriteViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //UIImagePickerController4 : 사진성택하거나 카메라 촬영직후
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("가가")

        if let imgUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL {
            // 퍼알경로 위치
           let imgName = imgUrl.lastPathComponent
           let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
           let localPath = documentDirectory?.appending(imgName)
           let photoURL = URL.init(fileURLWithPath: localPath!)
            
            let test = WriteCollectionViewCell()
//            if NSFileManager.defaultManager().fileExistsAtPath(photoURL) {
//                let url = NSURL(string: photoURL)
//                let data = NSData(contentsOfURL: url!)
//                imageView.image = UIImage(data: data!)
//            }


            print("1",test.imageView.image)
            
            

//            imageArrayString?.append(photoURL.lastPathComponent)
            print("3",imageArrayString)
           writeView.collectionview.reloadData()
            dismiss(animated: true)
        }

    }
    //UIImagePickerController5: 취소버튼 클릭시
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("나난")
        dismiss(animated: true)
    }
}


extension WriteViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WriteCollectionViewCell.reuseIdentifier, for: indexPath) as? WriteCollectionViewCell else {
            return UICollectionViewCell()
        }
        print(imageArrayString)
//        guard imageArray?.count != 0 else{
//            return cell
//        }
//        cell.imageView.image = imageArray?[0]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        tag = indexPath.item
        print(tag)
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        let photo = UIAlertAction(title: "앨범", style: .default) { (action) in
            self.photoSelect()
        }
        let camera = UIAlertAction(title: "카메라", style: .default) { action in
            self.cameraStart()
        }
        let cancel = UIAlertAction(title: "취소하기", style: .cancel)
        
        alert.addAction(photo)
        alert.addAction(camera)
        alert.addAction(cancel)
        present(alert,animated: true)
    }

    
    
    
}
