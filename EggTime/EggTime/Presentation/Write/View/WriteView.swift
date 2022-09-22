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
        label.text = "제목"
        label.textColor = .white
        return label
    }()
    //제목입력
    lazy var titleInput: UITextField = {
        let textField = UITextField()
        textField.textColor = .white
        textField.backgroundColor =  UIColor(red: 206/255, green: 215/255, blue: 220/255, alpha: 1.0)
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
        label.text = "등록일"
        label.textColor = .white
        return label
    }()
    // 등록일 입력
    lazy var dateInput: UILabel = {
        let label = UILabel()
        let dateformattor = DateFormatter()
        dateformattor.dateFormat = "yyyy-MM-dd hh:mm"
        label.text = dateformattor.string(from: Date())
        label.textColor = .white
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
        label.text = "오픈일"
        label.textColor = .white
        return label
    }()
    // 오픈일 입력
    lazy var opendateInput: UITextField = {
        let textField = UITextField()
        textField.backgroundColor =  UIColor(red: 206/255, green: 215/255, blue: 220/255, alpha: 1.0)
        textField.textColor = .white
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
        label.text = "글쓰기"
        label.textColor = .white
        return label
    }()
    //
    lazy var writeTextView: UITextView = {
        let textview = UITextView()
        textview.backgroundColor =  UIColor(red: 206/255, green: 215/255, blue: 220/255, alpha: 1.0)
        textview.textColor = .white
        return textview
    }()
    
    // 이미지
    lazy var imageLabel: UILabel = {
        let label = UILabel()
        label.text = "이미지"
        label.textColor = .white
        return label
    }()
    // 이미지 컬렉션뷰
    lazy var collectionview: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let spacing : CGFloat = 20
        let layoutwidth = UIScreen.main.bounds.width - (spacing * 4)
        layout.itemSize = CGSize(width: layoutwidth / 2.4, height: layoutwidth)
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: spacing, left: 0, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundView = UIImageView(image: UIImage(named: "BackgroundImage"))
        cv.register(WriteCollectionViewCell.self, forCellWithReuseIdentifier: WriteCollectionViewCell.reuseIdentifier)
        return cv
    }()
    

    
    func stringDate(date: Date) -> String{
        let dateformattor = DateFormatter()
        dateformattor.dateFormat = "yyyy-MM-dd"
        return dateformattor.string(from: date)
    }
    //MARK: 뷰등록
    
    override func configure() {
        [backGroundView,titleStackView,dateStackView,openStackView,writeLabel,writeTextView,imageLabel,collectionview].forEach {
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
            $0.width.equalTo(80)
            $0.height.equalTo(titleStackView.snp.height)
        }
        titleInput.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(20)
            $0.trailing.equalTo(-20)
            $0.height.equalTo(titleStackView.snp.height)
        }
        titleStackView.snp.makeConstraints {
            $0.top.equalTo(120)
            $0.leading.equalTo(30)
            $0.trailing.equalTo(-30)
            $0.height.equalTo(30)
        }
        
        //등록일
        dateLabel.snp.makeConstraints {
            $0.width.equalTo(titleLabel.snp.width)
            $0.height.equalTo(titleLabel.snp.height)
        }
        dateInput.snp.makeConstraints {
            $0.width.equalTo(titleInput.snp.width)
            $0.height.equalTo(titleInput.snp.height)
        }
        dateStackView.snp.makeConstraints {
            $0.top.equalTo(titleStackView.snp.bottom).offset(30)
            $0.leading.equalTo(titleStackView.snp.leading)
            $0.trailing.equalTo(titleStackView.snp.trailing)
            $0.height.equalTo(titleStackView.snp.height)
        }
        
        //개봉일
        openLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(30)
            $0.leading.equalTo(dateLabel.snp.leading)
            $0.trailing.equalTo(dateLabel.snp.trailing)
            $0.height.equalTo(dateLabel.snp.height)
        }
        opendateInput.snp.makeConstraints {
            $0.width.equalTo(dateInput.snp.width)
            $0.height.equalTo(dateInput.snp.height)
        }
        openStackView.snp.makeConstraints {
            $0.top.equalTo(dateStackView.snp.bottom).offset(30)
            $0.leading.equalTo(dateStackView.snp.leading)
            $0.trailing.equalTo(dateStackView.snp.trailing)
            $0.height.equalTo(dateStackView.snp.height)
        }
        
        //글쓰기
        writeLabel.snp.makeConstraints {
            $0.top.equalTo(openLabel.snp.bottom).offset(40)
            $0.leading.equalTo(openLabel.snp.leading)
            $0.height.equalTo(openLabel.snp.height)
        }
        //글쓰기 입력
        writeTextView.snp.makeConstraints {
            $0.top.equalTo(writeLabel.snp.bottom).offset(20)
            $0.leading.equalTo(writeLabel.snp.leading)
            $0.height.equalTo(200)
            $0.trailing.equalTo(opendateInput.snp.trailing)
        }
        //이미지
        imageLabel.snp.makeConstraints {
            $0.top.equalTo(writeTextView.snp.bottom).offset(20)
            $0.leading.equalTo(writeTextView.snp.leading)
            $0.height.equalTo(writeLabel.snp.height)
        }
        collectionview.snp.makeConstraints {
            $0.top.equalTo(imageLabel.snp.bottom).offset(20)
            $0.leading.equalTo(writeTextView.snp.leading)
            $0.trailing.equalTo(writeTextView.snp.trailing)
            $0.bottom.equalTo(-20)
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WriteCollectionViewCell.reuseIdentifier, for: indexPath) as? WriteCollectionViewCell else {
            return UICollectionViewCell()
        }
        
    
        guard indexPath.item >= imageArrayUIImage.count else {
            cell.imageView.image = imageArrayUIImage[indexPath.item]
            
            return cell
        }
        cell.imageView.contentMode = .scaleToFill
        cell.imageView.image = UIImage(named: "UploadImage")
        

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        tag = indexPath.item
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        let photo = UIAlertAction(title: "앨범", style: .default) { (action) in
            self.photoSelect()
        }
//        let camera = UIAlertAction(title: "카메라", style: .default) { action in
//            self.cameraStart()
//        }
        let cancel = UIAlertAction(title: "취소하기", style: .cancel)
        
        alert.addAction(photo)
//        alert.addAction(camera)
        alert.addAction(cancel)
        present(alert,animated: true)
    }

}

