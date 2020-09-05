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
    static let requestUrl = "https://api.stackexchange.com/2.2/users?page=1&site=stackoverflow"
    
    // Alamofire session
    static let session = Session.default
    
    static func fetchUsers() -> Observable<ApiResult<SOData, ApiErrorMessage>>{
        return SOClient.session.rx
            .request(.get, SOClient.requestUrl)
            .responseData()
            .timeout(DispatchTimeInterval.milliseconds(10000),//DispatchTimeInterval.microseconds(3000000),
                     scheduler: MainScheduler.instance)
            .mapToObject(ofType: SOData.self)
    }
    
    
    
}
