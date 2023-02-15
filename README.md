
# Karrot-market-clone-coding 당근마켓 클론코딩
<img src="https://img.shields.io/badge/Swift-F05138?style=flat-square&logo=Swift&logoColor=white"/></a>
<img src="https://img.shields.io/badge/Xcode-147EFB?style=flat-square&logo=Xcode&logoColor=white"/></a>

<!-- <img src="https://img.shields.io/badge/기술명-색상코드?style=flat-square&logo=기술명&logoColor=색상"/></a> -->

## 프로젝트 멤버

EHD - iOS.
domb - iOS.
myeolinmalchi - 백엔드.

## 프로젝트 기간

22.07.10 ~

## 구현화면

## 진행방식

- 프로젝트를 Scene 별로 나누고 각자의 `develop` 에서 설계 후 `main`으로 merge

        - 🚀EHD: 당근마켓 로그인, 회원가입, 프로파일 수정, 게시글 등록, 알림

        - 🔥domb: 나의 당근, 검색, 게시글 상세정보, 관심*판매 목록

        - 공통: 메인화면

- 기능구현, 버그 수정 등의 처리후 커밋으로 기록 남기고 PR을 통한 코드리뷰 


## 사용기술
| 디자인 패턴 | 프레임워크 | 라이브러리|
|--|--|--|
| MVVM Pattern<br>Delegate Pattern | <b>UIKit</b><br>☑️ *UICollectionViewController*<br>☑️ *UITableViewController*<br>☑️ *UITableViewHeaderFooterView*<br>✅ *UITableViewDiffableDataSource*<br>☑️ *PHPickerView*<br>☑️ *Notification*<br><br><b>Security</b><br> ✅ *KeyChain* |Alamofire<br>JWTDecode
  

## 핵심 경험

#### *UITableViewDiffableDataSource*
> manage updates to your table view’s data and UI in a simple, efficient way.
    기존에는 동적인 ui을 보여주려면 batch update를 사용

#### *Closure를 활용한 데이터 전달*
    
#### *keychain*
> 사용자의 민감한 개인정보를 UserDefaults 보다 안전한 저장공간에 저장
    
#### *Json Web Token* 
> 사용자 유효성 검증 

#### *HTTP 통신*
> 로그인, 회원가입 등의 사용자정보와 상품정보 및 이미지 등에 대한 CRUD 구현
    
> Requestable 프로토콜을 채택한 Request를 목적 별로 enum 타입을 생성하여 Alamofire 라이브러리 사용을 극대화하고 직관적인 코드가독성 확보
```swift
protocol Requestable: URLRequestConvertible {
    var baseUrl: String { get }
    var header: RequestHeaders { get }
    var path: String { get }
    var parameters: RequestParameters { get }
}
enum Purpose: Requestable {
    case login(User)
    case fetchUser(ID)
    case registerUser
    case update(User)
    ...
}
typealias ID = String
```

## 트러블 슈팅
❗️ UITableViewDiffableDataSource  Issue

> 1. tableView(didSelectRowAt:) 에서 tableView.dequeReusable 사용하여 셀에 접근하면 생성한 셀을 선택하는 것이 아니라 또다시 셀의 인스턴스를 생성하는 것이므로 같은 셀에 접근할 수 없기에 런타임 에러가 남.<br>
> 2. 스크롤시 네트워크 통신이 제대로 이루어지지않음.


## 고민한 점(문제 또는 고민 → 해결)
-   델리게이트 패턴 / 노티피케이션 / 클로저
    
    → 노티피케이션패턴을 너무 많이쓰면 특정 씬에서 감시해야하는 노티피케이션이 너무 많아질 것 같고 역할 분배 및 메모리 차원에서 해당 패턴을 사용하는 것을 최대한 지양해왔음. 하지만 여러 씬에서 같은 액션을 취해야 하거나 델리게이트 패턴 혹은 클로저패턴으로 데이터 전달 시 씬을 여러번 건너 뛰어야 할 때에는 노티피케이션 패턴을 사용.
    
-   새 상품 등록 후 tableView의 동적 UI 변화를 단순 process로 적용 → UITableViewDiffableDataSource를 갱신
    
-   photosUI 권한 설정 못받았을 대 다시 물어보기
    
-   MVVM 아키텍쳐를 적용 + 델리게이트 패턴 사용 → MVVM + Delegate = MVP
    
-   네트워킹 라이브러리 → Alamofire URLRequestConvertible
    
-   앨범 권한 설정 → PhotosUI
    
-   regex
    
-   깃 플로우
    
-   객체의 변수에 직접접근 또는 private 설정후 함수로만 접근 → private(set)
    
-   코드컨벤션, 네이밍 가이드 → 협업을 위함. 줄바꿈, 뛰어쓰기, 가독성 향상
    
-   네임스페이스 → enum 타입의 Const
    
-   Result type을 통한 에러 핸들링 → @escaping Completion block과 do-catch, throw 에러핸들링사용보다 코드 간결성을 위해 사용.?

-   lazy var → 모든 사용자에게 보여지는 필수 ui가 아닐경우 lazy var를 사용하여 메모리 효율

-   디바이스 사이즈
