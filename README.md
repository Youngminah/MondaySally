# 먼데이샐리 - 회사 커뮤니티, 네트워킹, 복지 시스템 iOS앱

![Generic badge](https://img.shields.io/badge/Xcode-12.5.1-blue.svg)  ![Generic badge](https://img.shields.io/badge/iOS-13.0-yellow.svg)  ![Generic badge](https://img.shields.io/badge/Swift-5-green.svg)  ![Generic badge](https://img.shields.io/badge/Alamofire-5.4-red.svg)  ![Generic badge](https://img.shields.io/badge/Kingfisher-6.0-orange.svg)

</br>

<img src="https://user-images.githubusercontent.com/42762236/128651303-67da6bdf-32e8-4f33-98a5-7bbb45e89052.png" />


</br>

**앱스토어 바로가기 현재 version 1.0.0**

<a href="https://apps.apple.com/kr/app/%EB%A8%BC%EB%8D%B0%EC%9D%B4%EC%83%90%EB%A6%AC/id1576353006" target="_blank"><img src="https://user-images.githubusercontent.com/42762236/127537585-a07753d1-d0af-4cdc-8f53-24fbfae72be8.png" width="200px" /></a>


구성 서버1명, 클라이언트1명, PM1명, 디자이너1 
</br>

</br>
</br>

------------------------------------------------------------
</br>
</br>
</br>

# 개발 기간 미리보기 

| 주제                               | 진행기간                    | 담당                               | 세부사항                       |
| ---------------------------------- | --------------------------- | ---------------------------------- | ------------------------------ |
| **1차 아이디어 기획**              | **2021.05.10 ~ 2021.05.17** | **PM, 디자이너**                   | 기획세미나                     |
| **2차 아이디어 기획**              | **2021.05.17 ~ 2021.05.24** | **PM, 디자이너**                   | 디자인 세션                    |
| **와이어 프레임 완성**             | **2021.05.24 ~ 2021.06.07** | **PM, 디자이너**                   | 아이디어 소개                  |
| **디자인 완성, 개발 설계 완성**    | **2021.06.07 ~ 2021.06.28** | **PM, 디자이너**                   | 개발자 매칭, 디자이너 네트워킹 |
| **개발 시작 & 완성 , 디자인 보완** | **2021.06.28 ~ 2021.08.07** | **PM, 디자이너, 클라이언트, 서버** | 출시점검, 데모데이             |

</br>

</br>

</br>

------------------------------------------------------------
</br>
</br>
</br>

# 커뮤니케이션

- **Jeplin**
  - 디자이너와의 협업은 제플린에 코멘트를 달아 세세한 부분확인
  - 슬랙에 연동하여 알람 설정. 예전에 피그마도 디자이너와의 협업 툴로 사용해보았지만, 피그마는 iOS 이미지 에셋부분 형식이 맞지 않는다. 
  - 제플린은 iOS에 이미지 추출에 있어 최적화되어있어 훨씬 편했고, UI도 훨씬 편했다.

- **Slack**
  -  모든 팀원들과의 일반적 소통은 슬랙으로 이루어짐.

- **Zoom**
  - 초반에는 오프라인으로 미팅이 일주일에 한번씩 이루어지다 코로나 이유로 후반에는 zoom으로 개발 미팅 진행.

- **Postman**

- **Notion**
  - 기본적인 API Sheet나 WBS , 진행사항 체크등등 모든 정리사항 Notion페이지에 정리하여 이용.

  

</br>

</br>
</br>

----------------
</br>
</br>

</br>


# 프레임워크 & 디자인패턴 & 기술 스택

- **UIKit**

- **Storyboard**

  - View구성 Storyboard방식으로 구성.

- **MVVM Model**
  - 디자인 패턴 MVVM 모델을 이용하여 설계. 
  - **View&Controller - ViewModel - Model**로 나누어, View에서 Model을 접근할 때에는 ViewModel로 접근하도록 하였다.
  - 접근 이외에도 Model과 관련된일들은 ViewModel에서 처리해주며,기존 ViewController가 하는일을 ViewModel에게 배분하여 코드의 가독성을 높히고 역할을 분담함.

- **Alamofire**
  - 네트워크 통신에서는 Alamofire 라이브러리를 이용.

- **Kingfisher**
  - 이미지 처리는 Kingfisher를 이용하여 이미지 캐시처리하였고, error 핸들링.

- **Firebase**
  - 이미지 저장을 위해 Firebase Storage를 이용. APNs 기능을 위해 Firebase Cloud Messaging 이용.

</br>

</br>
</br>

------------------------------------------------------------
</br>
</br>

</br>

# 기획 및 개발 설계

<details><summary>기획 펼쳐보기</summary>
<img src="https://user-images.githubusercontent.com/42762236/127539006-14d12f7b-268b-410a-8d1c-5e873e350eec.png" />
<img src="https://user-images.githubusercontent.com/42762236/127539195-afabcc1b-9c04-4389-b698-1872e9ccb076.png" />
</details>

<details><summary>플로우 차트 펼쳐보기</summary>
<img src="https://user-images.githubusercontent.com/42762236/127539567-faec669e-9a8f-4dcc-8308-bfab8e507cd0.png" />
</details>

<details><summary>와이어프레임 펼쳐보기</summary>
<img src="https://user-images.githubusercontent.com/42762236/127539340-818250f9-67b6-4505-b57d-fe86ea3592a8.png" />
</details>
</br>

</br>

</br>
</br>

------------------------------------------------------------
</br>
</br>

</br>



# 아키텍처 MVVM

### 📎 폴더

<img src="https://user-images.githubusercontent.com/42762236/127616653-99f4d65e-04db-4eff-b9ab-0605d2d89aed.png">

- 이전 개발에서 폴더구성은 Controller폴더 안에서 ViewModel , 
- Model 폴더를 알맞는 ViewController마다 넣어 구성해보았는데, 폴더가 너무 많아지는것 같아,
- 이번 개발 폴더는 아예 가장 상위 폴더들을 ViewModel, Model, View, Controller로 나누었다. 

- 참고로 Storyboard 방식 개발이라서 View폴더에는 Stroyboard가 들어간다. 

- Network 폴더에는 Network통신에 필요한 DataService 가 싱글톤 패턴으로 들어가 있다. 

- Configuration폴더는 개발을 하다보면 필요한 extension 이나 커스텀 Alert, 폰트, 등등이 들어가있다.

</br>

</br>

### 📎 ViewModel

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

- 먼데이샐리에서 구성한 가장 기본적인 ViewModel의 틀. 

</br>

- **Property Observer**   
  - ViewModel에서 언제 어디서 요청이 오는지 알기 위해 프로퍼티 DidSet을 두어 감지하였다. 
  - 변화 이벤트가 일어날 시 적절한 처리를 할 객체가 필요한데 이것에는 다양한 방법을 사용할 수 있지만, 클로저로 처리 하였다. 
  - 
</br>

- 위의 코드에 덧붙여, 필요시 데이터를 가공할 작업이 있다면, 
- ViewModel에서 Computed Property를 이용하거나 함수를 이용하여 데이터를 가공 처리하였다.

</br>

- ViewModel의 구성은 맨처음 MVVM을 접할 때에는 어렵게만 느껴졌는데, 
- MVVM을 써보면 써볼수록 이해도가 높아져서 코드가 발전하는 것 같다.

</br>

</br>

### 📎 View & Controller

~~업뎃 예정

</br>

</br>

### 📎 Model

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

- Json타입의 변환을 위해 코더블을 사용하였다. 
- CodingKey를 활용하여 상황에 맞는 이름으로 Rename해주었다.



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

- 마찬가지로 코더블을 이용하였고, 
- Computed property로 딕셔너리 형태로 바꾸어 주어 JsonInput으로 첨가하였다.

</br>

</br>


</br>

------------------------------------------------------------
</br>
</br>
</br>

# 개발 이슈


#### 📎  Pagination 방식

<details>
<summary>펼쳐보기</summary>
<div markdown="1">
</br>

#### **▶︎  문제점**
  
서버가 Pagination을 주는 방법에서 next, prev url 정보를 서버로부터 받지 못하는 상황.  
  
Query에 page숫자를 클라이언트에서 넣어 처리를 해야하는 상황였다. URL은 https://~~~~/?page=1 이런 구조로 받았다.
</br>
PM이 next, prev는 처음 본다고 하여 나도 이부분에 대해서는 서버부분이라 항상 API를 받기만해서 잘 모르다보니 조사를 해보았다.
</br>
</br>
우선 API 방식에는 크게 2~3가지 방식으로 나눌 수 있다. 
</br>

- **PageNumberPagination 방식**
  - query에 page 값을 주는 방식 (먼데이 샐리 pagenation 방식과 비슷) 
  - 요청 시, 원하는 페이지(page) 번호를 정해서 가져오는 방법
  - 예) https://api.example.org/accounts/?page=4
  
