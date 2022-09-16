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

    var tag: Int?
    
    var tasks: Results<EggTime>! {
        didSet {
            detailView.collectionview.reloadData()
            print("collectionview Tasks Changed")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailView.collectionview.dataSource = self
        detailView.collectionview.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "삭제", style: .plain, target: self, action: #selector(showAlertDeleteMessage))
        detailView.contentLabel.sizeToFit()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tasks = repository.fetch()
    }

}

extension DetailViewController {
    
    @objc func showAlertDeleteMessage() {
        let alert = UIAlertController(title: "알림", message: "정말로 삭제하시겠습니까?", preferredStyle: .alert)
        
        let okay = UIAlertAction(title: "삭제", style: .destructive) {(action) in
            self.deleteButtonClicked()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(okay)
        alert.addAction(cancel)
        present(alert,animated: true)
    }
    
    func deleteButtonClicked() {
        guard let tagNotNil = tag else {
            return
        }
        let item = tasks[tagNotNil]
        repository.deleteItem(item: item)
        ListView().collectionview.reloadData()
        self.navigationController?.popViewController(animated: true)
    }
    
}
