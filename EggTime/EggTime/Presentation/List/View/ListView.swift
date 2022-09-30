

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
//        cv.backgroundView = UIImageView(image: UIImage(named: "BackgroundImage"))
        cv.backgroundColor = .clear
        cv.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: ListCollectionViewCell.reuseIdentifier)
        cv.layer.cornerRadius = 10
        cv.clipsToBounds = true
        return cv
    }()
    
    
    
    //MARK: 뷰등록
    override func configure() {
        [backGroundView,collectionview].forEach {
            self.addSubview($0)
        }
    }
    
    
    //MARK: 위치
    override func setConstrains() {
        backGroundView.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
        
        collectionview.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.bottom.equalTo(0)
            $0.trailing.leading.equalTo(self.safeAreaLayoutGuide)
        }
    }

}

extension ListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionViewCell.reuseIdentifier, for: indexPath) as? ListCollectionViewCell else {
            return UICollectionViewCell()
        }
//        cell.imageView.layer.cornerRadius = cell.frame.height / 3.5
        print(tasks[indexPath.row].openDate)
        print(repository.dateToString(date: tasks[indexPath.row].openDate))
        cell.dateLabel.text = repository.dateToString(date: tasks[indexPath.row].openDate)
        cell.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.1)
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = true
        cell.titleLabel.text = tasks[indexPath.row].title
//        if tasks[indexPath.item].imageList.count == 0 {
//            cell.imageView.image = UIImage(named: "NoImage")
//            return cell
//        } else {
//            cell.imageView.image = loadImageFromDocument(fileName: tasks[indexPath.item].imageList[0])
//            return cell
//        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSpacing : CGFloat = 10
        let myWidth : CGFloat = (collectionView.bounds.width - itemSpacing * 2) / 3
        return CGSize(width: myWidth, height: myWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let openDate = tasks[indexPath.item].openDate
        var calendar = Calendar.current
        let date = Date()
        
        calendar.locale = Locale(identifier: "ko_KR")
        
        //요소 뽑아내기
        let todayYear = calendar.component(.year, from: date)
        let todayMonth = calendar.component(.month, from: date)
        let todayDay = calendar.component(.day, from: date)
        
        let openYear = calendar.component(.year, from: openDate)
        let openMonth = calendar.component(.month, from: openDate)
        let openDay = calendar.component(.day, from: openDate)
        print(todayYear,todayMonth,todayDay)
        print(openYear,openMonth,openDay)
        
        // 해당날짜인지 판단
        guard ((openYear <= todayYear) && (openMonth <= todayMonth) && (openDay <= todayDay)) else {
            let alert = UIAlertController(title: "아직 오픈날짜가 아닙니다.", message: "", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .cancel)
            alert.addAction(ok)
            present(alert,animated: true)
            return
        }
        
        //해당위치에서 열수있는지 판단
        guard openAvailable.contains(tasks[indexPath.item].objectId) else {
            
            let alert = UIAlertController(title: "현위치에서는 오픈할수없습니다.", message: "", preferredStyle: .alert)
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
        print(tasks[indexPath.item].objectId)
        vc.tag = indexPath.item
        
        
    }
    
}