- **LimitOffsetPagination 방식**

  - limit과 offset을 받아 page를 처리하는 방식
  - 요청시, 원하는 지점(offset)과 그 지점으로 부터 데이터 갯수(limit)를 정해서 가져오는 방법
  - 예) https://api.example.org/accounts/?limit=100&offset=400
  
- **CursorBased Pagination 방식**
 
  - 요청 했던 데이터 기준으로 앞, 뒤로만 이동할 때 사용
  - 예) https://api.example.org/accounts/?cursor=bz0xJnI9MQ

</br>
</br>
위의 Pagination 3가지 방식 모두 next, prev URL을 안주는 예시는 찾을 수 없었다. 
</br>
</br>

#### **▶︎  결론**


모바일에서 Pagination이 필요한 경우는 많은 경우가 무한 스크롤때 필요하고, 먼데이샐리도 그런 경우이다.

Pagination방식에 대해선 PM과 의논을 해보았다. PM이 페이징 처리를 많이(?) 경험해보신 부분이기도 하였고, 클라이언트에서 Page쿼리만을 가지고 pagination을 하는것이 불가능한 상황은 아니였기 때문에
next, prev url 없이 구현을 하였다. (아직까지 큰 문제점은 없음)

</br> 

구현을 하면서 기존 next, prev URL을 주는 경우와 비교하였을 때, (클라이언트 입장에서만) 느낀 비효율적인 상황을 적어본다. 
</br> 
</br> 
</br> 

