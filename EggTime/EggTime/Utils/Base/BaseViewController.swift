
import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setConstraints()
        view.backgroundColor = Constants.background.color
        TabBarController().tabBar.backgroundColor = .white
        
    }
    
    func configure() {}
    func setConstraints() {}
    
    


}
