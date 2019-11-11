//
//  MovieDetailsViewController.swift
//  MovieApp
//
//  Created by Anshul Shah on 11/13/18.
//  Copyright © 2018 Anshul Shah. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MovieDetailsViewController: BaseViewController {

    var viewModel: MovieDetailViewModel!
    
    @IBOutlet weak var tblMovieDetails: UITableView!
    @IBOutlet weak var lblMovieTitle: UILabel!
    @IBOutlet weak var lblTagline: UILabel!
    @IBOutlet weak var imvMovieBackground: UIImageView!
    @IBOutlet weak var imvPoster: UIImageView!
    
    struct TableData {
        var title: String?
        var description: String?
    }
    
    //MARK:- View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.viewModel.getMovieDetails()
        // Do any additional setup after loading the view.
    }

    // MARK: - Memory Management Methods
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


//MARK: - Setup Methods
extension MovieDetailsViewController {

    private func setup() {
        self.setupUI()
        self.setupBinding(with: self.viewModel)
    }
    
    private func setupUI() {
        self.tblMovieDetails.isHidden = true
        self.tblMovieDetails.tableFooterView = UIView()
        self.configureNavigationWithAction("", leftImage: #imageLiteral(resourceName: "backArrow"), actionForLeft: { [weak self] in
            guard let `self` = self else {return}
            self.viewModel.popToMovieList.onNext(())
            }, rightImage: nil, actionForRight: nil)
    }
    
    private func setupBinding(with viewModel: MovieDetailViewModel) {
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
        
        viewModel.movieDetailResponse.subscribe(onNext: { [weak self] model in
            guard let `self` = self else { return }
            guard let _model = model else { return }
            self.imvPoster.downloadImageWithCaching(with: _model.imageURL,placeholderImage: #imageLiteral(resourceName: "placeholder-image"))
            self.imvMovieBackground.downloadImageWithCaching(with: _model.backdropPathURL,placeholderImage: #imageLiteral(resourceName: "placeholder-image"))
            
            self.lblTagline.text = _model.tagline ?? ""
            self.lblMovieTitle.text = _model.title ?? ""
            self.title = _model.title ?? ""
            self.tblMovieDetails.isHidden = false
            
            // Bind data to model object and load in tableview
            var tableData = [TableData]()
            tableData.append(TableData.init(title: Strings.overview.rawValue, description: _model.overview ?? "--"))
            tableData.append(TableData.init(title: Strings.genres.rawValue, description: _model.genreString))
            tableData.append(TableData.init(title: Strings.duration.rawValue, description: _model.duration))
            tableData.append(TableData.init(title: Strings.releaseDate.rawValue, description: _model.releaseDate ?? "--"))
            tableData.append(TableData.init(title: Strings.prodCompanies.rawValue, description: _model.productionCompneyString))
            tableData.append(TableData.init(title: Strings.prodBudget.rawValue, description: _model.costString))
            tableData.append(TableData.init(title: Strings.revenue.rawValue, description: _model.revenueString))
            tableData.append(TableData.init(title: Strings.languages.rawValue, description: _model.spokenLanguageString))
            
            viewModel.tableData.accept(tableData)
        }).disposed(by: disposeBag)
        
        self.viewModel.tableData.asObservable()
            .bind(to: tblMovieDetails.rx.items(cellIdentifier: String(describing: MovieDetailCell.self), cellType: MovieDetailCell.self)) { row, element, cell in
                cell.configure(tableData: element)
            }
            .disposed(by: disposeBag)
        
        viewModel.alertDialog.observeOn(MainScheduler.instance)
            .subscribe(onNext: {[weak self] (title, message) in
                guard let `self` = self else {return}
                let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
                    self.viewModel.popToMovieList.onNext(())
                }
                self.showAlertDialogueWithAction(title: title, withMessage: message, withActions: okAction)
                
            }).disposed(by: disposeBag)
    }
    
}

//MARK: - Movie Details Cell
class MovieDetailCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    func configure(tableData: MovieDetailsViewController.TableData) {
        self.lblTitle.text = tableData.title ?? ""
        self.lblDescription.text = tableData.description ?? ""
    }
    
}
