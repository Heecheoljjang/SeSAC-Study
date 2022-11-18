# SeSAC_Study

### 11/7

#### 내용

- 기본 세팅
    - 열거형으로 문자열 정리
    - UIColor 세팅
- 로그인 화면
    - 휴대폰 번호 입력 화면 UI
    - 인증번호 입력 화면 UI
    - 가상 전화번호로 verificationID 오는거까지 확인

### 11/8

#### 내용

- Label이 담긴 스택뷰, 버튼은 전부 같으므로 재사용뷰로 따로 만들어 사용
- 휴대폰 번호 입력 화면
    - 재사용 뷰 적용
    - 버튼 회색 상태일때도 눌리게
    - 번호를 입력하고 인증번호 받기 버튼을 눌렀을때, 성공적으로 verificationId가 오면 인증번호 입력화면으로 전환
    - 토스트 메세지 띄우기
    - 실제 번호 테스트 확인
- 인증 번호 입력 화면
    - 재사용 뷰 적용
    - 인증번호 확인 로직 구현
- 닉네임 입력 화면
    - UI
    - 닉네임 체크 로직 구현

    
#### 이슈

- 인증번호를 확인할 때 받았던 토큰도 같이 확인해야하는데, 기존에는 옵저버블타입으로 프로퍼티를 선언했었는데 인풋아웃풋을 적용할 때 알맞지 않을 것 같아서 유저디폴트를 사용해보기로함.
- 휴대폰 번호 입력하는 뷰와 닉네임 뷰의 UI가 완전히 일치해서 하나의 뷰를 이용해 사용할 수 있을 것 같았음.
    - 이니셜라이즈로 바뀌는 텍스트와 키보드 타입의 값을 받아서 해결할 수 있었음.
    - 아예 레이블 두 개를 스택뷰에 넣어서 버튼이랑 같이 재사용 뷰에 넣으면 모든 뷰에 사용할 수 있을 것 같음.
- 닉네임의 최대 글자수를 제한하기 위해서 count를 이용해 10자가 넘으면 텍스트필드의 마지막 글자를 지우고 resignFirstResponder()로 키보드를 자동으로 내려주게했는데 아래와 같은 오류 뜸.
    ~~~
    ⚠️ Reentrancy anomaly was detected.
  > Debugging: To debug this issue you can set a breakpoint in /Users/hee/Library/Developer/Xcode/DerivedData/SeSAC_Study-bjsyeunlbnglsfachdmmzpuqwndi/SourcePackages/checkouts/RxSwift/Sources/RxSwift/Rx.swift:96 and observe the call stack.
  > Problem: This behavior is breaking the observable sequence grammar. `next (error | completed)?`
    This behavior breaks the grammar because there is overlapping between sequence events.
    Observable sequence is trying to send an event before sending of previous event has finished.
  > Interpretation: This could mean that there is some kind of unexpected cyclic dependency in your code,
    or that the system is not behaving in the expected way.
  > Remedy: If this is the expected behavior this message can be suppressed by adding `.observe(on:MainScheduler.asyncInstance)`
    or by enqueuing sequence events in some other way.
    ~~~
    나와있는 코드를 추가하면 해결되지만 왜 떴는지 알아봐야함.
    
- 또 이런 오류가 떠서 왜 떴는지 알아봐야함. 구현 상으로는 문제 없었음. 처음으로 키보드가 내려올때 뜸.
~~~
[Touch] unexpected nil window in __sendSystemGestureLatentClientUpdate, _windowServerHitTestWindow: <UIRemoteKeyboardWindow: 0x102008200; frame = (0 0; 390 844); opaque = NO; autoresize = W+H; layer = <UIWindowLayer: 0x281d9bbd0>>, touch:<UITouch: 0x103408db0> phase: Stationary tap count: 1 force: 0.000 window: (null) view: (null) location in window: {0, 0} previous location in window: {0, 0} location in view: {0, 0} previous location in view: {0, 0}
~~~

#### 구현x

- 인풋 아웃풋
- 휴대폰 번호 입력 화면
    - 과도한 요청 로직 처리
    - 텍스트필드에 - 추가
- 인증 번호 입력 화면
    - 타이머
    - 재요청 버튼
    - 유효기간 만료 체크
    
### 11/9

#### 내용

