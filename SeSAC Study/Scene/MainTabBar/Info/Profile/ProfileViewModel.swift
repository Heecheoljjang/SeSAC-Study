//
//  ProfileViewModel.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/14.
//

import Foundation
import RxSwift
import RxCocoa

final class ProfileViewModel {
    
    var userInfo = PublishRelay<[SignIn]>()
    var gender = BehaviorRelay<Gender>(value: .man)
    var study = BehaviorRelay<String>(value: "")
    var searchable = BehaviorRelay<Bool>(value: false)
    var ageMin = BehaviorRelay<Int>(value: 18)
    var ageMax = BehaviorRelay<Int>(value: 65)
    var actionType = PublishRelay<MyInfoActionType>()
    
    func fetchUserInfo() {
        //화면전환 되기 바로 전에 통신을 하고 여기서는 불러와서 사용
        guard let data = UserDefaultsManager.shared.fetchValue(type: .userInfo) as? SignIn else { return }
        userInfo.accept([data])
    }
    
    func setInfoValues(data: SignIn) {
        //성별
        data.gender == 0 ? gender.accept(.woman) : gender.accept(.man)
        //스터디 => 빈칸이면 처리
        study.accept(data.study)
        //검색허용
        data.searchable == 0 ? searchable.accept(false) : searchable.accept(true)
        //나이
        ageMin.accept(data.ageMin)
        ageMax.accept(data.ageMax)
    }
    
    func setAge(value: [CGFloat]) {
        ageMin.accept(Int(value[0]))
        ageMax.accept(Int(value[1]))
    }
    
    func withdrawUser() {
        let api = SeSacAPI.withdraw
        
        APIService.shared.noResponseRequest(method: .post, url: api.url, parameters: api.parameters, headers: api.headers) { [weak self] statusCode in
            guard let status = WithdrawError(rawValue: statusCode) else { return }
            switch status {
            case .withdrawSuccess:
                print("회원탈퇴 성공")
                //유저디폴트 전부삭제
                UserDefaultsManager.shared.removeAll()
                //상태바꾸기
                self?.actionType.accept(.withdraw)
            default:
                self?.actionType.accept(.withdrawFail)
            }
        }
    }
    
    func saveInfo() {
        //서버통신
        let searchable = searchable.value ? 1 : 0
        let ageMin = ageMin.value
        let ageMax = ageMax.value
        let gender = gender.value == .man ? 1 : 0
        let study = study.value
        print(searchable, ageMin, ageMax, gender, study)
        let api = SeSacAPI.update(searchable: searchable, ageMin: ageMin, ageMax: ageMax, gender: gender, study: study)
        
        APIService.shared.noResponseRequest(method: .put, url: api.url, parameters: api.parameters, headers: api.headers) { [weak self] statusCode in
            guard let status = UpdateError(rawValue: statusCode) else { return }
            switch status {
            case .updateSuccess:
                print("업데이트 성공")
                self?.actionType.accept(.update)
            default:
                print("업데이트실패")
                self?.actionType.accept(.updateFail)
            }
        }
    }
    
    func setGender(value: Gender) {
        gender.accept(value)
    }
    
    func setStudy(value: String) {
        study.accept(value)
    }
    
    func setSearchable(value: Bool) {
        searchable.accept(value)
    }
}
