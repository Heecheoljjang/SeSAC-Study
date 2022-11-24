//
//  ProfileViewController.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/14.
//

import UIKit
import RxCocoa
import RxSwift
import MultiSlider

final class ProfileViewController: ViewController {
    private var mainView = ProfileView()
    private let viewModel = ProfileViewModel()
    private let disposeBag = DisposeBag()
    
    private let saveButton = UIBarButtonItem(title: ButtonTitle.save, style: .plain, target: nil, action: nil)
    
    private var isCollapsed = true
        
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        viewModel.fetchUserInfo()
    }
    
    func bind() {
        
        saveButton.rx.tap
            .bind(onNext: { [weak self] _ in
                //MARK: 서버통신
                self?.viewModel.saveInfo()
            })
            .disposed(by: disposeBag)
        
        viewModel.userInfo
            .asDriver(onErrorJustReturn: [])
            .drive(mainView.cardView.tableView.rx.items(cellIdentifier: ProfileTableViewCell.identifier, cellType: ProfileTableViewCell.self)) { [weak self] (row, element, cell) in
                cell.requestButton.isHidden = true
                cell.nameView.clearButton.addTarget(self, action: #selector(self?.touchToggleButton(_:)), for: .touchUpInside)
                //배경이미지, 새싹이미지, 새싹타이틀, 리뷰
                guard let backgroundImage = BackgroundImage(rawValue: element.background)?.imageName,
                      let sesacImage = UserProfileImage(rawValue: element.sesac)?.image else { return }
    
                cell.backgroundImageView.image = UIImage(named: backgroundImage)
                cell.sesacImageView.image = UIImage(named: sesacImage)
                cell.nameView.nameLabel.text = element.nick
                for i in 0..<element.reputation.count {
                    if element.reputation[i] == 0 {
                        continue
                    }
                    switch i {
                    case 0:
                        self?.changeTitleButtonColor(button: cell.sesacTitleView.goodButton, status: .enable)
                    case 1:
                        self?.changeTitleButtonColor(button: cell.sesacTitleView.timeButton, status: .enable)
                    case 2:
                        self?.changeTitleButtonColor(button: cell.sesacTitleView.fastButton, status: .enable)
                    case 3:
                        self?.changeTitleButtonColor(button: cell.sesacTitleView.kindButton, status: .enable)
                    case 4:
                        self?.changeTitleButtonColor(button: cell.sesacTitleView.expertButton, status: .enable)
                    case 5:
                        self?.changeTitleButtonColor(button: cell.sesacTitleView.helpfulButton, status: .enable)
                    default:
                        break
                    }
                }
                if element.comment.count != 0 {
                    cell.reviewView.detailButton.isHidden = false
                    cell.reviewView.label.text = element.comment[0]
                    cell.reviewView.label.textColor = .black
                }
            }
            .disposed(by: disposeBag)

        viewModel.userInfo
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] value in
                let data = value[0]
                self?.viewModel.setInfoValues(data: data)
                self?.mainView.ageView.slider.value = [CGFloat(data.ageMin), CGFloat(data.ageMax)]
            })
            .disposed(by: disposeBag)
        
        viewModel.gender
            .asDriver(onErrorJustReturn: .man)
            .drive(onNext: { [weak self] gender in
                self?.setGenderColor(gender: gender)
            })
            .disposed(by: disposeBag)
        
        viewModel.study
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { [weak self] value in
                //비어있으면 알아서 플레이스홀더로 될듯
                self?.mainView.studyView.textField.text = value
            })
            .disposed(by: disposeBag)
        
        viewModel.searchable
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] value in
                self?.mainView.searchView.allowSwitch.setOn(value, animated: true)
            })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(viewModel.ageMin, viewModel.ageMax) { min, max in
            "\(min) - \(max)"
        }
        .asDriver(onErrorJustReturn: "")
        .drive(onNext: { [weak self] value in
            print(value)
            self?.mainView.ageView.settingLabel.text = value
        })
        .disposed(by: disposeBag)
        
        mainView.genderView.manButton.rx.tap
            .withUnretained(self)
            .bind(onNext: { vc, _ in
                vc.changeSelectedButtonColor(button: vc.mainView.genderView.manButton, status: .enable)
                vc.changeSelectedButtonColor(button: vc.mainView.genderView.womanButton, status: .disable)
                vc.viewModel.setGender(value: .man)
            })
            .disposed(by: disposeBag)
        
        mainView.genderView.womanButton.rx.tap
            .withUnretained(self)
            .bind(onNext: { vc, _ in
                vc.changeSelectedButtonColor(button: vc.mainView.genderView.womanButton, status: .enable)
                vc.changeSelectedButtonColor(button: vc.mainView.genderView.manButton, status: .disable)
                vc.viewModel.setGender(value: .woman)
            })
            .disposed(by: disposeBag)
        
        mainView.studyView.textField.rx.text
            .bind(onNext: { [weak self] value in
                if let value = value {
                    print("텍스트: \(value)")
                    self?.viewModel.setStudy(value: value)
                }
            })
            .disposed(by: disposeBag)
        
        mainView.searchView.allowSwitch.rx.value
            .bind(onNext: { [weak self] value in
                print("스위치: \(value)")
                self?.viewModel.setSearchable(value: value)
            })
            .disposed(by: disposeBag)
        
        mainView.withdrawButton.rx.tap
            .bind(onNext: { [weak self] _ in
                //회원탈퇴 서버통신
                self?.handlerAlert(title: AlertText.withdraw.title, message: AlertText.withdraw.message, handler: { _ in
                    self?.viewModel.withdrawUser()
                })
            })
            .disposed(by: disposeBag)
        
        viewModel.actionType
            .asDriver(onErrorJustReturn: .update)
            .drive(onNext: { [weak self] value in
                self?.changeVC(type: value)
            })
            .disposed(by: disposeBag)
    }
    
    override func configure() {
        super.configure()
        
        title = NavigationBarTitle.manageInfo.title
        navigationItem.rightBarButtonItem = saveButton
        mainView.ageView.slider.addTarget(self, action: #selector(sliderChanged(_:)), for: .valueChanged)
    }
}
extension ProfileViewController {
    private func setGenderColor(gender: Gender) {
        switch gender {
        case .man:
            changeSelectedButtonColor(button: mainView.genderView.manButton, status: .enable)
            changeSelectedButtonColor(button: mainView.genderView.womanButton, status: .disable)
        case .woman:
            changeSelectedButtonColor(button: mainView.genderView.manButton, status: .disable)
            changeSelectedButtonColor(button: mainView.genderView.womanButton, status: .enable)
        }
    }
    
