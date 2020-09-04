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
    
    func getProfileUrl() -> URL? {
        guard let profileString = _model.profileImage else {return nil}
        return URL(string: profileString)
    }
    
    func getDisplayName() -> String {
        guard let displayName = _model.displayName else {return "None"}
        return displayName
    }
    
    func getGoldBadgeCount() -> Int {
        guard let badgeCounts = _model.badgeCounts,
              let gold = badgeCounts.gold
        else {return -1}
        
        return gold
    }
    
    func getSilverBadgeCount() -> Int {
        guard let badgeCounts = _model.badgeCounts,
              let silver = badgeCounts.silver
        else {return -1}
            
        return silver
    }
    
    func getBronzeBadgeCount() -> Int {
        guard let badgeCounts = _model.badgeCounts,
              let bronze = badgeCounts.bronze
        else {return -1}
        
        return bronze
    }
}
