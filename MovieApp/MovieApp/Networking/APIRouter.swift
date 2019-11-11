//
//  APIRouter.swift
//  MovieApp
//
//  Created by Anshul Shah on 12/11/18.
//  Copyright © 2018 Anshul Shah. All rights reserved.
//

import Foundation
import Alamofire


enum APIRouter:URLRequestConvertible {
    
    case getMovieList(Parameters)
    case getMovieDetails(movieId: String, param: Parameters)
    
    
    func asURLRequest() throws -> URLRequest {
        
        var method: HTTPMethod {
            switch self {
            case .getMovieList, .getMovieDetails:
                return .get
            }
        }
        
        let params: ([String: Any]?) = {
            switch self {
            case .getMovieList(let param):
                return param
            case .getMovieDetails(_, let param):
                return param
            }
        }()
        
        let url: URL = {
            
            // Add base url for the request
            let baseURL:String = {
                return Environment.APIBasePath()
            }()
            
            let apiVersion: String? = {
                return Environment.APIVersionPath()
            }()
            
            // build up and return the URL for each endpoint
            let relativePath: String? = {
                switch self {
                case .getMovieList:
                    return "discover/movie"
                case .getMovieDetails(let id, _):
                    return "movie/\(id)"
                }
            }()
            
            
            var urlWithAPIVersion = baseURL
            
            if let apiVersion = apiVersion {
                urlWithAPIVersion = urlWithAPIVersion + apiVersion
            }
            
            var url = URL(string: urlWithAPIVersion)!
            if let relativePath = relativePath {
                url = url.appendingPathComponent(relativePath)
            }
            return url
        }()
        
        let encoding:ParameterEncoding = {
            return URLEncoding.default
        }()
        
        let headers:[String:String]? = {
            return nil
        }()
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers
        
        
        return try encoding.encode(urlRequest, with: params)
    }
}
