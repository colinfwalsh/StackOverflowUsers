//
//  APIHelpers.swift
//  StackOverflowUsers
//
//  Created by Colin Walsh on 9/4/20.
//  Copyright © 2020 Colin Walsh. All rights reserved.
//

import Foundation


/*
 Helper functions that are consumed in our Observable+Codable extension.  Makes processing requests easier.
 */
enum ApiResult<Value, Error>{
    case success(Value)
    case failure(Error)
    
    init(value: Value){
        self = .success(value)
    }
    
    init(error: Error){
        self = .failure(error)
    }
}

struct ApiErrorMessage: Codable{
    let error_message: String
}
