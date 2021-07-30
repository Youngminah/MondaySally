## 먼데이샐리 - 회사 커뮤니티, 네트워킹, 복지 시스템 iOS앱

![Generic badge](https://img.shields.io/badge/Xcode-12.5.1-blue.svg)  ![Generic badge](https://img.shields.io/badge/iOS-13.0-yellow.svg)  ![Generic badge](https://img.shields.io/badge/Swift-5-green.svg)  ![Generic badge](https://img.shields.io/badge/Alamofire-5.4-red.svg)  ![Generic badge](https://img.shields.io/badge/Kingfisher-6.0-orange.svg)

</br>

<img src="https://user-images.githubusercontent.com/42762236/127543561-b5dfe739-a771-4b20-90e8-cf8f594d29fc.png" />



</br>

**앱스토어 바로가기 현재 version 1.0.0**

<a href="https://apps.apple.com/kr/app/%EB%A8%BC%EB%8D%B0%EC%9D%B4%EC%83%90%EB%A6%AC/id1576353006" target="_blank"><img src="https://user-images.githubusercontent.com/42762236/127537585-a07753d1-d0af-4cdc-8f53-24fbfae72be8.png" width="200px" /></a>



</br>

</br>

## 개발 기간 미리보기 

| 주제                               | 진행기간                    | 담당                               | 세부사항                       |
| ---------------------------------- | --------------------------- | ---------------------------------- | ------------------------------ |
| **1차 아이디어 기획**              | **2021.05.10 ~ 2021.05.17** | **PM, 디자이너**                   | 기획세미나                     |
| **2차 아이디어 기획**              | **2021.05.17 ~ 2021.05.24** | **PM, 디자이너**                   | 디자인 세션                    |
| **와이어 프레임 완성**             | **2021.05.24 ~ 2021.06.07** | **PM, 디자이너**                   | 아이디어 소개                  |
| **디자인 완성, 개발 설계 완성**    | **2021.06.07 ~ 2021.06.28** | **PM, 디자이너**                   | 개발자 매칭, 디자이너 네트워킹 |
| **개발 시작 & 완성 , 디자인 보완** | **2021.06.28 ~ 2021.08.07** | **PM, 디자이너, 클라이언트, 서버** | 출시점검, 데모데이             |

</br>

</br>



------



### 🏷 프레임워크 & 디자인패턴 & 기술 스택

- **UIKit**

- **Storyboard**

  View구성 Storyboard방식으로 구성.

- **MVVM Model**
  디자인 패턴 MVVM 모델을 이용하여 설계. **View&Controller - ViewModel - Model**로 나누어, View에서 Model을 접근할 때에는 ViewModel로 접근하도록 하였으며, 접근 이외에도 Model과 관련된일들은 ViewModel에서 처리해주며 , 기존에 ViewController가 하는일을 ViewModel에게 배분하여 코드의 가독성을 높히고 역할을 분담함.

- **Alamofire**
  네트워크 통신에서는 Alamofire 라이브러리를 이용.

- **Kingfisher**
  이미지 처리는 Kingfisher를 이용하여 이미지 캐시처리하였고, error 핸들링.

- **Firebase**
  이미지 저장을 위해 Firebase Storage를 이용. APNs 기능을 위해 Firebase Cloud Messaging 이용.

</br>

</br>

------



### 🏷 기획 및 개발 설계

<details><summary>기획</summary>
<img src="https://user-images.githubusercontent.com/42762236/127539006-14d12f7b-268b-410a-8d1c-5e873e350eec.png" />
<img src="https://user-images.githubusercontent.com/42762236/127539195-afabcc1b-9c04-4389-b698-1872e9ccb076.png" />
</details>

<details><summary>플로우 차트</summary>
<img src="https://user-images.githubusercontent.com/42762236/127539567-faec669e-9a8f-4dcc-8308-bfab8e507cd0.png" />
</details>

<details><summary>와이어프레임</summary>
<img src="https://user-images.githubusercontent.com/42762236/127539340-818250f9-67b6-4505-b57d-fe86ea3592a8.png" />
</details>
</br>

</br>

------



### 🏷 MVVM 구조

#### 폴더

<img src="https://user-images.githubusercontent.com/42762236/127616653-99f4d65e-04db-4eff-b9ab-0605d2d89aed.png">

이전 개발에서 폴더구성은 Controller폴더 안에서 ViewModel , Model 폴더를 알맞는 ViewController마다 넣어 구성해보았는데, 폴더가 너무 많아지는것 같아,
이번 개발 폴더는 아예 가장 상위 폴더들을 ViewModel, Model, View, Controller로 나누었다. 

참고로 Storyboard 방식 개발이라서 View폴더에는 Stroyboard가 들어간다. 

Network 폴더에는 Network통신에 필요한 DataService 가 싱글톤 패턴으로 들어가 있다. 

Configuration폴더는 개발을 하다보면 필요한 extension 이나 커스텀 Alert, 폰트, 등등이 들어가있다.

</br>

</br>

#### ViewModel

```swift
class CommuteViewModel {
    //MARK: 기본 프로퍼티
    private var dataService: AuthDataService?
    private var noDataResponse: NoDataResponse? { didSet { self.didFinishFetch?() } }
    
    //MARK: 프로퍼티 DidSet
    var error: Error? { didSet { self.showAlertClosure?() } }
    var failMessage: String? { didSet { self.showAlertClosure?() } }
    var failCode: Int? { didSet { self.codeAlertClosure?() } }
    var isLoading: Bool = false { didSet { self.updateLoadingStatus?() } }
    
    //MARK: 클로져
    var showAlertClosure: (() -> ())?
    var codeAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var didFinishFetch: (() -> ())?
    
    // MARK: 생성자
    init(dataService: AuthDataService) {
        self.dataService = dataService
    }
    
    func fetchCommute(){
        self.isLoading = true
        self.dataService?.requestFetchCommute(completion: { [weak self] response, error in
            guard let strongself = self else { return }
            if let error = error {
                strongself.error = error
                strongself.isLoading = false
                return
            }
            if let isSuccess = response?.isSuccess {
                if !isSuccess {
                    strongself.failMessage = response?.message
                    strongself.failCode = response?.code
                    strongself.isLoading = false
                    return
                }
            }
            strongself.error = nil
            strongself.isLoading = false
            strongself.failMessage = nil
            strongself.noDataResponse = response
        })
    }
}
```

먼데이샐리에서 구성한 가장 기본적인 ViewModel의 틀. 

</br>

**Property Observer** : MVVM 패턴에서 ViewModel은 View를 전혀 모른다. View만 ViewModel을 인스턴스로 가지고 있기 때문에 둘의 일관성을 맞추어 주어야한다. ViewModel에서 언제 어디서 요청이 오는지 알기 위해 프로퍼티 DidSet을 두어 감지하였다. 변화 이벤트가 일어날 시 적절한 처리를 할 객체가 필요한데 이것에는 다양한 방법을 사용할 수 있지만, 클로저로 처리 하였다. 

위의 코드에 덧붙여, 필요시 데이터를 가공할 작업이 있다면, ViewModel에서 Computed Property를 이용하거나 함수를 이용하여 데이터를 가공 처리하였다.

</br>

ViewModel의 구성은 맨처음 MVVM을 접할 때에는 어렵게만 느껴졌는데, MVVM을 써보면 써볼수록 이해도가 높아져서 코드가 발전하는 것 같다.

</br>

</br>

#### View & Controller

~~업뎃 예정

</br>

</br>

#### Model

**▶︎ Response Data**

```swift
struct CloverCurrentResponse: Decodable{
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: CurrentCloverInfo?
}

struct CurrentCloverInfo: Decodable{
    var cloverTotal: Int
    var availableGiftList: [AvailableGiftInfo]?
    
    enum CodingKeys:  String, CodingKey {
        case cloverTotal = "currentClover"
        case availableGiftList = "gifts"
    }
}

struct AvailableGiftInfo: Decodable{
    var index: Int
    var imageUrl: String
    var giftName: String
    
    enum CodingKeys:  String, CodingKey {
        case index = "idx"
        case imageUrl = "imgUrl"
        case giftName = "name"
    }
}
```

Json타입의 변환을 위해 코더블을 사용하였다. CodingKey를 활용하여 상황에 맞는 이름으로 Rename해주었다.



**▶︎ Input Data**

```swift
struct TwinkleWriteInput: Encodable {
    var giftIndex: Int
    var content: String
    var receiptImageUrl: String
    var twinkleImaageList: [String]
    
    var toDictionary: [String: Any] {
        let dict: [String: Any]  = ["giftLogIdx": giftIndex, "content": content, "receiptImgUrl": receiptImageUrl, "twinkleImgList": twinkleImaageList]
        return dict
    }
}

```

마찬가지로 코더블을 이용하였고, Computed property로 딕셔너리 형태로 바꾸어 주어 JsonInput으로 첨가하였다.

</br>

</br>

------



### 🏷 개발 이슈

</br>

#### ● Pagination 방식

**문제점**

</br>

**해결**

</br>

</br>

#### ●  Firebase Image 업로드시 이름 설정

**문제점**

</br>

**해결**

</br>

</br>

#### ●  APNs 이용을 위해 FCM에서 디바이스의 Token 받아 배포 서버에 API 호출로 넘겨 줄 때의 호출 위치

**문제점**

먼데이샐리는 APNs기능을 필요로 한다. FCM에서 디바이스의 Token을 받아 푸시 테스트까지 성공한 상태에서, 받은 토큰을 배포서버에 API 호출로 넘겨주어야 하는 상황인데 API 호출 위치를 iOS 화면 구성중 어디로 하는지가 이슈 상황이였다.

</br>

**해결**

APNs 기능을 처음 구현해보았기 때문에, 우선 FCM에서 발급 받은 디바이스 Token이 '얼마나 자주, 언제' 바뀌는지를 알아야했다.  

<img src="https://user-images.githubusercontent.com/42762236/127626972-cc459e5f-c432-4242-bf30-db415f4482c4.png">

위의 첨부된 내용은, 파이어베이스의 iOS FCM 관련 문서에 있는, 디바이스 토큰 변경에 관한 내용이다. 위의 3가지 내용이 아니고선 토큰이 변경 되지 않는다면, 

```swift
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    }
}
```

에서만 로컬에 저장한 토큰과 FCM에서 받은 토큰이 다르다면 서버에 API를 호출하면 될 것 같았다. 

하지만 로그인기능이 있다면 조금더 생각을 해보아야 했다. FCM 토큰을 기기별로 관리할건지 유저별로 관리할건지에 따라 달라진다. APNs의 목적이 모든 사용자에게 같은 공지를 띄우는 것이라면, 유저를 고려할 필요 없이 위에 처럼 맨처음에 비교하고 AppDelegate에서 API를 보내면 된다. 하지만 사용자별로 다른 푸시 알람을 보내야한다면, 유저 ID와 같이 보내주어야 하기 때문에, 맨처음 회원가입시 보내주어야 된다. 또, 만약 다른기기에서 로그인을 해도 된다고 가정한다면, 같은 유저ID라도 FCM값이 달라지기 때문에, 로그인/ 자동로그인/ 회원가입API 에서 보내주어야 한다.

</br>

결론적으로 먼데이샐리 앱은 아이폰에서만 사용할 수 있고, 다른 핸드폰으로 로그인하는 것을 허용할 필요가 없기 때문에 (새 폰 구입시 예외처리), 첫 회원가입 때만 보내도 무방하였지만, PM과 의논 결과 모든 로그인과 관련된 곳에서 API를 보내주는 것으로 하였다.

</br>

</br>



------



### 🏷 느낀점

</br>

</br>



------



### 🏷 커뮤니케이션

- **Jeplin**
  디자이너와의 협업은 제플린에 코멘트를 달아 세세한 부분까지 확인. 슬랙에 연동하여 알람 설정. 예전에 피그마도 디자이너와의 협업 툴로 사용해보았지만, 피그마는 iOS 이미지 에셋부분 형식이 맞지 않는다. 제플린은 iOS에 이미지 추출에 있어 최적화되어있어 훨씬 편했고, UI도 훨씬 편했다.

- **Slack**
  모든 팀원들과의 일반적 소통은 슬랙으로 이루어짐.

- **Zoom**
  초반에는 오프라인으로 미팅이 일주일에 한번씩 이루어지다 코로나 이유로 후반에는 zoom으로 개발 미팅 진행.

- **Postman**

- **Notion**
  기본적인 API Sheet나 WBS , 진행사항 체크등등 모든 정리사항 Notion페이지에 정리하여 이용.

  

<br></br>

<br></br>

------



### 🏷 앞으로의 먼데이샐리



<br></br>

<br></br>

------



## :memo: Commit Convention

```
  - Init : 초기화
  - Add : 파일 추가
  - Remove : 기능, 파일 삭제
  - Update : 기능, 디자인, 파일 업데이트
  - Fix : 버그 수정
  - Refactor: 리팩토링
  - Docs : 문서 (문서 추가(Add), 수정, 삭제)
  - !BREAKING CHANGE : 커다란 API 변경의 경우 !
  - Comment : 필요한 주석 추가 및 변경   
  - Test : 테스트 추가, 테스트 리팩토링(프로덕션 코드 변경 X) 
```

<br></br>
