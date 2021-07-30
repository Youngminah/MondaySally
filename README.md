## 먼데이샐리 - 회사 커뮤니티, 네트워킹, 복지 시스템 iOS앱

![Generic badge](https://img.shields.io/badge/Xcode-12.5.1-blue.svg)  ![Generic badge](https://img.shields.io/badge/iOS-13.0-yellow.svg)  ![Generic badge](https://img.shields.io/badge/Swift-5-green.svg)  ![Generic badge](https://img.shields.io/badge/Alamofire-5.4-red.svg)  ![Generic badge](https://img.shields.io/badge/Kingfisher-6.0-orange.svg)

<br></br>

<img src="https://user-images.githubusercontent.com/42762236/127543561-b5dfe739-a771-4b20-90e8-cf8f594d29fc.png" />



<br></br>

**앱스토어 바로가기 현재 version 1.0.0**

<a href="https://apps.apple.com/kr/app/%EB%A8%BC%EB%8D%B0%EC%9D%B4%EC%83%90%EB%A6%AC/id1576353006" target="_blank"><img src="https://user-images.githubusercontent.com/42762236/127537585-a07753d1-d0af-4cdc-8f53-24fbfae72be8.png" width="200px" /></a>



<br></br>

<br></br>

## 개발 기간 미리보기 

| 주제                               | 진행기간                    | 담당                           | 세부사항                       |
| ---------------------------------- | --------------------------- | ------------------------------ | ------------------------------ |
| **1차 아이디어 기획**              | **2021.05.10 ~ 2021.05.17** | PM, 디자이너                   | 기획세미나                     |
| **2차 아이디어 기획**              | **2021.05.17 ~ 2021.05.24** | PM, 디자이너                   | 디자인 세션                    |
| **와이어 프레임 완성**             | **2021.05.24 ~ 2021.06.07** | PM, 디자이너                   | 아이디어 소개                  |
| **디자인 완성, 개발 설계 완성**    | **2021.06.07 ~ 2021.06.28** | PM, 디자이너                   | 개발자 매칭, 디자이너 네트워킹 |
| **개발 시작 & 완성 , 디자인 보완** | **2021.06.28 ~ 2021.08.07** | PM, 디자이너, 클라이언트, 서버 | 출시점검, 데모데이             |

<br></br>

<br></br>



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

<br></br>

<br></br>

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

<br></br>

<br></br>

------



### 🏷 MVVM 구조

#### 폴더

<img src="https://user-images.githubusercontent.com/42762236/127616653-99f4d65e-04db-4eff-b9ab-0605d2d89aed.png" align="left">

<br></br>

이전 개발에서 폴더구성은 Controller폴더 안에서 ViewModel , Model 폴더를 알맞는 ViewController마다 넣어 구성해보았는데, 폴더가 너무 많아지는것 같아,
이번 개발 폴더는 아예 가장 상위 폴더들을 ViewModel, Model, View, Controller로 나누었다. 

참고로 Storyboard 방식 개발이라서 View폴더에는 Stroyboard가 들어간다. 

Network 폴더에는 Network통신에 필요한 DataService 가 싱글톤 패턴으로 들어가 있다. 

Configuration폴더는 개발을 하다보면 필요한 extension 이나 커스텀 Alert, 폰트, 등등이 들어가있다.

<br></br>

<br></br>

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

먼데이샐리에서 구성한 가장 기본적인 ViewModel의 틀이다. 

</br>

- **Property Observer** : MVVM 패턴에서 ViewModel은 View를 전혀 모른다. View만 ViewModel을 인스턴스로 가지고 있기 때문에 둘의 일관성을 맞추어 주어야한다. ViewModel에서 언제 어디서 요청이 오는지 알기 위해 프로퍼티 DidSet을 두어 감지하였다. 
  변화 이벤트가 일어날 시 적절한 처리를 할 객체가 필요한데 이것에는 다양한 방법을 사용할 수 있지만, 클로저로 처리 하였다. 

</br>

위의 코드에서 덧붙여 필요시 데이터를 가공할 작업이 있다면, ViewModel에서 Computed Property를 이용하거나 함수를 이용하여 데이터를 가공 처리하였다.

ViewModel의 구성은 맨처음 MVVM을 접할 때에는 어렵게만 느껴졌는데, MVVM을 써보면 써볼수록 이해도가 높아져서 코드가 발전하는 것 같다.

</br>

</br>

#### View & Controller



<br></br>

<br></br>

#### Model

<br></br>

<br></br>

------



### 🏷 개발 이슈

<br></br>

<br></br>

▶︎

------



### 🏷 느낀점

<br></br>

<br></br>



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