- 생년월일 화면
    - 텍스트필드, 라인, 년월일 레이블이 담긴 재사용 뷰를 이용해 날짜 텍스트필드 구현
    - 스택뷰 위에 투명한 텍스트필드를 추가해서 inputView로 데이트피커 구현
    - dateComponent를 이용해 만나이 계산 로직 구현
- 이메일 입력 화면
    - UI
    - 정규식으로 이메일 확인 로직 구현
    - 인풋 아웃풋 적용
- 성별 선택 화면
    - UI
    - 성별 선택 로직만 구현(네트워킹 제외)
- 로그인 재사용뷰 수정
    - 스택뷰 constraints 수정
    
    
#### 이슈

- 재사용 뷰의 스택뷰
    - 디테일레이블과 메세지 레이블이 겹쳐서 보임
        - 메세지 레이블과 디테일 레이블의 horizontalEdges의 inset이 다름..
        - 일단 스택뷰 내부에서는 제약조건을 주지 않게하고, inset이 다른 뷰에서는 removeConstraints를 이용해 기존의 제약조건을 지워주고 다시 잡아줘서 해결.
- 투명한 텍스트필드를 위에 올려서 데이트피커를 사용했는데, 이때 addSubView해주는 순서 중요!
- 정규식에서 리터럴한 문자를 받아오려면 \\뒤에 입력
    - 정규식은 시간있을때 다시 공부해봐야할듯

### 11/10

#### 내용

- 유저디폴트 코드 추가 및 매니저 코드 수정
- 네트워킹 모델 세팅
- 회사 번들 아이디로 테스트
    - 인증번호 확인하고 서버통신해서 화면전환까지 구현(회원가입해야됨)
- 전화번호 입력 화면
    - 전화번호 유효성 검사 로직 구현
    - 하이픈 추가 로직 구현
- 생년월일 화면
    - 만나이 계산 로직 수정
- 인증번호 화면
    - 코드 수정
        - 변수 줄일 수 있는건 줄여봄
    - 서버통신
    
#### 이슈

- 내 번호 막힘...
- HTTP info.plist에서 설정할때 포트번호는 빼주고 입력해주기
- 로그인쪽 네트워킹에서 에러디스크립션으로 상태를 처리해줬는데 localizedDescription이 예상과 다르게 옴.
    - 그래서 디스크립션을 사용하지않고 error 자체의 값을 이용함. error 자체가 내가 원하던 값이었음.
- 생년월일에서 선택하면 텍스트필드 색 바꿔주는거 구현해야함. 까먹었음

### 11/11

#### 내용

- 네트워크 통신
    - 회원가입
        - 닉네임안되면 다시 돌아가기
            - 기존 값 다시 세팅해주기
    - 로그인
- 인증번호 화면
    - 재요청 버튼 로직 구현
- 생년월일 화면
    - 생일 dateFormat 수정
- 토큰오류났을때 재요청 코드 추가
- 파이어베이스 통신 메서드 따로 싱글톤으로 구현


#### 이슈

- FCM 토큰 받아오는거 까먹었었음
    - Error in application:didFailToRegisterForRemoteNotificationsWithError: 응용 프로그램을 위한 유효한 ‘aps-environment’ 인타이틀먼트 문자열을 찾을 수 없습니다.
    이 오류가 떠서 추후에 확인해보기
    
- 이메일이 저장됐는데 다시 bind되면 초기화되는 이슈
    - bind되면서 유저디폴트에 빈값을 다시 저장해주고있었음
    - 저장하는 코드를 화면전환이 되기 전에 해줘서 해결
    
- 생년월일에서 birthday프로퍼티를 통해 처리해주고있었는데 Behavior릴레이로하면 초기값이 들어가서 bind구문이 실행되면 Date()값이 들어가 플레이스홀더가 아니라 입력된 값이 됨
    - 퍼블리쉬로 하면 해결 가능
- 생년월일에서 birthday의 값이 바뀌면 바로 유저디폴트에 value를 저장하도록 했는데 bind가 새로 될때마다 onErrorJustReturn에 적힌 값으로 자동으로 다시 저장해서 기존값이 안남아있음....
    - bind가 될때마다가 아니라 처음에는 괜찮음.
        - 하..date를 가져오는 메서드에서 Date()를 리턴하고 있어서 그랬던거였음...
        - viewWillAppear에서 유저디폴트값 가져와서 데이트피커의 date를 설정하면 해결됨.
            - 로직은 잘 되어있었는데 아