- **이번 페이지가 마지막 페이지인지 아닌지를 API 결과로 바로 알 수 없음**
  - 그렇게 때문에 한 페이지당 최대 갯수를 현재 받아온 갯수와 나누어 나머지 값이 0인지 아닌지 계산을 해주어야 하는 결과가 필요하다.

- **그 외에도 혹시 마지막 페이지라도 0으로 나누어 떨어지는 경우**
  - 이 경우에는 무조건 다음 API를 요청을 해보아야한다.
  - 요청 결과로 다음 페이지가 없다는 메세지를 받으면 마지막 페이지라고 클라이언트에서 인식해야 했다.
  
</br> 
</br> 

nextURL을 서버로부터 응답결과로 받는다면 두가지 경우가 해소될 수 있는데, 
</br> 
모바일에서는 next, prev URL을 안주는 경우를 왜 사용하는지 궁금하여, 
</br> 
이 부분은 잘하는 네이버 iOS 개발자 분에게 물어보았고 답변을 기다리는 중이다 (호기심 생기면 자주 물어보는편 ㅎ..)

</div>
</details>


</br>

</br>
</br>
</br>

#### 📎  Firebase Image 업로드시 이름 설정

<details>
<summary>펼쳐보기</summary>
<div markdown="1">
</br>

#### **▶︎  문제점**
  
우선,  파이어베이스 저장소에는 이미지가 같은이름이라면 덮어쓰기 방식으로 기존 이미지가 사라지고 최근 이미지가 올라온다. 
</br>
여기서 파이어베이스에 이미지를 올릴 때, 어떤 이름으로 올려야하는지 난해하였다.
</br>
파이어베이스는 덮어쓰기 특징을 가지기 때문에, 그 특징을 잘 활용하는 방법이 있지 않을까 라는 생각에서 고민하게 된 것. 
</br>
특히 유저 프로필 이미지 경우에는 먼데이샐리 앱에선 하나만 존재하고, 이전 프로필 사진을 조회할 수 없기 때문에, 
</br>
유저와 프로필 사진은 1:1 매칭이 되는 상황이였다. 
</br>
이런 경우, 랜덤UUID를 사용하면 파이어베이스 공간 낭비가 심하지 않을까 라는 생각을 하게 되었다. 
</br>
 </br>
