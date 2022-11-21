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
    var gender = PublishRelay<Gender>()
    var study = PublishRelay<String>()
    var searchable = PublishRelay<Bool>()
    var ageMin = PublishRelay<Int>()
    var ageMax = PublishRelay<Int>()
    
    func fetchUserInfo() {
        //화면전환 되기 바로 전에 통신을 하고 여기서는 불러와서 사용
        guard let data = UserDefaultsManager.shared.fetchValue(type: .userInfo) as? SignIn else { return }
        userInfo.accept([data])
    }
    
    func saveInfo() {
        //MARK: 정보 저장하는 서버 통신
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
        
    }
}
