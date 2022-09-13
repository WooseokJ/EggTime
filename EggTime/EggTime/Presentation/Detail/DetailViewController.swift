//
//  DetailViewController.swift
//  EggTime
//
//  Created by useok on 2022/09/11.
//

import UIKit

import RealmSwift
class DetailViewController: BaseViewController {

    //MARK: 뷰 가져오기
    let detailView = DetailView()
    override func loadView() {
        super.view = detailView
    }
    
    var objectid: ObjectId? // 객체아이디 받아와 

    let repository = RealmRepository()

    var tasks: Results<RealmModel>! {
        didSet {
            detailView.collectionview.reloadData()
            print("collectionview Tasks Changed")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailView.collectionview.dataSource = self
        detailView.collectionview.delegate = self

    }

}
