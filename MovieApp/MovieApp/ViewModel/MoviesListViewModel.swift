//
//  MoviesListViewModel.swift
//  MovieApp
//
//  Created by Anshul Shah on 11/12/18.
//  Copyright © 2018 Anshul Shah. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa
import CoreData

final class MoviesListViewModel: BaseViewModel {
    typealias Dependencies = HasAPI & HasCoreData
    
    // Dependencies
    private let dependencies: Dependencies
    var managedObjectContext: NSManagedObjectContext!
    
    /// Network request in progress
    let isLoading: ActivityIndicator =  ActivityIndicator()
    
    //API Result
    var getMoviesData: Observable<APIResult<GetMovieResponse>> {
        return _getMoviesData.asObservable().observeOn(MainScheduler.instance)
    }
    private let _getMoviesData = ReplaySubject<APIResult<GetMovieResponse>>.create(bufferSize: 1)
    
    //Data
    var movieTableData: Observable<[Movie]>
    var movies: Variable<[Movie]> = Variable([])
    
    //Paging Metadata
    var nextPage: Int? = 1
    var isFromCoredata: Bool = false

    //Method
    var callNextPage = PublishSubject<Void>()
    let selectedMovie = PublishSubject<Movie?>()
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        self.movieTableData = movies.asObservable()
        self.managedObjectContext = dependencies.managedObjectContext
        super.init()
        
        self.callNextPage.asObservable().subscribe(onNext: { [weak self] in
            guard let `self` = self else { return }
            // Check internet availability, call next page API if internet available
            if NetworkReachabilityManager()!.isReachable == true {
                if self.nextPage != nil {
                    self.getMovies(nextPage: self.nextPage!)
                }
            } else {
                // Fetch movie data from local cache, as internet is not available
                self.getMoviesFromCoreData()
            }
        }).disposed(by: disposeBag)
        
        getMoviesData
            .subscribe(onNext: { [weak self] (result) in
                guard let `self` = self else { return }
                switch result {
                case .success(let response):
                    if response.results != nil {
                        for movie in response.results! {
                            _ = try? self.managedObjectContext.rx.update(MoviesCoredataModel.init(movie: movie))
                        }
                        self.movies.value.append(contentsOf: response.results!)
                    }
                    self.nextPage = response.nextPage
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
        
}

//MARK:- Core Data
extension MoviesListViewModel {
    
    func getMoviesFromCoreData() {
        
        isFromCoredata = true
        managedObjectContext.rx.entities(MoviesCoredataModel.self, sortDescriptors: []).asObservable()
            .subscribe(onNext: { [weak self] movieModels in
                guard let `self` = self else {return}
                
                // Check local cache record count and binded array count same, no need to execute further code
                if self.movies.value.count == movieModels.count {
                    return
                }
                
                var movies = [Movie]()
                for movie in movieModels {
                    let movieModel = Movie.init(model: movie)
                    // Check movie object is contains in main array which bind to tableview, ignore that object
                    if self.movies.value.contains(where: { $0.id == movieModel.id }) == false {
                        movies.append(Movie.init(model: movie))
                    }
                }
                
                self.movies.value.append(contentsOf: movies)
                self.nextPage = (self.movies.value.count/20)+1
            }).disposed(by: disposeBag)
    }
    
}

//MARK:- API Call
extension MoviesListViewModel {
    
    func getMovies(nextPage: Int = 1) {
        let parameter = [
            Params.apiKey.rawValue : Environment.MOVIEDB_APIKEY(),
            Params.page.rawValue   : nextPage
            ] as [String : Any]
        
        dependencies.api.getMovieList(param: parameter)
            .trackActivity(nextPage == 1 ? isLoading : ActivityIndicator())
            .observeOn(SerialDispatchQueueScheduler(qos: .default))
            .subscribe {[weak self] (event) in
                guard let `self` = self else { return }
                switch event {
                case .next(let result):
                    switch result {
                    case .success:
                        self._getMoviesData.on(event)
                    case .failure(let error):
                        // Fetch data from local cache when internet is not available
                        if error.code == InternetConnectionErrorCode.offline.rawValue {
                            self.getMoviesFromCoreData()
                            self.alertDialog.onNext((NSLocalizedString("Network error", comment: ""), error.message))
                        } else {
                            self.alertDialog.onNext(("Error", error.message))
                        }
                    }
                    
                default:
                    break
                }
            }.disposed(by: disposeBag)
    }
    
}
