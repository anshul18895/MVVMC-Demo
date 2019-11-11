//
//  BaseViewModel.swift
//  MovieApp
//
//  Created by Anshul Shah on 12/11/18.
//  Copyright © 2018 Anshul Shah. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftMessages

class BaseViewModel {
    
    // Dispose Bag
    let disposeBag = DisposeBag()
    let alert = PublishSubject<(String, Theme)>()
    let alertDialog = PublishSubject<(String,String)>()
    
}