- 너무 오류해결하느라 못한 것도 많고 코드도 지저분함
    - 토요일까진 최소한 대부분 구현하고 조금이라도 리팩토링하고싶음
    
### 11/12

#### 내용

- 런치스크린
- 런치스크린이랑 같은 뷰컨트롤러 만들어서 화면 분기처리
- 폰트 추가
- 온보딩 화면
    - NSMutableAttributedString 적용
- 네트워크 연결 확인 로직 추가
    - 가장 상단에 window를 추가해서 연결 끊긴 것을 감지하면 뷰를 띄우도록 함
- 에러처리 구조 변경
    - 파이어베이스 자체의 오류 케이스를 이용해서 분기처리
        - 파이어베이스 매니저의 코드도 수정
- 백버튼 변경
    - 이미지는 AppDelegate에서 글로벌하게 설정할 수 있었지만 backButtonTitle은 설정할 수 없는 것 같았음.
- 인디케이터 추가
    - 서버통신 하는 동안에 버튼이 다시 안눌리게 막음
    
#### 이슈

- 파이어베이스 자체의 AuthErrorCode를 이용하여 분기처리를 할 수 있음.
- 네트워크 연결 쪽 다시 공부해보기
    
### 11/13

#### 내용

- 화면 분기 처리
    - 처음은 온보딩, 파베인증만 했으면 닉네임, 홈화면 들어갔었으면 핸드폰 인증화면
- 인풋 아웃풋 적용
    - 탭 제스쳐는 뷰모델의 input에서 받을 수 없었음.
    
#### 이슈

- bind 메서드가 항상 들어가므로 BaseVC의 viewDidLoad에서 추가하려고했음. 근데 생각해보니 베이스에서는 들어가는 코드도 없기도하고, bind메서드는 반드시 들어가므로 protocol로 만들어서 하는게 나을 것 같았음.
    - 근데 나는 뷰컨트롤러에서 구현이 되지 않았을때 오류가 뜨는 것을 원하므로 각 뷰컨트롤러마다 채택을 해줘야했음. 그러다보니 매번 같은 BaseViewController와 Bind프로토콜 두 개 모두 작성해줘야했음. typealias를 이용해보자.
    ~~~
    typealias ViewController = BaseViewController & Bind
    ~~~
    이렇게 작성하면 bind를 까먹지 않고 작성할 순 있지만 매번 호출해줘야한다는 단점과 private을 사용할 수 없다는 단점이 있긴한데 일단 작성해봤다.

### 11/14

#### 내용

- 내 정보 카드 UI 짜기만함...
    - 하나의 셀에 넣어 주었는데, 이름부분은 헤더로 빼야할 것 같기도함.

### 11/15

#### 이슈

- 계속해서 카드뷰 UI만 짜고있음.
    - 전체적인 구조는 하나의 뷰 안에 이미지뷰와 테이블뷰 하나가 들어가게끔 했음.
        - 처음엔 총 두 개의 셀을 사용하려고 했음. 이름을 보여주는 셀과 나머지를 보여주는 셀. 그리고 나머지를 보여주는 셀에서는 스택뷰로 세 뷰를 묶으려고 했는데 잘 안됐음.
        - 다음으로 생각한 방법은 이름을 보여주는 부분을 섹션 헤더로 설정하고, 아래 부분을 각각 세 개의 셀 타입으로 만들어서 보여주려고 함. 각각을 타입으로 만든다면 카드뷰를 재사용할때 하고 싶은 스터디 부분 추가가 간편할 것 같다고 생각했음. 
        

- 테이블뷰의 섹션 위쪽에 0이 아닌 디폴트 값을 가지는 패딩이 있음
    - tableView.sectionHeaderTopPadding 이용
    
    
### 11/16

#### 이슈

