

import UIKit

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let backGroundView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "BackgroundImage")
        return image
    }()
    
    func configure() {
        self.addSubview(backGroundView)
    }
    func setConstrains() {
        backGroundView.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
    }
    
}
