//
//  UserListViewModel.swift
//  StackOverflowUsers
//
//  Created by Colin Walsh on 9/4/20.
//  Copyright © 2020 Colin Walsh. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class UserListViewModel {
    private let _userList: BehaviorRelay<[UserViewModel]> = BehaviorRelay(value: [])
    private let _didError = BehaviorRelay(value: false)
    private let _isLoading = BehaviorRelay(value: false)
    private let _disposeBag = DisposeBag()
    
    init() {
        userFetch()
    }
    
    func userFetch() {
        _isLoading.accept(true)
        SOClient
            .fetchUsers()
            .catchErrorJustReturn (
                ApiResult.init(error:
                    ApiErrorMessage(error_message:
                        "Timeout Occured")
                )
            )
            .subscribe(onNext: {[unowned self] result in
                self._isLoading.accept(false)
                switch result {
                case .success(let userData):
                    
                    let userMap =
                        userData
                            .items
                            .compactMap {$0}
                            .map {UserViewModel(model: $0)}
                    
                    self._userList.accept(userMap)
                case .failure(let error):
                    print(error.error_message)
                    self._didError.accept(true)
                }
            })
            .disposed(by: _disposeBag)
    }
    
    func getDidError() -> Driver<Bool> {
        return _didError.asDriver()
    }
    
    func getUserList() -> Driver<[UserViewModel]> {
        return _userList.asDriver()
    }
    
    func getIsLoading() -> Driver<Bool> {
        return _isLoading.asDriver()
    }
}
