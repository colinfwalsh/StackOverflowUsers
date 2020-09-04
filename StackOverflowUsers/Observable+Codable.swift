//
//  Observable+Codable.swift
//  StackOverflowUsers
//
//  Created by Colin Walsh on 9/4/20.
//  Copyright © 2020 Colin Walsh. All rights reserved.
//

import Foundation
import RxSwift

extension Observable where Element == (HTTPURLResponse, Data){
    func mapToObject<T : Decodable>(ofType: T.Type) -> Observable<ApiResult<T, ApiErrorMessage>>{
        return self.map{ (httpURLResponse, data) -> ApiResult<T, ApiErrorMessage> in
            switch httpURLResponse.statusCode{
            case 200 ... 299:
                
                let decoder = JSONDecoder()
                // Converts fields such as "user_name" to "userName"
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let object = try decoder.decode(ofType, from: data)

                return .success(object)
            default:
                let apiErrorMessage: ApiErrorMessage
                do{
                    apiErrorMessage = try JSONDecoder().decode(ApiErrorMessage.self, from: data)
                } catch _ {
                    apiErrorMessage = ApiErrorMessage(error_message: "Server Error.")
                }
                return .failure(apiErrorMessage)
            }
        }
    }
}
