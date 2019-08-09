//
//  AsyncImageView.swift
//  MyContacts
//
//  Created by mmt5885 on 09/08/19.
//  Copyright © 2019 Santosh Tewari. All rights reserved.
//

import UIKit

class AsyncImageView: UIImageView {
    var imageURL:URL?
    
    private static let imageCache = NSCache<NSString, UIImage>()
    
    func load(url: URL, defaultImage: UIImage?) {
        if let cachedImage = AsyncImageView.imageCache.object(forKey: url.absoluteString as NSString) {
            self.image = cachedImage
        } else {
            self.imageURL = url
            self.image = defaultImage
            DispatchQueue.global().async { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                guard let imageURL = strongSelf.imageURL else {
                    return
                }
                
                if let data = try? Data(contentsOf: url) {
                    if imageURL == url, let image = UIImage(data: data) {
                        AsyncImageView.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                        DispatchQueue.main.async {
                            self?.image = image
                        }
                    }
                }
            }
        }
    }
}
