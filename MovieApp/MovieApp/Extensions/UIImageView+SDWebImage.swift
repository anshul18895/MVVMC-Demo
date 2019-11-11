//
//  UIImageView+SDWebImage.swift
//  MovieApp
//
//  Created by Anshul Shah on 11/13/18.
//  Copyright © 2018 Anshul Shah. All rights reserved.
//

import Foundation
import Kingfisher


extension UIImageView {
    
    public func downloadImageWithCaching(with url: String,placeholderImage: UIImage? = nil){
        if url == ""{
            self.image = placeholderImage
            return
        }
        guard let imageURL = URL.init(string: url) else{
            self.image = placeholderImage
            return
        }
        self.kf.setImage(with: imageURL, placeholder: placeholderImage, options: [.transition(.fade(0.1))], progressBlock: nil, completionHandler: { (image, error, cacheType, _url) in
            //self.image = image
        })
    }
    
}
