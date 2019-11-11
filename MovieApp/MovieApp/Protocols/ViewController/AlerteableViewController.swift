//
//  AlerteableViewController.swift
//  Zodiluv
//
//  Created by Anshul Shah Raj on 17/12/17.
//  Copyright © 2017 Anshul Shah. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import SwiftMessages

protocol AlerteableViewController {
    
    func presentAlert(title: String?,
                      message: String?,
                      textField: AlertTextField?,
                      buttonTitle: String?,
                      cancelButtonTitle: String?,
                      alertClicked: ((AlertButtonClicked) -> Void)?)
    
}

extension AlerteableViewController where Self: UIViewController {
    
    func alert(_ info: String, theme: Theme = .info, title: String? = nil, iconImage: UIImage? = nil, iconText: String? = nil, buttonImage: UIImage? = nil, buttonTitle: String? =  nil, buttonTapHandle: ((_ button: UIButton) -> Void)? = nil) -> Void {
       
        // View setup
        let view: MessageView
        view = try! SwiftMessages.viewFromNib()
        
        var image = iconImage
        if theme == .success{
            image = #imageLiteral(resourceName: "LikedFromUser")
        }
        
        view.configureContent(title: title, body: info, iconImage: image, iconText: iconText, buttonImage: buttonImage, buttonTitle: buttonTitle, buttonTapHandler: buttonTapHandle)
        
        let iconStyle: IconStyle
        iconStyle = .default
        view.configureTheme(theme, iconStyle: iconStyle)
        view.configureDropShadow()
        
        view.button?.isHidden = true
        view.iconImageView?.isHidden = theme != .success
        view.iconLabel?.isHidden = true
        view.titleLabel?.isHidden = true
        view.bodyLabel?.isHidden = false
        
        // Config setup
        var config = SwiftMessages.defaultConfig
        config.presentationStyle = .bottom
        config.presentationContext = .window(windowLevel: UIWindow.Level.statusBar.rawValue)
        config.duration = .seconds(seconds: 2)
        config.dimMode = .gray(interactive: true)
        config.shouldAutorotate = true
        config.interactiveHide = true
        
        // Set status bar style unless using card view (since it doesn't
        // go behind the status bar).
        config.preferredStatusBarStyle = .lightContent
        
        if theme == .success{
//            view.iconImageView?.tintColor = Colors.successGreen
//            view.iconImageView?.contentMode = .center
            
            view.iconImageView?.image = #imageLiteral(resourceName: "successIcon")
            view.backgroundColor = UIColor.init(red: 34/256, green: 36/256, blue: 79/256, alpha: 1)
            let seprator = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: Screen.width, height: 2))
            seprator.backgroundColor = UIColor.init(red: 95/256, green: 98/256, blue: 172/256, alpha: 1)
            view.addSubview(seprator)
        }
        
        // Show
        SwiftMessages.show(config: config, view: view)
    }
    
    func showAlertB() -> Void {
        
    }
    
    func presentAlert(title: String? = nil,
                      message: String? = nil,
                      textField: AlertTextField? = nil,
                      buttonTitle: String? = nil,
                      cancelButtonTitle: String? = nil,
                      alertClicked: ((AlertButtonClicked) -> Void)? = nil) {
        
        let alertController = UIAlertController(title: title, message: message,
                                                preferredStyle: .alert)
        
        if let cancelButtonTitle = cancelButtonTitle {
            let dismissAction = UIAlertAction(title: cancelButtonTitle, style: .cancel) {[weak self] _ in
                alertClicked?(.Cancel)
            }
            alertController.addAction(dismissAction)
        }
        
        if let textFieldConfig = textField {
            alertController.addTextField { (textField) in
                textField.placeholder = textFieldConfig.placeholder
                textField.text = textFieldConfig.text
                
                if let buttonTitle = buttonTitle {
                    let buttonAction = UIAlertAction(title: buttonTitle, style: .default) {[weak self] _ in
                        alertClicked?(.ButtonWithText(textField.text))
                    }
                    alertController.addAction(buttonAction)
                }
            }
        } else {
            if let buttonTitle = buttonTitle {
                let buttonAction = UIAlertAction(title: buttonTitle, style: .default) { _ in
                    alertClicked?(.Button)
                }
                alertController.addAction(buttonAction)
            }
        }
        self.present(alertController, animated: true, completion: nil)
    }
}

enum AlertButtonClicked {
    case Button
    case ButtonWithText(String?)
    case Cancel
}

func == (lhs: AlertButtonClicked, rhs: AlertButtonClicked) -> Bool {
    switch (lhs, rhs) {
    case (.Button, .Button):
        return true
    case (.ButtonWithText, .ButtonWithText):
        return true
    case (.Cancel, .Cancel):
        return true
    default:
        return false
    }
}

struct AlertTextField {
    let text: String?
    let placeholder: String?
    
    init(text: String?, placeholder: String?) {
        self.text = text
        self.placeholder = placeholder
    }
}
extension UIViewController {
    func showAlertDialogueWithAction(title:String = "", withMessage message:String?, withActions actions: UIAlertAction... , withStyle style:UIAlertController.Style = .alert) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        if actions.count == 0 {
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        } else {
            for action in actions {
                alert.addAction(action)
            }
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertDialogue( title: String , message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
