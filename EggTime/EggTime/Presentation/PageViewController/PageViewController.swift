//
//  PageViewController.swift
//  EggTime
//
//  Created by useok on 2022/09/14.
//

import UIKit

class PageViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    //MARK: 크기
    lazy var vc1: UIViewController = {
           let vc = UIViewController()
           vc.view.backgroundColor = .red

           return vc
       }()

       lazy var vc2: UIViewController = {
           let vc = UIViewController()
           vc.view.backgroundColor = .green

           return vc
       }()

       lazy var vc3: UIViewController = {
           let vc = UIViewController()
           vc.view.backgroundColor = .blue

           return vc
       }()
       
       lazy var dataViewControllers: [UIViewController] = {
           return [vc1, vc2, vc3]
       }()
    lazy var pageViewController: UIPageViewController = {
          let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)

          return vc
      }()
    
    

   

}
