//
//  Movies + CoreData.swift
//  MovieApp
//
//  Created by Anshul Shah on 11/13/18.
//  Copyright © 2018 Anshul Shah. All rights reserved.
//

import Foundation
import CoreData
import RxDataSources
import RxCoreData


struct MoviesCoredataModel {
    var id: Int64
    var imageURL: String
    var title: String
    var overview: String
    var releaseDate: String
    
    init(movie: Movie) {
        self.id = Int64(movie.id ?? 0)
        self.imageURL = movie.imageURL
        self.title = movie.title ?? ""
        self.overview = movie.overview ?? ""
        self.releaseDate = movie.releaseDate ?? ""
    }
    
}

func == (lhs: MoviesCoredataModel, rhs: MoviesCoredataModel) -> Bool {
    return lhs.id == rhs.id
}

extension MoviesCoredataModel : Equatable { }

extension MoviesCoredataModel : IdentifiableType {
    typealias Identity = String
    
    var identity: Identity { return "\(id)" }
}

extension MoviesCoredataModel : Persistable {
    typealias T = NSManagedObject
    
    static var entityName: String {
        return "MovieList"
    }
    
    static var primaryAttributeName: String {
        return "id"
    }
    
    init(entity: T) {
        id = entity.value(forKey: "id") as! Int64
        imageURL = entity.value(forKey: "imageURL") as! String
        title = entity.value(forKey: "title") as! String
        overview = entity.value(forKey: "overview") as! String
        releaseDate = entity.value(forKey: "releaseDate") as! String
    }
    
    func update(_ entity: T) {
        entity.setValue(id, forKey: "id")
        entity.setValue(imageURL, forKey: "imageURL")
        entity.setValue(title, forKey: "title")
        entity.setValue(overview, forKey: "overview")
        entity.setValue(releaseDate, forKey: "releaseDate")
        do {
            try entity.managedObjectContext?.save()
        } catch let e {
            print(e)
        }
    }
    
}