- 정보 관리 UI에서 스크롤 뷰안에 이미지뷰, 테이블뷰, 성별 등이 담긴 뷰 이렇게 세 뷰를 넣어주려고 했음. 테이블뷰가 다이나믹한 높이를 가지므로 스크롤을 막은 상태로 스크롤뷰에 넣어주려고 했음. 높이를 따로 설정해주지 않아서 스크롤뷰가 제대로 보여지기 위해서는 테이블뷰의 contentSize를 알아야했음. 
    결론만 말하면 자체의 크기를 나타내는 intrinsicContentSize를 contentSize로 설정해줌.
    좀 자세히 알아봐야 할 것 같음.
    - https://magi82.github.io/ios-intrinsicContentSize/
    - https://stackoverflow.com/questions/35028518/how-to-make-uitableview-fit-to-contents-size
    - https://developer.apple.com/documentation/uikit/uiview/1622600-intrinsiccontentsize
    
- 밤샜는데도 결국 오늘도 구현 못함.
    - 어차피 셀의 형태는 고정적이므로 row를 delete, insert하는 방식으로 해보려고했음. 근데 사라졌다 나오는 것까진 되는데 애니메이션이 안보임..하 
        - 스크롤뷰안에 담겨 있어서 그런가싶음. 테이블뷰에만 있으면 잘 될 것 같아서 아예 전체를 테이블뷰로 만들어야 할 수도 있을 것 같음

### 11/17

#### 내용

- 홈 화면
    - 기본 UI
    - 위치 권한 세팅

#### 이슈 

- 홈 화면에서 버튼을 만들때 configuration을 이용했는데 cornerradius가 정해져있어 직각으로 만들기 힘들어서 기존의 방식을 이용
- locationManagerDidChangeAuthorization은 위치 관리자 생성할 때 호출이 되어야하는데 되지 않음.

### 11/17

#### 내용

- 네트워크 세팅 수정
    - queue API 관련 세팅 추가
- 오류코드 수정..
- 홈 화면
    - RxCoreLocation 사용해봄
    
#### 이슈

- RxCoreLocation 사용해서 플로우 확인하는데 좀 걸림. 
~~~
/*
 실행되자마자 setRegion 실행(bind에 의해서 currentLocation이 behaviorRelay이므로 초기값으로 세팅)
 -> regionDidChangeAnimated 실행
 -> 내부의 startUpdatingLocation 실행 -> rx.location 실행(nil출력. 아직 권한 허용하기 전이기때문)
 -> 이제 viewDidLoad의 setregion메서드로 맵뷰에 로케이션 세팅 -> regionDidChange실행되어 startUpdating실행
 -> 아직 권한 설정 전이므로 didError실행
 -> 이제 권한 요청 허용 -> didChangeAuthorization에서 whenInUse 실행돼서 startUpdatingLocation실행
 -> 그로인해 didUpdateLocation 실행 -> viewModel의 currentLocation에 값 accept -> bind된 setRegion다시 실행돼서 가져온 위치로 맵뷰 세팅 -> 위치 가져오면서 위치가 바뀌었으므로 rx.location 다시 실행
 */
~~~

- api별로 상태코드가 전부 다름....
    - 그래서 각 통신별로 에러타입을 만들고, 각 타입을 case로 가지는 큰 enum을 만들어줌.
    이를 이용해 APIService의 failure를 분기처리함.
    - 통신 메서드에서 enum타입으로 에러를 전달했는데 받는 입장에서 Error타입이 와서 case를 쓸 수가 없음. localizedDescription으로 string값은 받을 수 있지만 enum 타입으로 사용할 수 있는지 궁금

### 11/18

#### 내용

- 네트워크 에러 처리 코드 수정
    - Results로 받던 것을 (data, statusCode)로 받아와서 처리하도록 해줌.
- 홈 화면
    - 기능 일부 구현
        - 맵 움직일 때 새싹 표시
        - gps버튼 누르면 내 위치로
        - 지도 축소/확대 비율 설정
            - setCameraZoomRange사용
        - 지도 interaction 설정
            - asyncafter 사용
        - 위치 거부 상태일때 지도 중심 영등포캠퍼스로 설정하고 서버통신
    - 아직 구현 못한 것
        - 성별 필터
        - 얼럿띄우기
        - 플로팅 버튼 로직
        
#### 이슈

- 위치 권한이 허용된 상태라면 앱을 다시 실행했을때 currentAuthStatus가 .notDetermined로 되어있어서 플로팅 버튼의 로직이 정상적으로 작동하지않음.
    - UserDefaults로 저장해서 해결할 수 있을 것 같음. 권한이 바뀌었을때 저장하는 식으로 하면 될듯
