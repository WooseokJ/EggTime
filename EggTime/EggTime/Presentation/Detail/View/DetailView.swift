//
//  DetailView.swift
//  EggTime
//
//  Created by useok on 2022/09/11.
//

import Foundation
import SnapKit
import UIKit

class DetailView: BaseView {
    
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
    //이미지
    let collectionview : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let spacing : CGFloat = 20
        let layoutwidth = UIScreen.main.bounds.width - (spacing * 4)
        layout.itemSize = CGSize(width: layoutwidth / 1.5, height: layoutwidth)
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = Constants.background.color
        cv.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.reuseIdentifier)
        return cv
    }()
    
    //날짜
    let dateLabel: UILabel = {
       let label = UILabel()
        label.backgroundColor = Constants.imageBackground.color
        return label
    }()
    
    //제목
    let titleTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = Constants.imageBackground.color
        return textField
    }()
    
    //내용
    let textView: UITextView = {
       let textview = UITextView()
        textview.backgroundColor = Constants.imageBackground.color
        return textview
    }()
    
    
    //MARK: 뷰 등록
    override func configure() {
        [collectionview,dateLabel,titleTextField,textView].forEach {
            self.addSubview($0)
        }
    }
    
    
    
    //MARK: 위치
    override func setConstrains() {
        // 이미지
        collectionview.snp.makeConstraints {
            $0.top.equalTo(100)
            $0.trailing.equalTo(0)
            $0.leading.equalTo(80)
            $0.height.equalTo(200)
        }
        // 날짜
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(collectionview.snp.bottom).offset(30)
            $0.trailing.equalTo(-80)
            $0.leading.equalTo(collectionview.snp.leading)
            $0.height.equalTo(40)
        }
        // 제목
        titleTextField.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(30)
            $0.trailing.equalTo(-80)
            $0.leading.equalTo(80)
            $0.height.equalTo(40)
        }
        // 내용
        textView.snp.makeConstraints {
            $0.top.equalTo(titleTextField.snp.bottom).offset(20)
            $0.trailing.equalTo(titleTextField.snp.trailing)
            $0.leading.equalTo(titleTextField.snp.leading)
            $0.bottom.equalTo(self.safeAreaLayoutGuide).offset(-40)
        }
        
    }
    
}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.reuseIdentifier, for: indexPath) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.backgroundColor = Constants.imageBackground.color
    
        return cell
    }
}
