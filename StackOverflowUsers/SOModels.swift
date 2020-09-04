//
//  SOModels.swift
//  StackOverflowUsers
//
//  Created by Colin Walsh on 9/4/20.
//  Copyright © 2020 Colin Walsh. All rights reserved.
//

import Foundation


struct SOData: Decodable {
    let items: [SOUser]
}

struct SOUser: Decodable {
    let badgeCounts: SOBadges
    let accountId: Int
    let profileImage: String
    let displayName: String
}

struct SOBadges: Decodable {
    let bronze: Int
    let silver: Int
    let gold: Int
}
