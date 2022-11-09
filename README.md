과돟# SeSAC_Study

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
