
import UIKit
import SnapKit

class ListCollectionViewCell: BaseCollectionViewCell {
    //MARK: 연결
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: 컬렉션뷰 안의 내용크기
    let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "BackgroundImage")
//        imageView.layer.cornerRadius = imageView.frame.height / 2
//        imageView.clipsToBounds = true
        return imageView
    }()
    
    let dateLabel : UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        label.textColor = AllColor.textColor.color
        label.font = UIFont(name: "SongMyung-Regular", size: 16.0)

        return label
    }()
    
    
    
    //MARK: 컬렉션뷰에 등록
    override func configure() {
        [dateLabel,imageView].forEach {
            self.contentView.addSubview($0)
        }
    }
    
    
    //MARK: 컬렉션뷰 안의 위치
    override func setConstrains() {
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(0)
            $0.leading.trailing.equalTo(0)
            $0.bottom.equalTo(-50)
            
        }

        dateLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(10)
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
            $0.leading.trailing.equalTo(0)
        }
    }
    
    

}

