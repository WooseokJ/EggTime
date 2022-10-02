//
//  DetailViewController.swift
//  EggTime
//
//  Created by useok on 2022/09/11.
//

import UIKit
import RealmSwift
import NMapsMap

class DetailViewController: BaseViewController {

    //MARK: 뷰 가져오기
    let detailView = DetailView()
    override func loadView() {
        super.view = detailView
    }
    
    var objectid: ObjectId? // 객체아이디 받아와
    

    
    override func viewWillDisappear(_ animated: Bool) {
       
    }
    
    
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailView.collectionview.dataSource = self
        detailView.collectionview.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(image:UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(showAlertDeleteMessage))

        detailView.content.isEditable = false
        
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil) // title 부분 수정
        self.navigationItem.backBarButtonItem = backBarButtonItem
        let attributes = [
            NSAttributedString.Key.foregroundColor: AllColor.textColor.color,
            NSAttributedString.Key.font: AllFont.font.name

        ]
        //2
        navigationController?.navigationBar.titleTextAttributes = attributes
    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        tasks = repository.fetch()
//    }
    
    

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
    
    @objc func deleteButtonClicked() {

        let item2 = repository.localRealm.objects(EggTime.self).where {
            $0.objectId == objectid!
        }
        
        repository.deleteItem(item: item2)
        ListView().collectionview.reloadData()
        
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
}
