//
//  MovieDetailViewModel.swift
//  MovieApp
//
//  Created by Anshul Shah on 11/13/18.
//  Copyright © 2018 Anshul Shah. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa
import CoreData

final class MovieDetailViewModel: BaseViewModel {
    typealias Dependencies = HasAPI & HasCoreData

    // Dependencies
    private let dependencies: Dependencies
    var managedObjectContext: NSManagedObjectContext!
    
    /// Network request in progress
    let isLoading: ActivityIndicator =  ActivityIndicator()
    
    //API Result
    var getMoviesDetailData: Observable<APIResult<GetMovieDetailResponse>> {
        return _getMoviesDetailData.asObservable().observeOn(MainScheduler.instance)
    }
    private let _getMoviesDetailData = ReplaySubject<APIResult<GetMovieDetailResponse>>.create(bufferSize: 1)
    
    //Data
    var selectedMovie: Movie?
    var movieDetailResponse:  BehaviorRelay<GetMovieDetailResponse?> = BehaviorRelay<GetMovieDetailResponse?>(value: nil)
    var tableData:  BehaviorRelay<[MovieDetailsViewController.TableData]>  = BehaviorRelay<[MovieDetailsViewController.TableData]>(value: [])
    
    //Custom method
    var popToMovieList = PublishSubject<Void>()
    
    init(dependencies: Dependencies,movie: Movie){
        self.dependencies = dependencies
        self.selectedMovie = movie
        self.managedObjectContext = dependencies.managedObjectContext
        super.init()
        
        getMoviesDetailData
            .subscribe(onNext: { [weak self] (result) in
                guard let `self` = self else { return }
                switch result {
                case .success(let response):
                    self.movieDetailResponse.accept(response.responseModel)
                    if response.responseModel != nil{
                        _ = try? self.managedObjectContext.rx.update(MoviesDetailsCoredataModel.init(movie: response.responseModel!))
                    }
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
    
}

//MARK:- Core Data
extension MovieDetailViewModel {
    
    func getMovieDetailsFromCoreData(errorMessage :String) {
        let predicate = NSPredicate(format: "id == \(self.selectedMovie?.id ?? -120)")
        managedObjectContext.rx.entities(MoviesDetailsCoredataModel.self, predicate: predicate, sortDescriptors: [])
            .subscribe(onNext: { [weak self] movieModels in
                guard let `self` = self else {return}
                if movieModels.count > 0 {
                    self.movieDetailResponse.accept(GetMovieDetailResponse.init(model: movieModels.first))
                } else {
                    // Show network error only if data isn't stored in locally
                    self.alertDialog.onNext((NSLocalizedString("Network error", comment: ""), errorMessage))
                }
            }).disposed(by: disposeBag)
    }
    
}

//MARK:- API Call
extension MovieDetailViewModel {
    
    func getMovieDetails() {
        let parameter = [
            Params.apiKey.rawValue : Environment.MOVIEDB_APIKEY(),
            ] as [String : Any]
        
        dependencies.api.getMovieDetails(id: "\(self.selectedMovie?.id ?? 0)", param: parameter)
            .trackActivity(isLoading)
            .observeOn(SerialDispatchQueueScheduler(qos: .default))
            .subscribe {[weak self] (event) in
                guard let `self` = self else { return }
                switch event {
                case .next(let result):
                    switch result {
                    case .success:
                        self._getMoviesDetailData.on(event)
                    case .failure(let error):
                        if error.code == InternetConnectionErrorCode.offline.rawValue {
                            self.getMovieDetailsFromCoreData(errorMessage: error.message)
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
