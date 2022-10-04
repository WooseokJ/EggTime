//
//  WriteView.swift
//  EggTime
//
//  Created by useok on 2022/09/11.
//

import Foundation

import SnapKit
import UIKit
//import YPImagePicker

class WriteView: BaseView {
    //MARK: 연결
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    //MARK: 크기
    // 제목
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "작성자"
        label.textColor = AllColor.textColor.color
        label.font = AllFont.font.title
//        label.backgroundColor  = .red
        return label
    }()
    //제목입력
    lazy var titleInput: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.font = AllFont.font.name
        textField.placeholder = "  작성자명을 입력해주세요."
        textField.backgroundColor = AllColor.textColor.textInputColor
        textField.layer.cornerRadius = 10
        textField.clipsToBounds = true
        return textField
    }()
    //제목 스택뷰
    lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel,titleInput] )
        stackView.axis = .horizontal // default
        stackView.distribution = .fill // default
        stackView.alignment = .fill // default
        return stackView
    }()
    
    // 등록일
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "캡슐 묻은 날짜"
        label.textColor = AllColor.textColor.color
        label.font = AllFont.font.title
//        label.backgroundColor  = .red

        return label
    }()
    // 등록일 입력
    lazy var dateInput: UILabel = {
        let label = UILabel()
        let dateformattor = DateFormatter()
        dateformattor.dateFormat = "yyyy-MM-dd"
        label.text = "  " + dateformattor.string(from: Date())
        label.textColor = .black
        label.font = AllFont.font.name
        label.backgroundColor =  AllColor.textColor.textInputColor
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        return label
    }()
    // 등록일 스택뷰
    lazy var dateStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dateLabel,dateInput] )
        return stackView
    }()
    
    
    // 오픈일
    lazy var openLabel: UILabel = {
        let label = UILabel()
        label.text = "캡슐 열리는 날짜"
        label.textColor = AllColor.textColor.color
        label.font = AllFont.font.title
//        label.backgroundColor  = .red

        return label
    }()
    // 오픈일 입력
    lazy var opendateInput: UITextField = {
        let textField = UITextField()
        textField.backgroundColor =  AllColor.textColor.textInputColor
        textField.textColor = .black
        textField.font = AllFont.font.name
        textField.placeholder = "  캡슐 여는날짜을 선택해주세요."
        textField.layer.cornerRadius = 10
        textField.clipsToBounds = true
        return textField
    }()
    // 오픈일 스택뷰
    lazy var openStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [openLabel,opendateInput] )
        return stackView
    }()
    //
    lazy var pickerView = UIPickerView()
    
    
    // 글쓰기
    lazy var writeLabel: UILabel = {
        let label = UILabel()
        label.text = "캡슐에 담을 내용"
        label.textColor = AllColor.textColor.color
        label.font = AllFont.font.title
//        label.backgroundColor  = .red

        return label
    }()
    //
    lazy var writeTextView: UITextView = {
        let textview = UITextView()
        textview.backgroundColor =  AllColor.textColor.textInputColor
        textview.textColor = .black
        textview.font = AllFont.font.name
        textview.layer.cornerRadius = 10
        textview.clipsToBounds = true
        return textview
    }()
    
    // 이미지
    lazy var imageLabel: UILabel = {
        let label = UILabel()
        label.text = "이미지"
        label.textColor = AllColor.textColor.color
        label.font = AllFont.font.title
//        label.backgroundColor  = .red

        return label
    }()
    // 이미지 컬렉션뷰
    lazy var collectionview: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let spacing : CGFloat = 20
        let layoutwidth = UIScreen.main.bounds.width // - (spacing * 2)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 1.6  , height: UIScreen.main.bounds.width / 1.3 )
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: spacing)
//        layout.minimumLineSpacing = spacing
//        layout.minimumInteritemSpacing = spacing
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        cv.backgroundView = UIImageView(image: UIImage(named: "BackgroundImage"))
        cv.register(WriteCollectionViewCell.self, forCellWithReuseIdentifier: WriteCollectionViewCell.reuseIdentifier)
        cv.layer.cornerRadius = 10
        cv.clipsToBounds = true
        cv.backgroundColor = .clear
