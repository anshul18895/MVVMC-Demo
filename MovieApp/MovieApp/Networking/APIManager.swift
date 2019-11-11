//
//  APIManager.swift
//  MovieApp
//
//  Created by Anshul Shah on 12/11/18.
//  Copyright © 2018 Anshul Shah. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import RxAlamofire


class APIManager {

    static let shared:APIManager = {
        let instance = APIManager()
        return instance
    }()
    
    let sessionManager:SessionManager
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.urlCache = nil
        sessionManager = Alamofire.SessionManager(configuration: configuration)
    }
    
    func requestObservable(api:APIRouter) -> Observable<DataRequest> {
        return sessionManager.rx.request(urlRequest: api)
    }
    
}
