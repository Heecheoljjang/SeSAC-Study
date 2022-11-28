//
//  ChattingViewController.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/18.
//

import UIKit
import RxSwift
import RxCocoa
import RxKeyboard
import SnapKit

final class ChattingViewController: ViewController {
    
    private var mainView = ChattingView()
    private let viewModel = ChattingViewModel()
    private let disposeBag = DisposeBag()
        
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func configure() {
        super.configure()
        
        navigationItem.leftBarButtonItem = mainView.backButton
        navigationItem.rightBarButtonItem = mainView.menuBarButton
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = true
        mainView.tableView.addGestureRecognizer(tapGesture)
    }
    
    func bind() {
        mainView.backButton.rx.tap
            .bind(onNext: { [weak self] _ in
                //MARK: 홈 화면 이동
            })
            .disposed(by: disposeBag)
        mainView.menuBarButton.rx.tap
            .bind(onNext: { [weak self] _ in
                //MARK: 메뉴띄우기
            })
            .disposed(by: disposeBag)
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] height in
                self?.setUpConstraints(height: height)
                UIView.animate(withDuration: 0.5) {
                    self?.mainView.layoutIfNeeded()
                }
            })
            .disposed(by: disposeBag)
        mainView.textView.rx.text
            .withUnretained(self)
            .bind(onNext: { (vc, _) in
                print(vc.checkTextViewLine())
                if vc.checkTextViewLine() {
                    vc.mainView.textView.isScrollEnabled = true
                }
            })
            .disposed(by: disposeBag)
            
        
    }
}

extension ChattingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyChattingTableViewCell.identifier) as? MyChattingTableViewCell else { return UITableViewCell() }
        switch indexPath.row {
        case 0:
            cell.messageLabel.text = "안ㄴㅇ란ㅇ리ㅏㄴㅇ머리ㅏㄴㅁ어리낭ㅁ러;ㅣㄴㅁㅇ러ㅣㅁㄴ;ㅏ얼ㄴ이마;렁ㄴㅁ;ㅣㅏ럼ㅇ니;ㅏ럼ㅇ;니ㅏ럼ㅇ니ㅏ;렁ㅁ니ㅏ;렁ㄴ미;렁"
        case 1:
            cell.messageLabel.text = "럼ㅇ니ㅏ;렁ㅁ니ㅏ;렁ㄴ미;렁"
        case 2:
            cell.messageLabel.text = "안ㄴㅇ란ㅇ리ㅏㄴㅇ머리ㅏㄴㅁ어리낭ㅁ러;ㅣㄴㅁㅇ러ㅣㅁㄴ;ㅏ얼ㄴ이마;렁ㄴㅁ;ㅣㅏ럼ㅇ니;ㅏ럼ㅇ;니ㅏ럼ㅇ니ㄴㅇ란ㅇ리ㅏㄴㅇ머리ㅏㄴㅁ어리낭ㅁ러;ㅣㄴㅁㅇ러ㅣㅁㄴ;ㅏ얼ㄴ이마;렁ㄴㅁ;ㅣㅏ럼ㅇ니;ㅏ럼ㅇ;니ㅏ럼ㅇ니ㅏ;렁ㄴㅇ란ㅇ리ㅏㄴㅇ머리ㅏㄴㅁ어리낭ㅁ러;ㅣㄴㅁㅇ러ㅣㅁㄴ;ㅏ얼ㄴ이마;렁ㄴㅁ;ㅣㅏ럼ㅇ니;ㅏ럼ㅇ;니ㅏ럼ㅇ니ㅏ;렁ㄴㅇ란ㅇ리ㅏㄴㅇ머리ㅏㄴㅁ어리낭ㅁ러;ㅣㄴㅁㅇ러ㅣㅁㄴ;ㅏ얼ㄴ이마;렁ㄴㅁ;ㅣㅏ럼ㅇ니;ㅏ럼ㅇ;니ㅏ럼ㅇ니ㅏ;렁ㅏ;렁ㅁ니ㅏ;렁ㄴ미;렁"
        case 3:
            cell.messageLabel.text = "렁"
        case 4:
            cell.messageLabel.text = "미;렁"
        case 5:
            cell.messageLabel.text = "럼ㅇ;니ㅏ럼ㅇ니ㅏ;렁ㅁ니ㅏ;렁ㄴ미;렁"
        default:
            cell.messageLabel.text = "안ㄴㅇ란ㅇ리ㅏㄴㅇ머리ㅏㄴㅁ어리낭ㅁ러;ㅣㄴㅁㅇ러ㅣㅁㄴ;ㅏ얼ㄴ이마;렁ㄴㅁ;ㅣㅏ럼ㅇ니;ㅏ럼ㅇ;니ㅏ럼ㅇ니ㅏ;렁ㅁ니ㅏ;렁ㄴ미;렁"
        }
        
        return cell
    }
}

extension ChattingViewController {
    private func setUpConstraints(height: CGFloat) {
        switch height {
        case 0:
            //다시 돌아가기
            mainView.messageView.snp.remakeConstraints { make in
                make.horizontalEdges.equalToSuperview().inset(16)
                make.bottom.equalTo(mainView.safeAreaLayoutGuide).offset(-16)
                make.height.greaterThanOrEqualTo(52)
            }
            mainView.tableView.snp.remakeConstraints { make in
                make.horizontalEdges.equalToSuperview()
                make.bottom.equalTo(mainView.messageView.snp.top).offset(-12)
                make.top.equalTo(mainView.safeAreaLayoutGuide)
            }
        default:
            //올리기
            mainView.messageView.snp.remakeConstraints { make in
                make.horizontalEdges.equalToSuperview().inset(16)
                make.bottom.equalToSuperview().offset(-height-16)
                make.height.greaterThanOrEqualTo(52)
            }
            mainView.tableView.snp.remakeConstraints { make in
                make.horizontalEdges.equalToSuperview()
                make.bottom.equalTo(mainView.messageView.snp.top).offset(-12)
                make.top.equalTo(mainView.safeAreaLayoutGuide)
            }
        }
    }
    
    private func checkTextViewLine() -> Bool {
        return mainView.textView.checkNumberOfLines() == 4 ? true : false
    }
}

extension ChattingViewController {
    @objc private func dismissKeyboard() {
        mainView.messageView.endEditing(true)
    }
}
