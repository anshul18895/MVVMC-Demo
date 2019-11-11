//
//  UIStoryboard+Controllers.swift
//  MovieApp
//
//  Created by Anshul Shah on 12/11/18.
//  Copyright © 2018 Anshul Shah. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {

    static var main: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }

}


extension UIStoryboard {
    
    var moviesListViewController: MoviesListViewController {
        guard let viewController = instantiateViewController(withIdentifier: String(describing: MoviesListViewController.self)) as? MoviesListViewController else {
            fatalError(String(describing: MoviesListViewController.self) + "\(NSLocalizedString("couldn't be found in Storyboard file", comment: ""))")
        }
        return viewController
    }
    
    var movieDetailsViewController: MovieDetailsViewController {
        guard let viewController = instantiateViewController(withIdentifier: String(describing: MovieDetailsViewController.self)) as? MovieDetailsViewController else {
            fatalError(String(describing: MovieDetailsViewController.self) + "\(NSLocalizedString("couldn't be found in Storyboard file", comment: ""))")
        }
        return viewController
    }
    
}
