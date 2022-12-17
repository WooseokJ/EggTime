
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
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.textColor = AppColor.textColor.color
        label.font = AppFont.font.name
        label.numberOfLines = 0
        return label
    }()
    
    let dateLabel : UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.textColor = AppColor.textColor.color
        label.font = AppFont.font.name
        return label
    }()
    
    
    
    //MARK: 컬렉션뷰에 등록
    override func configure() {
        [dateLabel,titleLabel,imageView].forEach { //imageView
            self.contentView.addSubview($0)
        }
    }
    
    
    //MARK: 컬렉션뷰 안의 위치
    override func setConstrains() {

        dateLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.bottom.equalTo(self.safeAreaLayoutGuide).offset(-10)
            $0.leading.trailing.equalTo(0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(5)
            $0.bottom.equalTo(dateLabel.snp.top).offset(-2)
            $0.leading.trailing.equalTo(0)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(30)
            $0.centerX.equalTo(self)
            $0.bottom.equalTo(-90)
        }
    }
    
    

}

