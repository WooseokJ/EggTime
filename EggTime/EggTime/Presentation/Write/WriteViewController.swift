//
//  WriteViewController.swift
//  EggTime
//
//  Created by useok on 2022/09/11.
//

import UIKit
//import YPImagePicker
//import Kingfisher

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
        
        
        // 탭제스쳐로 키보드 내리기 
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
            action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
     
        
        configToolbar()
        
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}

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

        print(repository.localRealm.configuration.fileURL!)
        
        
        let task = EggTime(title: writeView.titleInput.text!, regDate: repository.stringToDate(string: writeView.dateInput.text ?? ""), openDate: repository.stringToDate(string: writeView.opendateInput.text ?? "")  , content: writeView.writeTextView.text, imageStringArray: ["eee","dsadf"] )
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
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}


extension WriteViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //UIImagePickerController4 : 사진성택하거나 카메라 촬영직후
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("가가")

        if let imgUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL {
            
            
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
                
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        tag = indexPath.item
        
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
