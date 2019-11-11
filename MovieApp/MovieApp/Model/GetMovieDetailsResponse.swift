//
//  GetMovieDetailsResponse.swift
//  MovieApp
//
//  Created by Anshul Shah on 11/13/18.
//  Copyright © 2018 Anshul Shah. All rights reserved.
//

import Foundation

class GetMovieDetailResponse: Codable {
    var overview: String?
    var genres: [Genre]?
    var runtime: Int?
    var releaseDate: String?
    var productionCompanies: [ProductionCompanies]?
    var spokenLanguages: [SpokenLanguages]?
    var budget: Int64?
    var revenue: Int64?
    var posterPath: String?
    var backdropPath: String?
    var tagline: String?
    var title: String?
    var id: Int?
    var responseModel: GetMovieDetailResponse?
    var moviesDetailsCoredataModel: MoviesDetailsCoredataModel?
    
    var genreString: String {
        if moviesDetailsCoredataModel != nil {
            return moviesDetailsCoredataModel!.genre
        }
        
        guard let _gerne = genres else {return ""}
        var arrString = [String]()
        for obj in _gerne{
            if obj.name != nil{
                arrString.append(obj.name ?? "")
            }
        }
        let string = arrString.joined(separator: ", ")
        return string == "" ? "--" : string
    }
    
    var productionCompneyString: String {
        if moviesDetailsCoredataModel != nil{
            return moviesDetailsCoredataModel!.productionCompney
        }
        
        guard let _productionCompanies = productionCompanies else {return ""}
        var arrString = [String]()
        for obj in _productionCompanies {
            if obj.name != nil {
                arrString.append(obj.name ?? "")
            }
        }
        return arrString.joined(separator: ", ")
    }
    
    var spokenLanguageString: String {
        if moviesDetailsCoredataModel != nil{
            return moviesDetailsCoredataModel!.spokenLanguage
        }
        
        guard let _spokenLanguages = spokenLanguages else {return ""}
        var arrString = [String]()
        for obj in _spokenLanguages {
            if obj.name != nil {
                arrString.append(obj.name ?? "")
            }
        }
        return arrString.joined(separator: ", ")
    }
    
    var duration: String {
        if moviesDetailsCoredataModel != nil{
            return moviesDetailsCoredataModel!.duration
        }
        
        if runtime ?? 0 == 0 {
            return "--"
        }
        return "\(self.runtime ?? 0) \(NSLocalizedString("Minutes", comment: ""))"
    }
    
    var imageURL : String {
        if moviesDetailsCoredataModel != nil{
            return moviesDetailsCoredataModel!.imageURL
        }
        
        if posterPath != nil {
            return IMAGE_URL + (self.posterPath ?? "")
        }
        return ""
    }
    
    var backdropPathURL : String {
        if moviesDetailsCoredataModel != nil{
            return moviesDetailsCoredataModel!.backImageURL
        }
        
        if self.backdropPath != nil {
            return BACK_IMAGE_URL + (self.backdropPath ?? "")
        }
        return ""
    }
    
    var revenueString : String {
//        if moviesDetailsCoredataModel != nil{
//            return moviesDetailsCoredataModel!.revenue
//        }
        
        let _revnue = self.revenue ?? 0
        if _revnue == 0 {
            return "--"
        }
        return (Float(_revnue).convertAsLocaleCurrency)
    }
    
    var costString : String {
//        if moviesDetailsCoredataModel != nil{
//            return moviesDetailsCoredataModel!.cost
//        }
        
        let _cost = self.budget ?? 0
        if _cost == 0 {
            return "--"
        }
        return (Float(_cost).convertAsLocaleCurrency)
    }
 
    
    init(response: [String: Any]?) {
        guard let response = response else {
            return
        }
        
        if let moviesData = try? JSONSerialization.data(withJSONObject: response.keysToCamelCase, options: []) {
            if let movieResponse = try? JSONDecoder().decode(GetMovieDetailResponse.self, from: moviesData) {
                self.responseModel = movieResponse
            }
        }
    }
    
    
    init(model: MoviesDetailsCoredataModel?) {
        guard let model = model else {return}
        self.moviesDetailsCoredataModel = model
        self.id = Int(model.id)
        self.overview = model.overview
        self.releaseDate = model.releaseDate
        self.tagline = model.tagline
        self.title = model.title
        self.budget = model.cost
        self.revenue = model.revenue
    }
    
}

class Genre: Codable {
    var name: String?
}

class ProductionCompanies: Codable {
    var name: String?
}

class SpokenLanguages: Codable {
    var name: String?
}
