//
//  APIResult.swift
//  MovieApp
//
//  Created by Anshul Shah on 12/11/18.
//  Copyright © 2018 Anshul Shah. All rights reserved.
//

import Foundation

enum APIResult <Value> {
    
    case success(value: Value)
    
    case failure(error: APICallError)
    
    // Remove it if not needed.
    init(_ f: () throws -> Value) {
        do {
            let value = try f()
            self = .success(value: value)
        } catch let error as APICallError {
            self = .failure(error: error)
        } catch let error {
            plog(error)
            self = .failure(error: APICallError(status: .failed))
        }
    }
}
