//
//  API.swift
//  MovieApp
//
//  Created by Anshul Shah on 12/11/18.
//  Copyright © 2018 Anshul Shah. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire
import Alamofire

class API {
    
    static let shared:API = {
        let instance = API()
        return instance
    }()
    
    init() {
        
    }
    
    // Call Get Movie List API
    func getMovieList(param: Parameters) -> Observable<APIResult<GetMovieResponse>> {
        
        return API.handleDataRequest(dataRequest: APIManager.shared.requestObservable(api: APIRouter.getMovieList(param))).map({ (response) -> APIResult<GetMovieResponse> in
            if (response ?? [:]).keys.contains("Error") {
                if (response ?? [:]).keys.contains("IsInternetOff") {
                    if let isInternetOff = response!["IsInternetOff"] as? Bool {
                        if isInternetOff {
                            return APIResult.failure(error: APICallError(critical: false, code: InternetConnectionErrorCode.offline.rawValue, reason: response!["Error"] as! String, message: response!["Error"] as! String))
                        }
                    }
                }
                return APIResult.failure(error: APICallError(critical: false, code: 1111, reason: response!["Error"] as! String, message: response!["Error"] as! String))
            }
            
            let apiResponse = GetMovieResponse(response: response)
            let (apiStatus, _) = (true, APICallError.init(status: .success))
            if apiStatus { return APIResult.success(value: apiResponse) }
        })
    }
    
    // Call movie details API
    func getMovieDetails(id: String,param: Parameters) -> Observable<APIResult<GetMovieDetailResponse>> {
        
        return API.handleDataRequest(dataRequest: APIManager.shared.requestObservable(api: APIRouter.getMovieDetails(movieId: id, param: param))).map({ (response) -> APIResult<GetMovieDetailResponse> in
            if (response ?? [:]).keys.contains("Error"){
                if (response ?? [:]).keys.contains("IsInternetOff"){
                    if let isInternetOff = response!["IsInternetOff"] as? Bool{
                        if isInternetOff{
                            return APIResult.failure(error: APICallError(critical: false, code: InternetConnectionErrorCode.offline.rawValue, reason: response!["Error"] as! String, message: response!["Error"] as! String))
                        }
                    }
                }
                return APIResult.failure(error: APICallError(critical: false, code: 1111, reason: response!["Error"] as! String, message: response!["Error"] as! String))
            }
            let apiResponse = GetMovieDetailResponse(response: response)
            let (apiStatus, _) = (true,APICallError.init(status: .success))
            if apiStatus { return APIResult.success(value: apiResponse) }
        })
    }
    
    
    private static func handleDataRequest(dataRequest: Observable<DataRequest>) -> Observable<[String:Any]?> {

        if NetworkReachabilityManager()!.isReachable == false {
            return Observable<[String: Any]?>.create({ (observer) -> Disposable in
                observer.on(.next(["Error":NSLocalizedString("Unable to contact the server", comment: "") ,
                                   "IsInternetOff":true]))
                observer.on(.completed)
                return Disposables.create()
            })
        }
        
        return Observable<[String: Any]?>.create({ (observer) -> Disposable in
            dataRequest.observeOn(MainScheduler.instance).subscribe({ (event) in
                
                switch event {
                    
                case .next(let e):
                    plog(e.debugDescription)
                    
                    e.responseJSON(completionHandler: { (dataResponse) in
                        
                        switch dataResponse.result {
                            
                        case .success(let data):
                            
                            guard var json = data as? [String:Any] else {
                                observer.onNext(nil)
                                return
                            }
                            json.updateValue(dataResponse.response!.statusCode, forKey: "status")
                            plog(json.keysToCamelCase)
                            
                            guard dataResponse.response!.statusCode == 200  else {
                                observer.onNext(["Error":json.keysToCamelCase["statusMessage"] ?? "",
                                                 "IsInternetOff":false])
                                return
                            }
                            
                            observer.onNext(json.keysToCamelCase)
                            
                        case .failure(let error):
                            plog(error)
                            let errorCode = (error as NSError).code
                            if errorCode == -1005 || errorCode == -1009 {
                                observer.onNext(["Error": NSLocalizedString("Unable to contact the server", comment: ""),
                                                 "IsInternetOff":true])
                            } else {
                                observer.onNext(["Error":error.localizedDescription,
                                                 "IsInternetOff":false])
                            }
                            
                            observer.onCompleted()
                        }
                    })
                    
                case .error(let error):
                    plog(error)
                    observer.onNext(["Error":error.localizedDescription])
                    observer.onNext(nil)
                    
                case .completed:
                    observer.onCompleted()
                }
            })
        })
    }

}

