
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
        super.configure()
        super.setConstrains()
        configure()
        setConstrains()
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
        label.font = AppFont.font.name
        label.textColor = AppColor.textColor.color
//        label.backgroundColor = .red
        return label
    }()
    
    let dateOutputLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColor.textColor.outputColor
        label.font = AppFont.font.name
        label.backgroundColor = AppColor.textColor.textInputColor
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        return label
    }()
    
    //오픈날짜
    let openDateLabel: UILabel = {
       let label = UILabel()
        label.font = AppFont.font.name
        label.textColor = AppColor.textColor.color
//        label.backgroundColor = .red
        return label
        
    }()
    
    let openOutputLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.font.name
        label.backgroundColor = AppColor.textColor.textInputColor
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.textColor = AppColor.textColor.outputColor
        
        return label
    }()
    
    //제목
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.font.name
        label.textColor = AppColor.textColor.color
        label.numberOfLines = 0
//        label.backgroundColor = .red
        return label
    }()
    
    let titleOutputLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.font.name
        label.backgroundColor = AppColor.textColor.textInputColor
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.textColor = AppColor.textColor.outputColor
        return label
    }()
    
    //내용라벨:
    let contentLabel: UILabel = {
        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.font = AppFont.font.name
        label.textColor = AppColor.textColor.color
        label.numberOfLines = 0
        label.text = "캡슐에 담은 내용"
//        label.backgroundColor = .red
        return label
    }()
    

    //내용
    let content: UITextView = {
        let textView = UITextView(frame: .zero)
//        textView.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        textView.backgroundColor = AppColor.textColor.textInputColor
        textView.font = AppFont.font.name
        textView.textColor = AppColor.textColor.outputColor
        textView.layer.cornerRadius = 10
        textView.clipsToBounds = true
        return textView
    }()
    
    
    //MARK: 뷰 등록
    override func configure() {
        [collectionview,dateLabel,dateOutputLabel,openDateLabel,openOutputLabel,titleLabel,titleOutputLabel,contentLabel,content].forEach {
            self.addSubview($0)
        }
    }
    
    
    
    //MARK: 위치
    override func setConstrains() {
        
        
        
        // 이미지
        collectionview.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.trailing.equalTo(0)
            $0.leading.equalTo(0)
            $0.height.equalToSuperview().multipliedBy(0.4)
        }
        
        // 날짜
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(collectionview.snp.bottom).offset(15)
            $0.leading.equalTo(collectionview.snp.leading).offset(22)
            $0.height.equalTo(UIScreen.main.bounds.height / 23)
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
        detailView.titleLabel.text = "작성자"
        detailView.titleOutputLabel.text = " "+detailInfo[0].title
        detailView.content.text = detailInfo[0].content
        
        cell.imageView.layer.cornerRadius = 15
        cell.imageView.clipsToBounds = true
        cell.imageView.contentMode = .scaleAspectFit

        guard indexPath.item >= detailInfo[0].imageList.count else {
            cell.imageView.image = loadImageFromDocument(fileName: detailInfo[0].imageList[indexPath.item])
            return cell
        }
        
        cell.imageView.image = UIImage(named: "NoImage")
        cell.backgroundColor = .blue
        return cell
    }
}

extension UIImage {
    func resizeImageTo(size: CGSize) -> UIImage? {
        // 비트맵 생성
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        // 비트맵 그래픽 배경에 이미지 다시 그리기
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        // 현재 비트맵 그래픽 배경에서 이미지 가져오기
        guard let resizedImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        // 비트맵 환경 제거
        UIGraphicsEndImageContext()
        // 크기가 조정된 이미지 반환
        return resizedImage
    }
}
