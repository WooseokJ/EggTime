//
//  WriteViewController.swift
//  EggTime
//
//  Created by useok on 2022/09/11.
//

import UIKit
import CoreLocation
import MobileCoreServices
import RealmSwift

final class WriteViewController: BaseViewController  {
    
    let writeView = WriteView()
    
    override func loadView() {
        super.view = writeView
    }
    
    let picker = UIImagePickerController()

    var imageArrayString: [String] = []
    var imageArrayUIImage: [UIImage] = []
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    let writeViewCell = WriteCollectionViewCell()
    
    var tag: Int?
    
    lazy var pickerSelect: [String] = Picker.allCases.map{return $0.pickerLisk[0]} //3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(repository.localRealm.configuration.fileURL!)
        navigationItem.title = "타임 캡슐 묻기"
        let right = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonClicked))
        right.setTitleTextAttributes([NSAttributedString.Key.font : AppFont.font.name as Any ], for: .normal)
        navigationItem.rightBarButtonItem = right
        
        picker.delegate = self
        writeView.pickerView.dataSource = self
        writeView.pickerView.delegate = self
        writeView.opendateInput.inputView = writeView.pickerView
        
        writeView.collectionview.delegate = self
        writeView.collectionview.dataSource = self
        configToolbar()
        
        writeView.titleInput.delegate = self
        writeView.opendateInput.delegate = self
        
    }
}

extension WriteViewController: UITextFieldDelegate {
    // 키보드 여백 누를떄
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}


extension WriteViewController {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text?.count == 0 {
            textField.text = "  "
        }
    }
    
    //MARK: 피커뷰 위한 툴바
    func configToolbar() { // 4
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.backgroundColor = .black
        toolBar.sizeToFit()
        
        let doneBT = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(self.donePicker))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelBT = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(self.cancelPicker))
        
        toolBar.setItems([cancelBT,flexibleSpace,doneBT], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        writeView.opendateInput.inputAccessoryView = toolBar
    }
    //    //MARK: 피커 선택
    @objc func donePicker() { //4
        let row = self.writeView.pickerView.selectedRow(inComponent: 0)
        self.writeView.pickerView.selectRow(row, inComponent: 0, animated: false)
        let text = pickerSelect[row].split(separator: ":")
        
        self.writeView.opendateInput.text = " "+String(text[1])
        self.writeView.opendateInput.resignFirstResponder()
    }
    //    //MARK: 피커 취소
    @objc func cancelPicker() { //4
        self.writeView.opendateInput.text = nil
        self.writeView.opendateInput.resignFirstResponder()
    }
    
    //MARK: 저장하기 버튼클릭
    @objc func saveButtonClicked() {
        // 제목이 nil인지,입력여부 확인
        guard (writeView.titleInput.text != nil) && (writeView.titleInput.text!.count != 0) else {
            showAlertMessage(title: "작성자를 입력해주세요", button: "확인")
            return
        }
        //오픈일 nil인지,입력여부 확인
        guard  (writeView.opendateInput.text != nil) && (writeView.opendateInput.text!.count > 2 )else {
            showAlertMessage(title: "열리는날짜를 선택해주세요", button: "확인")
            return
        }
        self.saveStart()
//        let alert = UIAlertController(title: "주의", message: "캡슐이 열리기까지 캡슐을 삭제할수없습니다.", preferredStyle: UIAlertController.Style.alert)
//        let ok = UIAlertAction(title: "확인", style: .default) { (action) in
//            self.saveStart()
//        }

//        let cancel = UIAlertAction(title: "취소하기", style: .cancel)
//
//        alert.addAction(ok)
//        alert.addAction(cancel)
//        present(alert,animated: true)
    }
    
    func saveStart() {
        //MARK: 거리 계산하는 매소드
        let task = EggTime(title: writeView.titleInput.text!,
                           regDate: repository.stringToDate(string: writeView.dateInput.text ?? ""),
                           openDate: repository.stringToDate(string: writeView.opendateInput.text ?? "")  ,
                           content: writeView.writeTextView.text,
                           latitude: UserDefaults.standard.double(forKey: "lat") ,
                           longitude: UserDefaults.standard.double(forKey: "lng") ,
                           imageStringArray: imageArrayString)
        
        do {
            try repository.localRealm.write {
                repository.localRealm.add(task)
                var cnt: Int = 0
                imageArrayUIImage.forEach {
                    saveImageToDocument(fileName: "\(task.imageList[cnt])", image: $0)
                    cnt+=1
                }
                imageArrayUIImage.removeAll()
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
}



extension WriteViewController: UINavigationControllerDelegate {
    // MARK: - Selectors
    @objc private func handleDatePicker(_ sender: UIDatePicker) {
        print(sender.date)
    }
}


extension WriteViewController: UIImagePickerControllerDelegate {

    //MARK: 갤러리 선택
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
    //MARK: 카메라 선택
    @objc func cameraStart() {
        
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { // .camera
            print("사용불가+사용자에게 토스트/얼럿띄움")
            return
        }
        picker.sourceType = .camera //카메라로 띄우겟다 // photolibrary로하면 갤러리가 뜸 camera하면 camera뜸
        picker.allowsEditing = true // 카메라 찍은뒤 편집할수있냐없냐 default는 false임. //이게있어서 찍은뒤 편집화면이 보일수있는거
        present(picker, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! NSString
        
        if mediaType.isEqual(to: kUTTypeImage as NSString as String) {
            
            let selectImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            
            if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
                let imgName = UUID().uuidString+".jpeg"
                let documentDirectory = NSTemporaryDirectory()
                let localPath = documentDirectory.appending(imgName)
                let data = selectImage!.jpegData(compressionQuality: 0.3)! as NSData
                data.write(toFile: localPath, atomically: true)
                let photoURL = URL.init(fileURLWithPath: localPath)
                if imageArrayUIImage.count == tag! {
                    imageArrayString.append(imgName)
                    imageArrayUIImage.append(selectImage!)
                } else{
                    imageArrayString[tag!] = imgName
                    imageArrayUIImage[tag!] = selectImage!
                }
                writeView.collectionview.reloadData()
                picker.dismiss(animated: true, completion: nil)
            }
            
            else if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
                
                let imageUrl=info[UIImagePickerController.InfoKey.imageURL] as? NSURL
                let imageName=imageUrl?.lastPathComponent//파일이름
                
                if imageArrayUIImage.count == tag! {
                    imageArrayString.append(imageName!)
                    imageArrayUIImage.append(selectImage!)
                } else{
                    imageArrayString[tag!] = imageName!
                    imageArrayUIImage[tag!] = selectImage!
                }
                writeView.collectionview.reloadData()
                dismiss(animated: true)
            }
            
            //UIImagePickerController5: 취소버튼 클릭시
            func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
                dismiss(animated: true)
            }
        }
    }
}


