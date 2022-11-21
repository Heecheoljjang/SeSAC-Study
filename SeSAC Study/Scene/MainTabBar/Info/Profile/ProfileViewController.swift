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
                cell.studyView.isHidden = true
                //배경이미지, 새싹이미지, 새싹타이틀, 리뷰
                guard let backgroundImage = BackgroundImage(rawValue: element.background)?.imageName,
                      let sesacImage = UserProfileImage(rawValue: element.sesac)?.image else { return }
    
                cell.backgroundImageView.image = UIImage(named: backgroundImage)
                cell.sesacImageView.image = UIImage(named: sesacImage)
                cell.nameView.nameLabel.text = element.nick
                element.reputation.forEach {
                    switch $0 {
                    case 0:
                        if $0 != 0 {
                            self?.changeButtonColor(button: cell.sesacTitleView.goodButton, status: .enable)
                        }
                    case 1:
                        if $0 != 0 {
                            self?.changeButtonColor(button: cell.sesacTitleView.timeButton, status: .enable)
                        }
                    case 2:
                        if $0 != 0 {
                            self?.changeButtonColor(button: cell.sesacTitleView.fastButton, status: .enable)
                        }
                    case 3:
                        if $0 != 0 {
                            self?.changeButtonColor(button: cell.sesacTitleView.kindButton, status: .enable)
                        }
                    case 4:
                        if $0 != 0 {
                            self?.changeButtonColor(button: cell.sesacTitleView.expertButton, status: .enable)
                        }
                    default:
                        if $0 != 0 {
                            self?.changeButtonColor(button: cell.sesacTitleView.helpfulButton, status: .enable)
                        }
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
        
        mainView.withdrawButton.rx.tap
            .bind(onNext: { [weak self] _ in
                //회원탈퇴 서버통신
                self?.viewModel.withdrawUser()
            })
            .disposed(by: disposeBag)
        
    }
    
    override func configure() {
        super.configure()
        
        title = "정보 관리"
        navigationItem.rightBarButtonItem = saveButton
        mainView.ageView.slider.addTarget(self, action: #selector(sliderChanged(_:)), for: .valueChanged)
    }
    
    @objc private func tapHeaderView() {
        print("123")
//        isCollapsed ? mainView.cardView.tableView.insertRows(at: [IndexPath(row: 2, section: 0), IndexPath(row: 1, section: 0), IndexPath(row: 0, section: 0)], with: .fade) : mainView.cardView.tableView.deleteRows(at: [IndexPath(row: 2, section: 0), IndexPath(row: 1, section: 0), IndexPath(row: 0, section: 0)], with: .fade)
        if isCollapsed {
            //true면 접혀있는 상태니까 펴야하므로 insert
//            test.append(contentsOf: [1,2,3])
            mainView.cardView.tableView.insertRows(at: [IndexPath(row: 2, section: 0), IndexPath(row: 1, section: 0), IndexPath(row: 0, section: 0)], with: .automatic)
        } else {
            //반대
//            test.removeAll()
            mainView.cardView.tableView.deleteRows(at: [IndexPath(row: 2, section: 0), IndexPath(row: 1, section: 0), IndexPath(row: 0, section: 0)], with: .automatic)
        }

//        mainView.headerView.chevronButton.rotate(isCollapsed ? .pi : 0, duration: 0.3)
        isCollapsed = !isCollapsed
//        mainView.cardView.tableView.reloadData()
    }
}
extension ProfileViewController {
    private func setGenderColor(gender: Gender) {
        switch gender {
        case .man:
            mainView.genderView.manButton.configuration?.baseForegroundColor = .white
            mainView.genderView.manButton.configuration?.baseBackgroundColor = .brandGreen
            mainView.genderView.manButton.layer.borderWidth = 0
            mainView.genderView.womanButton.configuration?.baseForegroundColor = .black
            mainView.genderView.womanButton.configuration?.baseBackgroundColor = .clear
            mainView.genderView.womanButton.layer.borderWidth = 1
        case .woman:
            mainView.genderView.womanButton.configuration?.baseForegroundColor = .white
            mainView.genderView.womanButton.configuration?.baseBackgroundColor = .brandGreen
            mainView.genderView.womanButton.layer.borderWidth = 0
            mainView.genderView.manButton.configuration?.baseForegroundColor = .black
            mainView.genderView.manButton.configuration?.baseBackgroundColor = .clear
            mainView.genderView.manButton.layer.borderWidth = 1
        }
    }
    @objc private func sliderChanged(_ sender: MultiSlider) {
        viewModel.setAge(value: sender.value)
    }
}
