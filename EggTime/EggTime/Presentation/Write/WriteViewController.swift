//
//  WriteViewController.swift
//  EggTime
//
//  Created by useok on 2022/09/11.
//

import UIKit
import YPImagePicker
//import Kingfisher
import CoreLocation
import MobileCoreServices
import RealmSwift

class WriteViewController: BaseViewController, UITextFieldDelegate, CLLocationManagerDelegate, UNUserNotificationCenterDelegate {
    
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
    
    let notificationCenter = UNUserNotificationCenter.current() // 알람할떄 선행되야됨.
    var tasks: Results<EggTime>!


    
    override func viewWillAppear(_ animated: Bool) {
        picker.delegate = self
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "BackgroundImage")
        super.view = writeView

        print(repository.localRealm.configuration.fileURL!)

    }
    
    lazy var pickerSelect: [String] = Picker.allCases.map{$0.pickerLisk[0]}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        writeView.pickerView.dataSource = self
        writeView.pickerView.delegate = self
        
        navigationItem.title = "캡슐 묻기"
        let attributes = [
            NSAttributedString.Key.foregroundColor: AllColor.textColor.color,
            NSAttributedString.Key.font: AllFont.font.name
        ]
        //2
        navigationController?.navigationBar.titleTextAttributes = attributes
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image:UIImage(systemName: "plus.app"), style: .plain, target: self, action: #selector(saveButtonClicked))
       
        writeView.opendateInput.inputView = writeView.pickerView
        
        writeView.collectionview.delegate = self
        writeView.collectionview.dataSource = self
        configToolbar()
        
        notificationCenter.delegate = self
        
        requestAuthorization()


    }
    // 키보드 여백눌러서 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //MARK: notification 2. 권한요청
    func requestAuthorization(){
        let authOptions = UNAuthorizationOptions(arrayLiteral: .alert, .sound)

        notificationCenter.requestAuthorization(options: authOptions) { success, error in
               if let error = error {
                   print("Error: \(error)")
               }
           }
    }
    
    func sendNotification(){
        
        DispatchQueue.main.async { [self] in
            tasks = repository.localRealm.objects(EggTime.self)
            
            tasks.forEach {
                let notificationContent = UNMutableNotificationContent()
                notificationContent.title = "오늘은 오픈일입니다."
//                notificationContent.subtitle = "\($0.regDate)에 등록한 타임캡슐이 오픈할수있습니다. "
                notificationContent.body = "\($0.regDate)에 등록한 타임캡슐이 오픈할수있습니다. "
                print($0.openDate)
                
                var dateComponents = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: $0.openDate)
                
                
                print(dateComponents)
                
//                let dateComponents = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: date)
//                print(dateComponents)
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                
                let request = UNNotificationRequest(identifier: "sani", content: notificationContent, trigger: trigger)
                notificationCenter.add(request) { (error) in
                    print(error)
                }
            }
        }
    }
    
}

extension WriteViewController {
    
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
        let text = self.pickerSelect[row].split(separator: ":")
        self.writeView.opendateInput.text = String(text[1])
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
        sendNotification()
        
            //MARK: 거리 계산하는 매소드
        print(writeView.dateInput.text)
        print(writeView.opendateInput.text)
        
        let task = EggTime(title: writeView.titleInput.text!,
                           regDate: repository.stringToDate(string: writeView.dateInput.text ?? ""),
                           openDate: repository.stringToDate(string: writeView.opendateInput.text ?? "")  ,
                           
                           content: writeView.writeTextView.text,
                           latitude: UserDefaults.standard.double(forKey: "lat") ,
                           longitude: UserDefaults.standard.double(forKey: "lng") ,
                           imageStringArray: imageArrayString)
        print(repository.stringToDate(string: writeView.dateInput.text ?? ""))
        print(repository.stringToDate(string: writeView.opendateInput.text ?? ""))
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
        let picker = YPImagePicker() //권한요청 메소드는 안에있어.
        picker.didFinishPicking { [self, unowned picker] items, _ in
            if let photo = items.singlePhoto {
                
                let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
                let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
                let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
                let dirPath = paths.first
                let imageData = photo.image.jpegData(compressionQuality: 1)
                let imageURL = URL(fileURLWithPath: dirPath!).appendingPathComponent("YPImagePicker\(Date()).png")
                
                
                if imageArrayUIImage.count == tag! {
                    
                    imageArrayString.append(imageURL.lastPathComponent)
                    imageArrayUIImage.append(photo.image)
                } else{
                    imageArrayString[tag!] = imageURL.lastPathComponent
                    imageArrayUIImage[tag!] = photo.image
                }

                writeView.collectionview.reloadData()
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
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

            if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
                
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
                
                //                let data=NSData(contentsOf: imageUrl as! URL)!
                
                //사진첩(라이브러리)로 사진을 가져왔을때 로직구현
                
            }
            
        }
        //UIImagePickerController5: 취소버튼 클릭시
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true)
        }
    }
    
    
    
    
}