- **첫번째로 생각한 방법** 

  - 유저 프로필사진이 1:1 매칭이기 때문에 유저ID 값으로 올리는 방법. 
  - 예를들어 /users/:contentIdx/profile.png  이런식.
  
- **두번째로 생각한 방법** 
  - 그냥 도메인 별로만 묶어서 랜덤UUID 값으로 올리기. 
  - 예를들어 /users/{랜덤UUID}.png 

</br>
</br> 
 첫번째 방식의 장점은 유저ID로 구분하기 때문에 덮어쓰기 처리가 가능하다. 
</br>
 하지만 단점은 이전 사진을 되돌릴 수 없다(먼데이샐리의 경우 상관 없음). 
</br>
 또, 이미지 캐싱처리시 문제점이 생긴다. 프로필 사진이 변경되더라도 같은 URL로 생각하고, 
 </br>
 ` 캐시처리된 이미지데이터가 사라지기 전까지 바뀐이미지로 인식을 못하게 될 것 ` 이라는 점이다. 
 </br>
 </br>
 
  #### **▶︎  결론**
  
  - 고민한 결과 우선 나는 두번째 방식을 선택하였다.
   
    - 이유는 우선 , 이미지 캐시처리는 앱 개발시 필수이고, 
    - 프로필 사진을 보여주어야하는 화면들이 많기 때문에 캐시처리를 하지않거나 제대로 되지 않는다면 문제가 된다.
    - 또 다른 이유는, 프로필 사진만 덮어쓴다고 해서 사진 삭제 문제점이 해결되지 않는다. 
    - (다른 게시물 사진은 어차피 랜덤UUID로 올려야 하기 때문). 
    - 사진 삭제에 관해서는, 스토리지에 불필요한 파일이 쌓이는것을 방지하려면, 
    - 필요한 경우 파일을 삭제할 수 있도록 서버와의 역할 분담이 필요할 것으로 보인다.
  </br>
  </br>
  </br>
  조사를 해보다 더 알게된 사실이있다.  
  </br>
  먼데이샐리는 이미지처리를 파이어베이스 스토리지에 저장을 하여 해결을 한다. 
  </br>
  이러한 경우는 파이어베이스 사진저장 -> 서버에 URL보내는 API호출 순으로 이루어진다. 
  </br>
  하지만, S3를 사용하는 방법도 있다. 
  </br>
  S3는 내가 저장한 이름 값대로 url를 구성 할 수 있기 때문에, 
  </br>
  아직 S3에 파일을 업로드하지 않았더라도 어떤 값으로 저장할지 미리 계산할수 있다.
  </br>
  그렇게 된다면 서버 값 저장 -> 해당 식별자로 S3에 저장 순으로 이루어 질 수 있다.
  </br>
  S3를 이용한다면 파이어베이스보다 사진삭제면에서는 훨씬 간편하다고 한다.
  
</div>
</details>







</br>

</br>
</br>
</br>

#### 📎  APNs, FCM에서 디바이스의 Token 받아 배포 서버에 API 호출로 넘겨주는 위치

<details>
<summary>펼쳐보기</summary>
<div markdown="1">
</br>

#### **▶︎  문제점**

먼데이샐리는 APNs기능을 필요로 한다. FCM에서 디바이스의 Token을 받아 푸시 테스트까지 성공한 상태에서, 
</br>
받은 토큰을 배포서버에 API 호출로 넘겨주어야 하는 상황인데 API 호출 위치를 iOS 화면 구성중 어디로 하는지가 이슈 상황이였다.
</br>

APNs 기능을 처음 구현해보았기 때문에, 우선 FCM에서 발급 받은 디바이스 Token이 '얼마나 자주, 언제' 바뀌는지를 알아야했다.  

<img src="https://user-images.githubusercontent.com/42762236/127626972-cc459e5f-c432-4242-bf30-db415f4482c4.png">

