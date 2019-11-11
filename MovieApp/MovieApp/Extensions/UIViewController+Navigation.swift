//
//  UIVieController + navigation.swift
//  MovieListDemo
//
//  Created by Anshul Shah on 11/6/18.
//  Copyright © 2018 Anshul Shah. All rights reserved.
//

import Foundation
import UIKit

private var actionKeyForLeftButton: Void?
private var actionKeyForRightButton: Void?

extension UIViewController{
    
    private var _actionLeft: (() -> ())? {
        get {
            return objc_getAssociatedObject(self, &actionKeyForLeftButton) as? () -> ()
        }
        set {
            objc_setAssociatedObject(self, &actionKeyForLeftButton, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var _actionRight: (() -> ())? {
        get {
            return objc_getAssociatedObject(self, &actionKeyForRightButton) as? () -> ()
        }
        set {
            objc_setAssociatedObject(self, &actionKeyForRightButton, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func configureNavigationWithAction(_ title:String? ,leftImage: UIImage?,actionForLeft: (() -> ())?,rightImage: UIImage?,actionForRight: (() -> ())?){
        self._actionLeft = actionForLeft
        self._actionRight = actionForRight
        navigationController?.navigationBar.barTintColor = Colors.navigaitonColor
        if title != nil{
            self.title = title!
        }
        if leftImage != nil{
            let leftButton = UIBarButtonItem(image: leftImage, style: .plain, target: self, action: #selector(leftButtonTappedwithDemo))
            leftButton.tintColor = .white
            self.navigationItem.leftBarButtonItem = leftButton
        }
        if rightImage != nil{
            let rightButton = UIBarButtonItem(image: rightImage, style: .plain, target: self, action: #selector(rightButtonTappedwithDemo))
            rightButton.tintColor = .white
            self.navigationItem.rightBarButtonItem = rightButton
        }
        
        
    }
    @objc private func leftButtonTappedwithDemo(){
        if self._actionLeft != nil{
            self._actionLeft!()
        }
    }
    @objc private func rightButtonTappedwithDemo(){
        if self._actionRight != nil{
            self._actionRight!()
        }
    }
}
