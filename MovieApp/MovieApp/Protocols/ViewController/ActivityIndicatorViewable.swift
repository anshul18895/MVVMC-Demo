//
//  ActivityIndicatorViewable.swift
//  Zodiluv
//
//  Created by Anshul Shah on 1/3/18.
//  Copyright © 2018 Anshul Shah. All rights reserved.
//

import UIKit
import MBProgressHUD


protocol ActivityIndicatorViewable {
    
    func showActivityIndicator(in _containerView:UIView?) -> Void
    func hideActivityIndicator(from containerView:UIView?) -> Void
}
extension ActivityIndicatorViewable where Self: UIViewController {
    
    func showActivityIndicator(in _containerView:UIView? = nil) -> Void {
        var containerView:UIView = self.view
        
        if let _containerView = _containerView {
            containerView = _containerView
        }
        
        hideActivityIndicator(from: containerView)
        
        let hud = MBProgressHUD.showAdded(to: containerView, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.backgroundView.color = Colors.black.withAlphaComponent(0.3)
        hud.backgroundView.style = .solidColor
        hud.show(animated: true)
    }
    
    func hideActivityIndicator(from _containerView:UIView? = nil) -> Void {
        var containerView:UIView = self.view
        
        if let _containerView = _containerView {
            containerView = _containerView
        }
        
        MBProgressHUD.hideAllHUDs(for: containerView, animated: true)
    }
}











