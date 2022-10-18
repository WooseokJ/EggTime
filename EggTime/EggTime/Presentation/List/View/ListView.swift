

import Foundation

import SnapKit
import UIKit

class ListView: BaseView {
    //MARK: 연결
    override init(frame: CGRect) {
        super.init(frame: frame)
        super.configure()
        super.setConstrains()
        configure()
        setConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: 크기
    
    let contentlabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = AllFont.font.name
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
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
        cv.backgroundColor = .clear
        cv.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: ListCollectionViewCell.reuseIdentifier)
        return cv
    }()
    
    
    
    //MARK: 뷰등록
    override func configure() {
        [contentlabel,collectionview].forEach {
            self.addSubview($0)
        }
    }
    
    
    //MARK: 위치
    override func setConstrains() {
        
        collectionview.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.bottom.equalTo(0)
            $0.trailing.leading.equalTo(self.safeAreaLayoutGuide)
        }
    }

}

extension ListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return repository.tasks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionViewCell.reuseIdentifier, for: indexPath) as? ListCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.dateLabel.text = repository.dateToString(date: tasks[indexPath.row].openDate)
        cell.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.1)
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = true
        cell.titleLabel.text = "\(tasks[indexPath.row].title)님의 캡슐"
        cell.imageView.image = UIImage(named: "Egg2")
        cell.imageView.contentMode = .scaleAspectFit
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSpacing : CGFloat = 10
        let myWidth : CGFloat = (collectionView.bounds.width - itemSpacing * 2) / 3
        return CGSize(width: myWidth, height: myWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let opendate = tasks[indexPath.item].openDate
        
        var calendar = Calendar.current
        let koreaOpenDate = calendar.date(byAdding: .day, value: +1, to: opendate)!
        calendar.locale = Locale(identifier: "ko_KR")
        let openSelect = calendar.dateComponents([.year,.month,.day], from: Date(), to: koreaOpenDate)
        
        // 해당날짜인지 판단
        guard ((openSelect.year! <= 0) && (openSelect.month! <= 0) && (openSelect.day! <= 0)) else {
            let alert = UIAlertController(title: "아직 오픈날짜가 아닙니다.", message: "", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .cancel)
            alert.addAction(ok)
            present(alert,animated: true)
            return
        }
                
        //오픈
        let vc = DetailViewController()
        transition(vc,transitionStyle: .push)
        vc.navigationItem.backBarButtonItem?.tintColor = AllColor.textColor.color
        vc.navigationItem.title = "\(indexPath.row+1)번쨰 타임 캡슐"
        vc.objectid = tasks[indexPath.item].objectId
        
    }
    
}


