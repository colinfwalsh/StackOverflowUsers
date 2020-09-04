//
//  UserViewModel.swift
//  StackOverflowUsers
//
//  Created by Colin Walsh on 9/4/20.
//  Copyright © 2020 Colin Walsh. All rights reserved.
//

import Foundation

class UserViewModel {
    private let _model: SOUser
    
    init(model: SOUser) {
        _model = model
    }
    
    func getProfileUrl() -> URL {
        return URL(string: _model.profileImage)!
    }
    
    func getDisplayName() -> String {
        return _model.displayName
    }
    
    func getGoldBadgeCount() -> Int {
        return _model.badgeCounts.gold
    }
    
    func getSilverBadgeCount() -> Int {
        return _model.badgeCounts.silver
    }
    
    func getBronzeBadgeCount() -> Int {
        return _model.badgeCounts.bronze
    }
}