//        cv.backgroundColor = .blue
        return cv
    }()
    

    
    func stringDate(date: Date) -> String{
        let dateformattor = DateFormatter()
        dateformattor.dateFormat = "yyyy-MM-dd"
        return dateformattor.string(from: date)
    }
    //MARK: 뷰등록
    
    override func configure() {
        [backGroundView,
         titleLabel,titleInput,
         dateLabel,dateInput,
         openLabel,opendateInput
         ,writeLabel,writeTextView,
         imageLabel,collectionview].forEach {
            self.addSubview($0)
        }
    }
    
    //MARK: 위치
    override func setConstrains() {
        backGroundView.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
        //제목
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(10)
            $0.width.equalTo(UIScreen.main.bounds.width / 3)
            $0.height.equalTo(UIScreen.main.bounds.height / 23)
            $0.leading.equalTo(20)


        }
        titleInput.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.top)
            $0.leading.equalTo(titleLabel.snp.trailing).offset(10)
            $0.trailing.equalTo(-20)
            $0.height.equalTo(titleLabel.snp.height)
        }
        
        

        
        //등록일
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.width.equalTo(titleLabel.snp.width)
            $0.height.equalTo(titleLabel.snp.height)
            $0.leading.equalTo(titleLabel.snp.leading)
        }
        dateInput.snp.makeConstraints {
            $0.width.equalTo(titleInput.snp.width)
            $0.height.equalTo(titleInput.snp.height)
            $0.top.equalTo(dateLabel.snp.top)
            $0.leading.equalTo(dateLabel.snp.trailing).offset(10)
        }
        
        

        
        //개봉일
        openLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(10)
            $0.width.equalTo(titleLabel.snp.width)
            $0.height.equalTo(titleLabel.snp.height)
            $0.leading.equalTo(titleLabel.snp.leading)
        }
        opendateInput.snp.makeConstraints {
            $0.width.equalTo(titleInput.snp.width)
            $0.height.equalTo(titleInput.snp.height)
            $0.top.equalTo(openLabel.snp.top)
            $0.leading.equalTo(openLabel.snp.trailing).offset(10)
        }
        
        
        

//
//        //글쓰기
        writeLabel.snp.makeConstraints {
            $0.top.equalTo(openLabel.snp.bottom).offset(10)
            $0.width.equalTo(titleLabel.snp.width)
            $0.height.equalTo(titleLabel.snp.height)
            $0.leading.equalTo(titleLabel.snp.leading)
        }
        //글쓰기 입력
        writeTextView.snp.makeConstraints {
            $0.top.equalTo(writeLabel.snp.bottom).offset(10)
            $0.leading.equalTo(writeLabel.snp.leading)
            $0.trailing.equalTo(opendateInput.snp.trailing)
            $0.bottom.equalTo(imageLabel.snp.top).offset(-10)
        }
        
////        //이미지
        imageLabel.snp.makeConstraints {
            $0.bottom.equalTo(collectionview.snp.top).offset(-10)
            $0.width.equalTo(titleLabel.snp.width)
            $0.height.equalTo(titleLabel.snp.height)
            $0.leading.equalTo(titleLabel.snp.leading)
        }
        collectionview.snp.makeConstraints {
            $0.bottom.equalTo(self).offset(-20)
            $0.height.equalTo(UIScreen.main.bounds.width / 1.3)
            $0.leading.equalTo(writeTextView.snp.leading)
            $0.trailing.equalTo(writeTextView.snp.trailing)
        }
    }
}

extension WriteViewController: UIPickerViewDelegate,UIPickerViewDataSource {
    //피커 몇개고를거냐?
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerSelect.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerSelect[row]
    }
    
  
}


extension WriteViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArrayUIImage.count + 1
    }
    func resizeImage(image: UIImage, width: CGFloat, height: CGFloat) -> UIImage {
           UIGraphicsBeginImageContext(CGSize(width: width, height: height))
           image.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
           let newImage = UIGraphicsGetImageFromCurrentImageContext()
           UIGraphicsEndImageContext()
           return newImage!
       }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WriteCollectionViewCell.reuseIdentifier, for: indexPath) as? WriteCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = true
        
        
        cell.imageView.image = UIImage(named: "imageupload")
        cell.imageView.contentMode = .scaleToFill
        
        guard indexPath.item >= imageArrayUIImage.count else {
            cell.imageView.image = imageArrayUIImage[indexPath.item]
            
            return cell
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


