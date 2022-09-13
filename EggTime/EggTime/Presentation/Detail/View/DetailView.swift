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
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        return label
    }()
    //오픈날짜
    let openDateLabel: UILabel = {
       let label = UILabel()
//        label.backgroundColor = Constants.imageBackground.color
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        return label
        
    }()
    
    //제목
    let titleLabel: UILabel = {
        let label = UILabel()
//        label.backgroundColor = Constants.imageBackground.color
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    //내용
    let contentLabel: UILabel = {
       let label = UILabel()
        label.backgroundColor = Constants.imageBackground.color
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    
    //MARK: 뷰 등록
    override func configure() {
        [collectionview,dateLabel,openDateLabel,titleLabel,contentLabel].forEach {
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
            $0.top.equalTo(collectionview.snp.bottom).offset(15)
            $0.trailing.equalTo(-80)
            $0.leading.equalTo(collectionview.snp.leading)
            $0.height.equalTo(40)
        }
        
        // 오픈날짜
        openDateLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(15)
            $0.trailing.equalTo(dateLabel.snp.trailing)
            $0.leading.equalTo(dateLabel.snp.leading)
            $0.height.equalTo(dateLabel.snp.height)
        }
        
        // 제목
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(openDateLabel.snp.bottom).offset(30)
            $0.trailing.equalTo(-80)
            $0.leading.equalTo(80)
            $0.height.equalTo(40)
        }
        // 내용
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.trailing.equalTo(titleLabel.snp.trailing)
            $0.leading.equalTo(titleLabel.snp.leading)
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
        let s = repository.localRealm.objects(RealmModel.self).filter("objectId = %@",objectid)


        detailView.dateLabel.text = "등록일: " + repository.dateToString(date: s[0].regDate)
        detailView.openDateLabel.text = "개봉일: " + repository.dateToString(date: s[0].openDate)
        detailView.titleLabel.text = "제목: \(s[0].title)"
        detailView.contentLabel.text =  "내용: \(s[0].content)"

        cell.backgroundColor = Constants.imageBackground.color
    
        return cell
    }
}