위의 첨부된 내용은, 파이어베이스의 iOS FCM 관련 문서에 있는, 디바이스 토큰 변경에 관한 내용이다.
</br>
</br>
</br>
위의 3가지 내용이 아니고선 토큰이 변경 되지 않는다면, 

```swift
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    }
}
```

에서만 로컬에 저장한 토큰과 FCM에서 받은 토큰이 다르다면 서버에 API를 호출하면 될 것 같았다. 
</br>
</br>
</br>
하지만 로그인기능이 있다면 조금더 생각을 해보아야 했다. 
</br>
</br>
FCM 토큰을 기기별로 관리할건지 유저별로 관리할건지에 따라 달라진다. 
</br>
APNs의 목적이 모든 사용자에게 같은 공지를 띄우는 것이라면, 
</br>
유저를 고려할 필요 없이 위에 처럼 맨처음에 비교하고 AppDelegate에서 API를 보내면 된다. 
</br>
</br>
하지만 사용자별로 다른 푸시 알람을 보내야한다면, 유저 ID와 같이 보내주어야 하기 때문에, 맨처음 회원가입시 보내주어야 된다. 
</br>
또, 만약 다른기기에서 로그인을 해도 된다고 가정한다면, 
</br>
같은 유저ID라도 FCM값이 달라지기 때문에, 로그인/ 자동로그인/ 회원가입API 에서 보내주어야 한다.

</br>

#### **▶︎  결론**

- 결론적으로 먼데이샐리 앱은 사용자 별로 푸시 알람을 목적으로 하고,
- 로그인과 로그아웃 기능이 있기 때문에 PM과 의논 결과 모든 로그인과 관련된 곳에서 API를 보내주는 것으로 하였다.

</div>
</details>

</br>

</br>
</br>
</br>

#### 📎  여러가지 특성에 따른 API 호출 위치
<details>
<summary>펼쳐보기</summary>
<div markdown="1">
</br>

#### **▶︎  문제점**

  - 먼데이샐리는 테이블 뷰 헤더에 컬렉션 뷰가 있다던가 Nested된 구조가 많이 있다.
  - 처음에는 안일하게 viewWillAppear에 API호출을 놓는다면, 최신 상태의 데이터가 보여질것이라고 생각했다.
  - 구성을 하다보니 viewWillAppear에서 네트워크 통신을 놓는다면 최신 상태의 데이터는 보여지지만 쓸 데 없는 호출이 너무 많이 일어난다.


#### **▶︎  결론**

- 기본적인 호출은 viewDidLoad에서 해주되, 데이터 갱신이 있는 경우를 위해 refresh에관한 프로토콜을 만들어놓았다.
- 그리고 테이블 뷰나 컬렉션뷰일 경우 refreshControl을 두어서 사용자가 리프레쉬 할 수 있도록 구성하였다.
- 특수한 상황 (먼데이샐리에서 좋아요 API) 같은 부분은 사용자 인터렉션이 일어나자마자가 아닌 뷰가 사라질때의 구성 데이터를 API로 보냇다.

</div>
</details>


</br>

</br>
</br>
</br>

#### 📎  여러가지 특성에 따른 API 인디케이터 표시
<details>
<summary>펼쳐보기</summary>
<div markdown="1">
</br>

#### **▶︎  문제점**

  - 간단한 API의 경우 (예: 좋아요 API)를 요청했을때, alpha가 1인 화면을 씌울경우 깜빡거리는 현상 발생
  - 프로필 수정이나 게시물 수정같은경우는 alpha가 1인 배경에 인디케이터를 띄우는 것보다 반투명한 화면을 띄우는 것이 자연스럽다.
  - 테이블뷰 같은경우 인디케이터를 중앙에 띄우기보다 headerview에 추가해서 띄우는것이 자연스럽
  - 등등등 API 특성에 따라 알맞는 인디케이터가 요구된다.


#### **▶︎  결론**

- 상황에 따라 대비할 수 있게 테이블뷰, 컬렉션뷰 인디케이터, 반투명 인디케이터, 투명하지 않은 인디케이터를 만들어 알맞게 적용
  

</div>
</details>

