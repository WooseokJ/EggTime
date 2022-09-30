
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
        let layoutwidth = UIScreen.main.bounds.width  - (spacing * 2)
        layout.itemSize = CGSize(width: layoutwidth , height: layoutwidth )
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
//        cv.backgroundColor = .red
        
        cv.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.reuseIdentifier)
//        cv.layer.cornerRadius = 10
//        cv.clipsToBounds = true
        return cv
    }()
    
    //등록날짜
    let dateLabel: UILabel = {
       let label = UILabel()
        label.font = AllFont.font.name
        label.textColor = AllColor.textColor.color
        return label
    }()
    
    let dateOutputLabel: UILabel = {
        let label = UILabel()
        label.textColor = AllColor.textColor.outputColor
        label.font = AllFont.font.name
        label.backgroundColor = UIColor(red: 206/255, green: 215/255, blue: 220/255, alpha: 1.0)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        return label
    }()
    
    //오픈날짜
    let openDateLabel: UILabel = {
       let label = UILabel()
        label.font = AllFont.font.name
        label.textColor = AllColor.textColor.color

        return label
        
    }()
    
    let openOutputLabel: UILabel = {
        let label = UILabel()
        label.font = AllFont.font.name
        label.backgroundColor = UIColor(red: 206/255, green: 215/255, blue: 220/255, alpha: 1.0)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.textColor = AllColor.textColor.outputColor
        return label
    }()
    
    //제목
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = AllFont.font.name
        label.textColor = AllColor.textColor.color
        label.numberOfLines = 0

        return label
    }()
    
    let titleOutputLabel: UILabel = {
        let label = UILabel()
        label.font = AllFont.font.name
        label.backgroundColor = UIColor(red: 206/255, green: 215/255, blue: 220/255, alpha: 1.0)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.textColor = AllColor.textColor.outputColor
        return label
    }()
    
    //내용라벨:
    let contentLabel: UILabel = {
        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.font = AllFont.font.name
        label.textColor = AllColor.textColor.color
        label.numberOfLines = 0
        label.text = "전하고 싶은 내용"
        
        return label
    }()
    

    //내용
    let content: UITextView = {
        let textView = UITextView(frame: .zero)
//        textView.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        textView.backgroundColor = UIColor(red: 206/255, green: 215/255, blue: 220/255, alpha: 1.0)
        textView.font = AllFont.font.name
        textView.textColor = AllColor.textColor.outputColor
//        textView.backgroundColor = .clear
        textView.layer.cornerRadius = 10
        textView.clipsToBounds = true
        return textView
    }()
    
    
    //MARK: 뷰 등록
    override func configure() {
        [backGroundView,collectionview,dateLabel,dateOutputLabel,openDateLabel,openOutputLabel,titleLabel,titleOutputLabel,contentLabel,content].forEach {
            self.addSubview($0)
        }
    }
    
    
    
    //MARK: 위치
    override func setConstrains() {
        backGroundView.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
        // 이미지
        collectionview.snp.makeConstraints {
            $0.top.equalToSuperview().offset(80)
            $0.trailing.equalTo(0)
            $0.leading.equalTo(0)
            $0.height.equalToSuperview().multipliedBy(0.4)
//            $0.edges.equalTo(0)
        }
        
        // 날짜
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(collectionview.snp.bottom).offset(15)
            $0.leading.equalTo(collectionview.snp.leading).offset(22)
            $0.height.equalTo(40)
            $0.width.equalTo(100)
        }
        
        dateOutputLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.top)
            $0.leading.equalTo(dateLabel.snp.trailing).offset(10)
            $0.trailing.equalTo(-22)
            $0.height.equalTo(dateLabel.snp.height)
        }
        
        
        // 오픈날짜
        openDateLabel.snp.makeConstraints {
            $0.top.equalTo(dateOutputLabel.snp.bottom).offset(15)
            $0.trailing.equalTo(dateLabel.snp.trailing)
            $0.leading.equalTo(dateLabel.snp.leading)
            $0.height.equalTo(dateLabel.snp.height)
        }
        
        openOutputLabel.snp.makeConstraints {
            $0.top.equalTo(openDateLabel.snp.top)
            $0.trailing.equalTo(dateOutputLabel.snp.trailing)
            $0.leading.equalTo(dateLabel.snp.trailing).offset(10)
            $0.height.equalTo(dateLabel.snp.height)
        }
        
        // 제목라벨
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(openDateLabel.snp.bottom).offset(15)
            $0.trailing.equalTo(dateLabel.snp.trailing)
            $0.leading.equalTo(dateLabel.snp.leading)
            $0.height.equalTo(dateLabel.snp.height)
        }
        
        titleOutputLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.top)
            $0.leading.equalTo(titleLabel.snp.trailing).offset(10)
            $0.trailing.equalTo(dateOutputLabel.snp.trailing)
            $0.height.equalTo(titleLabel.snp.height)
        }

        //내용라벨
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(15)
            $0.trailing.equalTo(dateLabel.snp.trailing)
            $0.leading.equalTo(dateLabel.snp.leading)
            $0.height.equalTo(dateLabel.snp.height)
        }
     
        
        // 내용
        content.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(10)
            $0.trailing.equalTo(dateOutputLabel.snp.trailing)
            $0.leading.equalTo(dateLabel.snp.leading)
            $0.bottom.greaterThanOrEqualTo(self.safeAreaLayoutGuide).offset(-10)
        }
        
    }
    
}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let detailInfo = repository.localRealm.objects(EggTime.self).filter("objectId = %@",objectid as Any)
        if detailInfo[0].imageList.count == 0 {
            return 1
        } else {
            return detailInfo[0].imageList.count
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.reuseIdentifier, for: indexPath) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        let detailInfo = repository.localRealm.objects(EggTime.self).filter("objectId = %@",objectid as Any )

        
        detailView.dateLabel.text = "캡슐 묻은날짜"
        detailView.dateOutputLabel.text = "  "+repository.dateToString(date: detailInfo[0].regDate)
        detailView.openDateLabel.text = "캡슐 여는날짜"
        detailView.openOutputLabel.text = "  "+repository.dateToString(date: detailInfo[0].openDate)
        detailView.titleLabel.text = "캡슐 이름"
        detailView.titleOutputLabel.text = "  "+detailInfo[0].title
        detailView.content.text = detailInfo[0].content
        
        cell.imageView.layer.cornerRadius = 15
        cell.imageView.clipsToBounds = true
        
        guard indexPath.item >= detailInfo[0].imageList.count else {
            cell.imageView.contentMode = .scaleToFill
            cell.imageView.image = loadImageFromDocument(fileName: detailInfo[0].imageList[indexPath.item])
            return cell
        }
        
        cell.imageView.image = UIImage(named: "NoImage")
//        cell.backgroundView = UIImageView(image: UIImage(named: "BackGroundImage"))
        cell.backgroundColor = .blue
        return cell
    }
}
