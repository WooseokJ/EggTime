

import Foundation

import SnapKit
import UIKit

class ListView: BaseView {
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
    let collectionview : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let spacing : CGFloat = 8
        let layoutwidth = UIScreen.main.bounds.width - (spacing * 4)
        layout.itemSize = CGSize(width: (layoutwidth / 3), height: (layoutwidth / 3) * 1.8)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = Constants.background.color
        cv.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: ListCollectionViewCell.reuseIdentifier)
        return cv
    }()
    
    
    
    //MARK: 뷰등록
    override func configure() {
        [collectionview].forEach {
            self.addSubview($0)
        }
    }
    
    
    //MARK: 위치
    override func setConstrains() {
        collectionview.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
            $0.trailing.leading.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
  
    
}

extension ListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 40
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionViewCell.reuseIdentifier, for: indexPath) as? ListCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.imageButton.layer.cornerRadius = cell.frame.height / 3.5
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           let itemSpacing : CGFloat = 10
           
           let myWidth : CGFloat = (collectionView.bounds.width - itemSpacing * 2) / 3
           
           
           return CGSize(width: myWidth, height: myWidth)
       }
    
    
}