</br>

</br>

</br>

----------------
</br>

</br>
</br>

# 배운점 & 느낀점

- ### 처음 해보는 앱 배포.  

  - 우선 이 부분에 있어선 느낀점이 많다.
  - WebAdmin + Firebase + nodejs서버 + 소셜 네트워킹식 구성앱이라, 
  - 처음으로 배포하는 앱 치곤 한달만에 배포하기에는 체감상 스케일이 큰 앱이였다.
  - 협업을 하면서 Notion으로 PM의 체계적인 WBS 라든가, 이슈사항 체크등 중간 역할이 도움이 많이 되었다. 
  - 이전에는 모의외주, iOS 클린코드 클론코딩, 패스트캠퍼스 강의, 핵심내용 자잘한 프로젝트만 해보았는데,
  - 실제 앱을 배포하면서 사용자 입장에서 생각을 하며 앱에 신경쓰게 되었고, 
  - 배포를 하지 않았다면 경험할 수 없는 여러가지 이슈사항을 부딪혀보며 경험해 볼 수 있었다.
  - 여러가지 해결 선택지중 각각의 선택지의 문제점은 무엇인지 스스로 결론 내릴 수 있었다. 
  - 이전에는 나무만 보며 코딩한 느낌에서 한번 숲을 볼 수 잇는 경험이였다!

- ### MVVM모델에 대한 이해도와 코드 구성.

  - MVVM모델은 직접 구현해보지 않고, 글로만 개념을 이해하기에는 직관적인 이해가 어렵다고 생각이 든다.
  - 아직도 폴더 구성이나 전체적 구성에서는 어려움이 있지만,
  - 이전 프로젝트에서 MVVM을 구현했을 때보다 이해도나 코드 구성이 훨씬 늘었다.

- ### 이미지 캐시처리

  - 대표적 이미지처리 KingFisher 라이브러리를 이용해서 쉽게 이미지 캐시처리를 하였는데,
  - 워낙 중요한 내용이다보니 이후에는 외부 라이브러리를 이용하지 않고 구현해보면서 이해해보는 것도 좋을 것 같다.
  
- ### 파이어베이스 스토리지로 이미지 저장

  - 먼데이샐리는 게시물에서 최대 첨가 할 수 있는 이미지가 4개까지다. 
  - 파이어베이스에 저장뒤 서버에 API 호출까지는 다른 API호출에 비해 비교적 시간이 걸린다.
  - 그렇기 때문에 게시물 수정을 할 경우, 손대지 않은 이미지를 다시 파이어베이스에 저장하고 API호출을 하는것은 비효율적이란 생각을 하였다.
  - 최대 4개의 이미지중 수정,삭제,추가가 이루어진 이미지를 구분하고, 그 이미지들만 골라 처리하는 부분이 가장 난이도가 있었다.
  - 이미지마다 Flag를 두어 처리하였는데, 이 부분은 코드리뷰를 받아보고 싶다.
  - 번개장터처럼 이미지를 더 많이 첨부할 수 있는 앱들 같은 경우 어떤식으로 이미지 수정을 구분하는지 알아보아야겠다.

- ### TestFlight 베타테스트
  
  - 앱을 배포전에 베타테스트를 이용해서 여러명에게 사용하게 하고 자잘한 이슈사항을 미리 업그레이드 하였다.
  - 그 덕에 까다로운 애플 심사 과정에서 인생 첫 앱심사였지만, 바이너리적인 부분에서 리젝없이 한번에 통과할 수 있었다.
  - 암튼 TestFlight가 이용하기도 편하고 피드백 구성도 잘되어있단 느낌을 받았다.

- ### API 호출 위치와 Indicator표시 방법

  - API 호출 위치는 항상 세심하게 고심해야 할 거 같다. 
  - 그리고 API 내용이 무엇이냐에 따라 보여줄 Indicator도 알맞게 설정해야한다는 것을 알았다. 
  - 이러한 부분들은 배달의 민족이나 개인적으로 앱구성이 뛰어나다고 생각하는 앱들을 참고하였다.



</br>

</br>

</br>

----------------

</br>

</br>
</br>




# :memo: Commit Convention

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
