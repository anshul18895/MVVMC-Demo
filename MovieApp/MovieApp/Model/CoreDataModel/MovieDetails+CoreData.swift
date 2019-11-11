//
//  MovieDetails + CoreData.swift
//  MovieApp
//
//  Created by Anshul Shah on 11/13/18.
//  Copyright © 2018 Anshul Shah. All rights reserved.
//

import Foundation
import CoreData
import RxDataSources
import RxCoreData


struct MoviesDetailsCoredataModel: Codable {
    var backImageURL: String
    var cost: Int64?
    var duration: String
    var genre: String
    var id: Int64
    var imageURL: String
    var overview: String
    var releaseDate: String
    var revenue: Int64?
    var tagline: String
    var title: String
    var productionCompney: String
    var spokenLanguage: String
    
    init(movie: GetMovieDetailResponse){
        self.backImageURL = movie.backdropPathURL
        self.cost = movie.budget
        self.duration = movie.duration
        self.genre = movie.genreString
        self.id = Int64(movie.id ?? 0)
        self.imageURL = movie.imageURL
        self.overview = movie.overview ?? ""
        self.releaseDate = movie.releaseDate ?? ""
        self.revenue = movie.revenue
        self.tagline = movie.tagline ?? ""
        self.title = movie.title ?? ""
        self.productionCompney = movie.productionCompneyString
        self.spokenLanguage = movie.spokenLanguageString
    }
    
}

func == (lhs: MoviesDetailsCoredataModel, rhs: MoviesDetailsCoredataModel) -> Bool {
    return lhs.id == rhs.id
}

extension MoviesDetailsCoredataModel : Equatable { }

extension MoviesDetailsCoredataModel : IdentifiableType {
    typealias Identity = String
    
    var identity: Identity { return "\(id)" }
}

extension MoviesDetailsCoredataModel : Persistable {
    typealias T = NSManagedObject
    
    static var entityName: String {
        return "MoviesDetails"
    }
    
    static var primaryAttributeName: String {
        return "id"
    }
    
    init(entity: T) {

        id = entity.value(forKey: "id") as! Int64
        backImageURL = entity.value(forKey: "backImageURL") as! String
        cost = entity.value(forKey: "cost") as? Int64
        duration = entity.value(forKey: "duration") as! String
        genre = entity.value(forKey: "genre") as! String
        imageURL = entity.value(forKey: "imageURL") as! String
        overview = entity.value(forKey: "overview") as! String
        releaseDate = entity.value(forKey: "releaseDate") as! String
        revenue = entity.value(forKey: "revenue") as? Int64
        tagline = entity.value(forKey: "tagline") as! String
        title = entity.value(forKey: "title") as! String
        productionCompney = entity.value(forKey: "productionCompney") as! String
        spokenLanguage = entity.value(forKey: "spokenLanguage") as! String
    }
    
    func update(_ entity: T) {
        entity.setValue(id, forKey: "id")
        entity.setValue(backImageURL, forKey: "backImageURL")
        entity.setValue(cost, forKey: "cost")
        entity.setValue(duration, forKey: "duration")
        entity.setValue(genre, forKey: "genre")
        entity.setValue(imageURL, forKey: "imageURL")
        entity.setValue(overview, forKey: "overview")
        entity.setValue(releaseDate, forKey: "releaseDate")
        entity.setValue(revenue, forKey: "revenue")
        entity.setValue(tagline, forKey: "tagline")
        entity.setValue(title, forKey: "title")
        entity.setValue(productionCompney, forKey: "productionCompney")
        entity.setValue(spokenLanguage, forKey: "spokenLanguage")
        
        do {
            try entity.managedObjectContext?.save()
        } catch let e {
            print(e)
        }
    }
    
}
