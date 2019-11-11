//
//  GetMovieResponse.swift
//  MovieApp
//
//  Created by Anshul Shah on 11/13/18.
//  Copyright © 2018 Anshul Shah. All rights reserved.
//

import Foundation

class GetMovieResponse: Codable {
    
    var page: Int?
    var totalResult: Int?
    var totalPages: Int?
    var results: [Movie]?
    
    var nextPage: Int? {
        guard let _page = page else {
            return nil
        }
        guard let _totalPages = totalPages else{
            return nil
        }
        if _page == _totalPages {
            return nil
        }
        return _page + 1
    }
    
    init(response: [String: Any]?) {
        guard let response = response else {
            return
        }
        if let moviesData = try? JSONSerialization.data(withJSONObject: response.keysToCamelCase, options: []) {
            if let movieResponse = try? JSONDecoder().decode(GetMovieResponse.self, from: moviesData) {
                self.page = movieResponse.page
                self.totalPages = movieResponse.totalPages
                self.totalResult = movieResponse.totalResult
                self.results = movieResponse.results
            }
        }
    }
}


class Movie: Codable {

    var id: Int?
    var title: String?
    var overview: String?
    var posterPath: String?
    var releaseDate: String?
    
    var imageURL : String {
        if _imageURL != nil {
            return _imageURL ?? ""
        }
        if posterPath != nil {
            return IMAGE_URL + (posterPath ?? "")
        }
        return ""
    }
    var _imageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case id
        case title
        case overview
        case releaseDate = "release_date"
    }
    
    init(model: MoviesCoredataModel){
        self.id = Int(model.id)
        self.title = model.title
        self._imageURL = model.imageURL
        self.overview = model.overview
        self.releaseDate = model.releaseDate
    }
    
}

