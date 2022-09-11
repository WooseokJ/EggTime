
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
    let imageButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = Constants.imageBackground.color
        button.layer.cornerRadius = button.frame.height / 2

        button.clipsToBounds = true
        return button
    }()
    
    let dateLabel : UILabel = {
        let label = UILabel()
        label.backgroundColor = .lightGray
        return label
    }()
    
    
    
    //MARK: 컬렉션뷰에 등록
    override func configure() {
        [imageButton,dateLabel].forEach {
            self.addSubview($0)
        }
    }
    
    
    //MARK: 컬렉션뷰 안의 위치
    override func setConstrains() {
        
        imageButton.snp.makeConstraints {
            $0.top.equalTo(0)
            $0.leading.trailing.equalTo(0)
            $0.bottom.equalTo(-50)
            
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(imageButton.snp.bottom).offset(10)
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
            $0.leading.trailing.equalTo(0)
            
            
        }
    }
    
    

}
