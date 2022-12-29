# EggTime (개인 출시프로젝트)

### 2022.09.11 ~ 2022.10.07 (26일 약 4주)

|                           앱아이콘                           | 스크린샷                                                     |
| :----------------------------------------------------------: | :----------------------------------------------------------- |
| ![Frame4icon3](https://user-images.githubusercontent.com/55547933/208235626-283a4597-8285-4583-a6ba-629bd12cb36a.png) | <img src="https://user-images.githubusercontent.com/55547933/208235602-7fc6c07e-1a0b-44e4-b2b7-75fa27dce441.jpg" alt="merge_from_ofoct" style="zoom:80%;" /> |
|                             개요                             | 내용과 이미지를 담아 타임 캡슐을 묻으면 지도위에 마커가 찍히는데 <br />일정 기간이후에만  개봉 가능한 추억의 타임캡슐 앱 프로젝트 |
|                          디자인패턴                          | MVC                                                          |
|                             화면                             | UIKit, SnapKit, AutoLayout                                   |
|                        의존성관리도구                        | CocoaPod , Swift Package Manager                             |
|                             서버                             | Firebase Crashlytics, Firebase Analytics                     |
|                         데이터베이스                         | Realm                                                        |
|                          디버깅스킬                          | LLDB                                                         |
|                          라이브러리                          | kingfisher, Zip, NMapsMap                                    |
|                             협업                             | Github, Figma                                                |
|                             참고                             | [1.개발일정](https://www.notion.so/9277d510b520433ab7d323c1ca0323a6?v=da1589e735164c78ad94d3f324080090) <br />[2.회고](https://hotsanit.tistory.com/91) <br />[3.앱스토어](https://apps.apple.com/kr/app/eggtime-추억을-저장하는-타임캡슐/id1645004650) |



## 🟢  기술 명세

- **CocoaPods** 사용시 필요한 **Podfile 사용법, Vim명령어, CocoaPod 버전관리** 에 대한 대응
- **SnapKit** (CodeBase) 으로 **AutoLayout** 적용
- **Firebase Cloud Messaging** 을 활용하여 **Push notification** 을 보내 앱 관련 공지사항 알림
- **Firebase analytics**를 통해 유저가 오래 머무는 화면과 자주누르는 버튼의 이벤트 **통계 분석**
- **Repository 패턴**을 사용함으로써 **비지니스 로직**과 **데이터 로직 분리**
- **Realm**에서 Data를 **CRUD적용, PK로 Data중복방지 , 마이그레이션으로 Realm 버전관리**
- 이미지 자체 크기별 대응을 위한 **UIImage Resizing**  대응
- **Timer**를 활용하여 캡슐이 오픈까지 남은시간 **실시간 갱신**
- **LocalNotification**을 통해 알림 권한설정 분기처리
- **LLDB**의 p,po,watchpoint 를 활용한 **변수추적** 및 Expression을 활용하여 **변수들을 테스트**해봄으로서 **빌드시간 최소화**
- **NMapsMap**에서 **공식문서**를 통해 핸들러, 마커, 카메라이동, 오버레이 기능으로 **커스텀화**



## 🔴 고민한 내용 및 트러블 슈팅


<details> <summary>이슈 1. CLLocationManager 관련 오류</summary><br>
🔴 고민한 영역 <br><br>
<img width="957" alt="스크린샷 2022-12-19 오후 4 12 51" src="https://user-images.githubusercontent.com/55547933/208649676-f824ac7c-6883-496a-87dd-df9ee79a528f.png"><br><br>



🔵 해결<br><br>
[시도 1]<br>
시스템 설정 관련들을 main 에서 처리를하는것은 main 쓰레드에 부담을 줄수있으므로 global Queue로 처리하는게 적합하기떄문에 global().async로 처리를 하게되었다.<br>

```swift
// global().async 로 비동기처리
DispatchQueue.global().async {
      if CLLocationManager.locationServicesEnabled() {
           print("위치 서비스 on 상태")
            self.locationManager.startUpdatingLocation()
      } else {
            print("위치 서비스 Off 상태")
      }     
}
```

[시도 2]
<br>
global().async로 해결이가능하면 Async/Await으로 해결이 가능하다고 생각하였다 .<br>

```swift
func locationServicesEnabled() async throws -> Void {
    CLLocationManager.locationServicesEnabled()
}

Task { [weak self] in
    if ((try await self?.locationServicesEnabled()) != nil) {
        self?.locationManager.startUpdatingLocation()
        return
    }
}
```

</details>


<details> <summary>이슈 2. Repository 패턴으로 비지니스 로직과 데이터 로직 분리</summary><br>
🔴 고민한 영역 <br><br>
ViewController마다 Realm이 중복코드로 들어가기떄문에 비지니스 로직과 데이터 레이어를 분리할필요성을 느낌<br><br>



🔵 해결<br><br>
[시도 1]<br>
ViewController마다 Realm이 중복코드로 들어가기떄문에 비지니스 로직과 데이터 레이어를 분리할필요성을 느낌<br>

```swift
// repository.swift 
protocol RealmRepositoryType {
    func fetch() -> Results<EggTime>
}
class RealmRepository: RealmRepositoryType {
  let localRealm = try! Realm()
    
    func fetch() -> Results<EggTime> {
        return localRealm.objects(EggTime.self)
    }
    lazy var tasks: Results<EggTime>! = self.fetch()
}
```

<br>
다음은 repository.swift 파일의 일부분으로 여러 ViewController에서  호출하여 사용하였다.<br>
이를 썻을떄 장점이 <br>
1.ViewController는 이제 로컬이든 외부 DB에서 가져오는지 신경쓰지않고 비지니스 로직에 집중할수있다.<br>
2.일관된 인터페이스 를 통해 데이터를 요청할수있으므로 코드의 오류나 중복되는요소가 줄어들수있다. 
</details>




<details> <summary>이슈3. 카메라 및 앨범사진 의 이미지를 DB에 저장할때 이미지타입 저장할떄 파일크기가 커지는 문제 </summary><br>
🔴 이슈 <br><br>
이미지를 저장할떄 DB에 image타입으로 저장하면 DB에 이미지크기만큼 DB에 부하를 줄서있기떄문에 적합한 방법을 고민해보았다.<br><br>



🔵 해결<br><br>
[시도 1]<br>
DB에는 이미지파일명인 String타입만 저장하고 실제 이미지는 FileManager를 사용하여 DocumentDirectory에 이미지를 저장하는 방법으로 해결해보았다.<br>

```swift
func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! NSString
        if mediaType.isEqual(to: kUTTypeImage as NSString as String) {
            let selectImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
                let imgName = UUID().uuidString+".jpeg"
                let documentDirectory = NSTemporaryDirectory()
                let localPath = documentDirectory.appending(imgName)
                let photoURL = URL.init(fileURLWithPath: localPath)
                if imageArrayUIImage.count == tag! {
                    imageArrayString.append(imgName)
                    imageArrayUIImage.append(selectImage!)
                } else{
                    imageArrayString[tag!] = imgName
                    imageArrayUIImage[tag!] = selectImage!
                }
                writeView.collectionview.reloadData()
                picker.dismiss(animated: true, completion: nil)
            }
        else if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
            let imageUrl=info[UIImagePickerController.InfoKey.imageURL] as? NSURL
            let imageName=imageUrl?.lastPathComponent//파일이름
            if imageArrayUIImage.count == tag! {
                imageArrayString.append(imageName!)
                imageArrayUIImage.append(selectImage!)
            } else{
                imageArrayString[tag!] = imageName!
                imageArrayUIImage[tag!] = selectImage!
            }
            writeView.collectionview.reloadData()
            dismiss(animated: true)
        }
        
            //UIImagePickerController5: 취소버튼 클릭시
            func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
                dismiss(animated: true)
            }
        }
    }

```

</details>

<details> <summary>이슈4. Swift 에서 List타입이 없어서 Realm의 List타입 사용시 문제 상황 </summary><br>
🔴 고민한 부분 <br><br>
이미지를 저장할떄 DB에 image타입으로 저장하면 DB에 이미지크기만큼 DB에 부하를 줄서있기떄문에 적합한 방법을 고민해보았다.<br><br>



🔵 해결<br><br>
[시도 1]<br>
여러이미지를 업로드하려고 Realm에서 List<Type> 으로 만들어야하는데 <br>
저같은경우 이미지를 document에 저장한 이미지의 이름을 저장하기위해  List<String>으로 만들려고했다. <br>
하지만 List타입은 swift에서 지원해주지않으므로 Array타입으로 시도하다가 타입이 안맞아서 오류가 발생했다. <br>

```swift
class BlogPost: Object {
  @objc var title = ""
  let tags = List<String>()

  convenience init(title: String, tag: String) {
    self.init()
    self.title = title
    self.tags.append(tag)
  }
}

```

<br>
위의 참고링크 예시코드 에서 List<String> 타입을 만들어서 초기화하는 부분에서 append를 하는것을보고 아이디어를 찾았다.
</details>

<details> <summary>이슈5. 기존의 tableView ⇒ section snapshots, list configuration로 리팩토링 </summary><br>
🔴 고민한 부분 <br><br>
기존의 테이블뷰 말고 다른방법으로 시도!<br><br>
<br>
🔵 해결<br><br>
현재 애플에서 테이블뷰 를 대신해서 iOS 14.0이후 나온 section  snapshots, list configuration으로 으로 리팩토링 시도 <br>



```swift
// SettingView.swift
    let collectionview : UICollectionView = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(44))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        let spacing : CGFloat = 8
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
```

```swift
//SettingViewController.swift
class SettingViewController: BaseViewController {
    private var dataSource: UICollectionViewDiffableDataSource<Int,String>!
}

extension SettingViewController {
    private func createLayout() -> UICollectionViewLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        config.backgroundColor = .clear
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        return layout
    }
    
    private func configureDataSource() {
        var cellRegisteration = UICollectionView.CellRegistration<UICollectionViewCell,String> (handler: {cell, indexPath, itemIdentifier in
            var content = UIListContentConfiguration.valueCell()
            content.text = Setting.allCases[indexPath.section].list[indexPath.row]
            content.textProperties.color = .white
            content.textProperties.font = AppFont.font.name!
            
            cell.contentConfiguration = content
            
            var background = UIBackgroundConfiguration.listPlainCell()
            background.backgroundColor = .clear
            cell.backgroundConfiguration = background
            
        })
        
        // cv.
        dataSource = UICollectionViewDiffableDataSource(collectionView: settingview.collectionview, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegisteration, for: indexPath, item: itemIdentifier) // indexPath, itemIdentifier 둘다 이용해서 cell에 접근가능
            return cell
        })
        
        var snapShot = NSDiffableDataSourceSnapshot<Int,String>()
        snapShot.appendSections([0])
        snapShot.appendItems(Setting.content.list)
        dataSource.apply(snapShot)
        
        
    }
}


```

</details>

<details> <summary>이슈6. 앱심사 리젝 사유 ( 데이터 수집과정 문제)</summary><br>
🔴 고민한 부분 <br><br>
지도 위치기반앱이라서 처음에 데이터 수집에서 위치부분에 체크를 했다.<br><br>
<img width="614" alt="스크린샷 2022-12-20 오후 9 12 44" src="https://user-images.githubusercontent.com/55547933/208664530-dfd14350-ce19-4459-af6c-b2a3f49342de.png"><br>



🔵 해결<br><br>
아래 내용은 사용자 위치권한으로 광고나 데이터를 서버단에 저장하거나 한다는 내용으로 체크해서 발생 했다.
즉 언제 체크를 해야하는지 앱심사 과정에서 알수있는 단계였다.  <br>
<img width="881" alt="스크린샷 2022-12-20 오후 9 07 23" src="https://user-images.githubusercontent.com/55547933/208663549-79cdd328-efb4-4148-a536-ad25bd2259ed.png">
</details>