    private func changeVC(type: MyInfoActionType) {
        switch type {
        case .update:
            presentToast(view: mainView, message: type.message)
            transition(self, transitionStyle: .pop)
        case .updateFail, .withdrawFail:
            presentToast(view: mainView, message: type.message)
        case .withdraw:
            presentToast(view: mainView, message: type.message)
            let vc = OnboardingViewController()
            changeRootViewController(viewcontroller: vc, isTabBar: false)
        }
    }
    
    private func changeTitleButtonColor(button: UIButton, status: ButtonStatus) {
        switch status {
        case .enable:
            button.layer.borderWidth = 0
            button.configuration?.baseBackgroundColor = .brandGreen
            button.configuration?.baseForegroundColor = .white
        case .disable:
            button.layer.borderWidth = 1
            button.configuration?.baseBackgroundColor = .clear
            button.configuration?.baseForegroundColor = .black
        }
    }
    
    @objc private func sliderChanged(_ sender: MultiSlider) {
        viewModel.setAge(value: sender.value)
    }
    
    @objc private func touchToggleButton(_ sender: UIButton) {
        isCollapsed = !isCollapsed
        guard let cell = mainView.cardView.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ProfileTableViewCell else { return }
        cell.sesacTitleView.isHidden = isCollapsed
        cell.reviewView.isHidden = isCollapsed
        cell.nameView.chevronButton.configuration?.image = isCollapsed ? UIImage(named: ImageName.downChevron) : UIImage(named: ImageName.upChevron)
        mainView.cardView.tableView.reloadData()
    }
}
