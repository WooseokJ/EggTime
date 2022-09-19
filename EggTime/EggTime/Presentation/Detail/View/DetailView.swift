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
//        label.backgroundColor = Constants.imageBackground.color
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        return label
    }()
    //오픈날짜
    let openDateLabel: UILabel = {
       let label = UILabel()
//        label.backgroundColor = Constants.imageBackground.color
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        return label
        
    }()
    
    //제목
    let titleLabel: UILabel = {
        let label = UILabel()
//        label.backgroundColor = Constants.imageBackground.color
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    //내용라벨:
    let contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 0
        label.text = "[내용]"
        return label
    }()
    

    //내용
    let content: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.backgroundColor = Constants.background.color
        textView.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        textView.textColor = .white
        return textView
    }()
    
    
    //MARK: 뷰 등록
    override func configure() {
        [collectionview,dateLabel,openDateLabel,titleLabel,contentLabel,content].forEach {
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
            $0.height.equalTo(300)
        }
        // 날짜
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(collectionview.snp.bottom).offset(10)
            $0.trailing.equalTo(-80)
            $0.leading.equalTo(collectionview.snp.leading)
            $0.height.equalTo(40)
        }
        
        // 오픈날짜
        openDateLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(10)
            $0.trailing.equalTo(dateLabel.snp.trailing)
            $0.leading.equalTo(dateLabel.snp.leading)
            $0.height.equalTo(dateLabel.snp.height)
        }
        
        // 제목라벨
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(openDateLabel.snp.bottom).offset(10)
            $0.trailing.equalTo(-80)
            $0.leading.equalTo(80)
            $0.height.equalTo(40)
        }

        //내용라벨
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.trailing.equalTo(-80)
            $0.leading.equalTo(80)
            $0.height.equalTo(40)
        }
        
        // 내용
        content.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(5)
            $0.trailing.equalTo(titleLabel.snp.trailing)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.bottom.greaterThanOrEqualTo(self.safeAreaLayoutGuide).offset(-20)
        }
        
    }
    
}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let detailInfo = repository.localRealm.objects(EggTime.self).filter("objectId = %@",objectid)
        print(detailInfo[0].imageList.count)
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
        let detailInfo = repository.localRealm.objects(EggTime.self).filter("objectId = %@",objectid )

        print(detailInfo[0].title)
        detailView.dateLabel.text = "[등록일] " + repository.dateToString(date: detailInfo[0].regDate)
        detailView.openDateLabel.text = "[개봉일] " + repository.dateToString(date: detailInfo[0].openDate)
        detailView.titleLabel.text = "[제목] \(detailInfo[0].title)"
        detailView.content.text =  "\(detailInfo[0].content)"

        print("DB lat:"+"\(detailInfo[0].latitude!)")
        print("DB lng:"+"\(detailInfo[0].longitude!)")
        
        guard indexPath.item >= detailInfo[0].imageList.count else {
            cell.imageView.contentMode = .scaleToFill
            cell.imageView.image = loadImageFromDocument(fileName: detailInfo[0].imageList[indexPath.item])
            return cell
        }
        
        cell.imageView.image = UIImage(named: "NoImage")
        
        
        return cell
    }
}
