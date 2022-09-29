//
//  BackupStoredViewController.swift
//  EggTime
//
//  Created by useok on 2022/09/14.
//

import UIKit

import Zip
import RealmSwift

class BackupStoredViewController: BaseViewController {

    //MARK: 뷰 가져오기
    let backupStoredView = BackupStoredView()
    override func loadView() {
        super.view = backupStoredView
    }
    
    var tasks: Results<EggTime>!

    override func viewWillDisappear(_ animated: Bool) {
        print(#function)
        tasks = repository.fetch()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "백업/복구하기"
        let attributes = [
            NSAttributedString.Key.foregroundColor: AllColor.textColor.color,
            NSAttributedString.Key.font: AllFont.font.name
        ]
        //2
        navigationController?.navigationBar.titleTextAttributes = attributes

        backupStoredView.backupButton.addTarget(self, action: #selector(backupButtonClicked), for: .touchUpInside)
        backupStoredView.storedButton.addTarget(self, action: #selector(storedButtonClicked), for: .touchUpInside)
    }
    @objc func backupButtonClicked() {
        print(#function)
        backupButtonClickedStart()
    }
    
    @objc func storedButtonClicked() {
        print(#function)
        restoreButtonClicked()
    }

    //MARK: 백업

    func backupButtonClickedStart() {
        
        var urlPaths = [URL]() // 빈배열 타입이 URL
        
        
        //  도큐먼트 위치에 백업파일 확인
        guard let path = documentDirectoryPath() else { // path는 도큐먼트 경로
            showAlertMessage(title: "documnet 위치에 오류가있음", button: "확인")
            return
        }
        let realFile = path.appendingPathComponent("default.realm") // 도큐먼트경로/default.realm
        guard FileManager.default.fileExists(atPath: realFile.path) else { // 경로에 파일이 존재하는지 확인
            showAlertMessage(title: "백업할 파일이 없습니다.", button: "확인")
            
            return
        }
        let backUpFileURL = URL(string: realFile.path)! //realFile와 같은경로라서 backUpFileURL과 동일
        urlPaths.append(backUpFileURL) //
        // 백업파일압축: URL   (https://github.com/marmelroy/Zip.git)
        do {
            let zipFilePath = try Zip.quickZipFiles(urlPaths, fileName: "나의 캡슐 백업파일") // Zip
            print("Archive location: \(zipFilePath)")
            
            repository.localRealm.beginWrite()
                do {
                    try self.repository.localRealm.writeCopy(toFile: zipFilePath)
                } catch {
                    // Error backing up data
                }
            repository.localRealm.cancelWrite()
            
            
            
            // activityviewController
            showActivityViewController()
        } catch {
            showAlertMessage(title: "압축실패", button: "확인")
        }
        
    }
    // activityviewController 성공할떄
    func showActivityViewController() {
        guard let path = documentDirectoryPath() else {
            showAlertMessage(title: "도큐먼트 위치 ", button: "확인")
            return
        }
        let backupFileURL = path.appendingPathComponent("나의 캡슐 백업파일.zip")
        
        let vc = UIActivityViewController(activityItems: [backupFileURL], applicationActivities: [] ) //activityItems: 어떤거보낼래?
        self.present(vc,animated: true)
        }
    
    //MARK: 복구
    
    func restoreButtonClicked() {
        if #available(iOS 14.0, *) {
            let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.archive], asCopy: true)
            documentPicker.delegate = self
            documentPicker.allowsMultipleSelection = false
            self.present(documentPicker,animated: true)
        } else {
            // Fallback on earlier versions
        } // 반드시 파일앱에 저장해놔야함 ascopy:     UIDocumentPickerViewController는 문서선택시 어떻게해줄거냐?
 
    }
    
    
   
    

}


// 나중에수정
extension BackupStoredViewController: UIDocumentPickerDelegate{
    // 취소누른경우
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("도큐먼트피터 닫았습니다.")
    }
    // 경로 선택시
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        guard let selectedFieldURL = urls.first else { //압축파일(파일앱의 zip) 선택한파일이 있는지 확인   ~fileapp/foder
            showAlertMessage(title: "선택한 파일 찾을수없음", button: "확인")

            return
        }
        
        guard let path = documentDirectoryPath() else { // 보낼 위치(나의앱 도큐먼트)가 맞는지 // path는 파일에대한 경로      ~/document
            showAlertMessage(title: "도큐먼트 위치 오류있음", button: "확인")
            return
        }
        
        let sandboxFileURL = path.appendingPathComponent(selectedFieldURL.lastPathComponent) //selectedFieldURL.lastPathComponent 는 sesacDiary.zip      선택한 압축파일의 최종경로 ~fileapp/foder/sesacDiary.zip
        
        // sandboxFileURL 에 이미 파일이 있는경우
        if FileManager.default.fileExists(atPath: sandboxFileURL.path) {  // 파일앱에 복구파일있는경우
            let fileURL = path.appendingPathComponent("나의 캡슐 백업파일.zip")   // ~/document/sesacDiary.zip
            do {
                try Zip.unzipFile(fileURL, destination: path , overwrite: true, password: nil, progress: { progress in
                }, fileOutputHandler: { [self] unzippedFile in
                    print(unzippedFile)
                    self.showAlertMessage(title: "복구가완료되었습니다.", button: "확인")
                    
                    repository.localRealm.beginWrite()
                        do {
                            try self.repository.localRealm.writeCopy(toFile: unzippedFile)
                        } catch {
                            // Error backing up data
                        }
                    repository.localRealm.cancelWrite()
//
                }) //overwrite은 덮어씌우기
            } catch {
                showAlertMessage(title: "압축해제실패", button: "확인")
            }

            
        } else {
            do {
                //파일 앱 zip -> 도큐먼트 폴더에 복사
                try FileManager.default.copyItem(at: selectedFieldURL, to: sandboxFileURL)
                
                let fileURL = path.appendingPathComponent("나의 캡슐 백업파일.zip") //  ~fileapp/foder/sesacDiary.zip
                
                try Zip.unzipFile(fileURL, destination: path , overwrite: true, password: nil, progress: { progress in
                    print("progress: \(progress)")
                }, fileOutputHandler: { unzippedFile in
                    print("unzippedFile: \(unzippedFile)")
                    self.showAlertMessage(title: "복구가완료되얷습니다", button: "확인")
                }) //overwrite은 덮어씌우기
                
            } catch {
                showAlertMessage(title: "압축해제 실패", button: "확인")
            }
        }
    }
    
}
