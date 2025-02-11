//
//  StackOverflowAPI.swift
//  StackOverflowUsers
//
//  Created by Colin Walsh on 9/4/20.
//  Copyright © 2020 Colin Walsh. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import RxAlamofire

struct SOClient {
    // In production, I'd seperate this into multiple parts
    /* e.g baseUrl = https://api.stackexchange.com/
     version = 2.2
     endpoint = ...
     args = [...]
     */
    static let baseUrl = "https://api.stackexchange.com/2.2/users?"

    static func generateUrlFor(page: Int) -> String {
        let pageArg = "page=\(page)&site=stackoverflow"
        return SOClient.baseUrl + pageArg
    }
    
    // Alamofire session
    static let session = Session.default
    
    /*
     Fetch the users for a given page, SOClient does not care about keeping track of the page
     its only concern is returning the result for a given page.
     */
    static func fetchUsers(for page: Int) -> Observable<ApiResult<SOData, ApiErrorMessage>>{
        return SOClient.session.rx
            .request(.get, SOClient.generateUrlFor(page: page))
            .responseData()
            .timeout(DispatchTimeInterval.milliseconds(10000), // Timeout after 10 seconds
                     scheduler: MainScheduler.instance)
            .mapToObject(ofType: SOData.self)
    }
    
    
    
}
