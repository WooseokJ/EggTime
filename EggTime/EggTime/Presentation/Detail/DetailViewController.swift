//
//  DetailViewController.swift
//  EggTime
//
//  Created by useok on 2022/09/11.
//

import UIKit

class DetailViewController: BaseViewController {

    //MARK: 뷰 가져오기
    let detailView = DetailView()
    override func loadView() {
        super.view = detailView
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailView.collectionview.dataSource = self
        detailView.collectionview.delegate = self

    }

}
