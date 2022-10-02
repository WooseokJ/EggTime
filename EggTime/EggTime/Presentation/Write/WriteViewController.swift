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




class WriteViewController: BaseViewController, UITextFieldDelegate, CLLocationManagerDelegate {
    
    let writeView = WriteView()
    
    override func loadView() {
        
        super.view = writeView
    }
    
    let picker = UIImagePickerController()
    
    var imageArrayString: [String] = []
    var imageArrayUIImage: [UIImage] = []
    var tag: Int?
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    let writeViewCell = WriteCollectionViewCell()
    
    var tasks: Results<EggTime>!
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        picker.delegate = self
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "BackgroundImage")
        super.view = writeView
        
        print(repository.localRealm.configuration.fileURL!)
        
    }
    
    
    lazy var pickerSelect: [String] = Picker.allCases.map{return $0.pickerLisk[0]}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        writeView.pickerView.dataSource = self
        writeView.pickerView.delegate = self
        
        navigationItem.title = "타임 캡슐 묻기"
        let attributes = [
            NSAttributedString.Key.foregroundColor: AllColor.textColor.color,
            NSAttributedString.Key.font: AllFont.font.name
        ]
        navigationController?.navigationBar.titleTextAttributes = attributes
      
       
        
        let right = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonClicked))
        right.setTitleTextAttributes([NSAttributedString.Key.font : AllFont.font.name], for: .normal)
        
        navigationItem.rightBarButtonItem = right
   
        writeView.opendateInput.inputView = writeView.pickerView
        
        writeView.collectionview.delegate = self
        writeView.collectionview.dataSource = self
        configToolbar()
        
 
        
        writeView.titleInput.delegate = self
        writeView.opendateInput.delegate = self
        
        
        
    }
    // 키보드 여백눌러서 내리기
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
    func configToolbar() {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = AllColor.textColor.color
        toolBar.backgroundColor = .black
        toolBar.sizeToFit()
        
        let doneBT = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(self.donePicker))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelBT = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(self.cancelPicker))
        
        toolBar.setItems([cancelBT,flexibleSpace,doneBT], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        writeView.opendateInput.inputAccessoryView = toolBar
    }
    //MARK: 피커 선택
    @objc func donePicker() {
        let row = self.writeView.pickerView.selectedRow(inComponent: 0)
        self.writeView.pickerView.selectRow(row, inComponent: 0, animated: false)
        let text = pickerSelect[row].split(separator: ":")
        
        self.writeView.opendateInput.text = " "+String(text[1])
        self.writeView.opendateInput.resignFirstResponder()
    }
    //MARK: 피커 취소
    @objc func cancelPicker() {
        self.writeView.opendateInput.text = nil
        self.writeView.opendateInput.resignFirstResponder()
    }
    
    //MARK: 저장하기 버튼클릭
    @objc func saveButtonClicked() {
        // 제목이 nil인지,입력여부 확인
        guard (writeView.titleInput.text != nil) && (writeView.titleInput.text?.count != 0) else {
            showAlertMessage(title: "제목을 입력해주세요", button: "확인")
            return
        }
        //오픈일 nil인지,입력여부 확인
        guard  (writeView.opendateInput.text != nil) && (writeView.opendateInput.text?.count != 0 )else {
            showAlertMessage(title: "오픈일을 선택해주세요", button: "확인")
            return
        }
        
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
        
        
        //        fetchDocumentZipFile() //확인용
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    //MARK: 수정하기 버튼클릭
    @objc func modifyButtonClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
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
    
    
}



//UIImagePickerControllerDelegate = 이미지를 선택하고 카메라를 찍었을 때 다양한 동작을 도와줍니다.
//UINavigationControllerDelegate = 앨범 사진을 선택했을 때, 화면 전환을 네비게이션으로 이동합니다.

extension WriteViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //UIImagePickerController4 : 사진성택하거나 카메라 촬영직후
    //카메라나 앨범등 PickerController가 사용되고 이미지 촬영을 했을 때 발동 된다.
    
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
                let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
                let photoURL          = NSURL(fileURLWithPath: documentDirectory)
                //                let localPath         = photoURL.appendingPathComponent(imageName!)//이미지 파일경로
                
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


