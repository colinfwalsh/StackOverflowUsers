//
//  UserViewModel.swift
//  StackOverflowUsers
//
//  Created by Colin Walsh on 9/4/20.
//  Copyright © 2020 Colin Walsh. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Kingfisher

class UserViewModel {
    private let _model: SOUser
    private let _isLoadingImage = BehaviorRelay(value: false)
    
    init(model: SOUser) {
        _model = model
    }
    
    func getProfileUrl() -> URL? {
        guard let profileString = _model.profileImage else {return nil}
        return URL(string: profileString)
    }
    
    func getDisplayName() -> String {
        guard let displayName = _model.displayName else {return "None"}
        return displayName
    }
    
    func getGoldBadgeCount() -> String {
        guard let badgeCounts = _model.badgeCounts,
              let gold = badgeCounts.gold
        else {return String(-1)}
        
        return String(gold)
    }
    
    func getSilverBadgeCount() -> String {
        guard let badgeCounts = _model.badgeCounts,
              let silver = badgeCounts.silver
        else {return String(-1)}
        
        return String(silver)
    }
    
    func getBronzeBadgeCount() -> String {
        guard let badgeCounts = _model.badgeCounts,
              let bronze = badgeCounts.bronze
        else {return String(-1)}
        
        return String(bronze)
    }
    
    func updateIsLoading(value: Bool) {
        _isLoadingImage.accept(value)
    }
    
    func getIsLoadingImage() -> Driver<Bool> {
        return _isLoadingImage
            .observeOn(MainScheduler.asyncInstance)
            .asDriver(onErrorDriveWith: Driver.empty())
    }
    
}
