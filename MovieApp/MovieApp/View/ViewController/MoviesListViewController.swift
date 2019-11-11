//
//  MoviesListViewController.swift
//  MovieApp
//
//  Created by Anshul Shah on 11/12/18.
//  Copyright © 2018 Anshul Shah. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MoviesListViewController: BaseViewController {

    var viewModel :MoviesListViewModel!
    @IBOutlet weak var tblMovies :UITableView!
    

    //MARK:- View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.viewModel.getMovies()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Memory Management Methods

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK: - Setup Methods
extension MoviesListViewController {
    
    private func setup(){
        self.setupUI()
        self.setupBinding(with: self.viewModel)
    }
    
    private func setupUI() {
        self.configureNavigationWithAction(NSLocalizedString("Movie List", comment: ""), leftImage: nil, actionForLeft: nil, rightImage: nil, actionForRight: nil)
        self.tblMovies.tableFooterView = UIView()
    }
    
    private func setupBinding(with viewModel: MoviesListViewModel){
        
        self.viewModel.movieTableData.asObservable()
            .bind(to: tblMovies.rx.items(cellIdentifier: String(describing: MovieTableViewCell.self), cellType: MovieTableViewCell.self)) { row, element, cell in
                cell.configure(with: element)
            }
            .disposed(by: disposeBag)
        
        tblMovies.rx
            .willDisplayCell
            .filter({[weak self] (cell, indexPath) in
                guard let `self` = self else { return false }
                return (indexPath.row + 1) == self.tblMovies.numberOfRows(inSection: indexPath.section) - 3
            })
            .throttle(1.0, scheduler: MainScheduler.instance)
            .map({ event -> Void in
                return Void()
            })
            .bind(to: viewModel.callNextPage)
            .disposed(by: disposeBag)
        
        self.tblMovies
            .rx
            .modelSelected(Movie.self)
            .bind(to: viewModel.selectedMovie)
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .distinctUntilChanged()
            .drive(onNext: { [weak self] (isLoading) in
                guard let `self` = self else { return }
                self.hideActivityIndicator()
                if isLoading {
                    self.showActivityIndicator()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.alertDialog.observeOn(MainScheduler.instance)
            .subscribe(onNext: {[weak self] (title, message) in
                guard let `self` = self else {return}
                self.showAlertDialogue(title: title, message: message)
            }).disposed(by: disposeBag)
    }
    
}

//MARK: - Movie Tableview Cell
class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imvMovie: UIImageView!
    @IBOutlet weak var lblMovieTitle: UILabel!
    @IBOutlet weak var lblMovieReleaseDate: UILabel!
    @IBOutlet weak var lblMovieDescription: UILabel!
    
    func configure(with movie: Movie){
        self.imvMovie.downloadImageWithCaching(with: movie.imageURL,placeholderImage: #imageLiteral(resourceName: "placeholder-image"))
        self.lblMovieTitle.text = movie.title ?? ""
        self.lblMovieDescription.text = movie.overview ?? ""
        self.lblMovieReleaseDate.text = movie.releaseDate ?? ""
    }
    
}
