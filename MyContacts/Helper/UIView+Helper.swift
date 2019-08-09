//
//  UIView+Helper.swift
//  MyContacts
//
//  Created by mmt5885 on 10/08/19.
//  Copyright © 2019 Santosh Tewari. All rights reserved.
//

import UIKit

extension UIView {
    func showDefaultShadow(opacity: Float = 0.2) {
        self.layer.masksToBounds = false
        // shadow
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = 2.0
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }

    func addGradientColor(withColors colors:[UIColor], withStartPoint startPoint:CGPoint, withEndPoint endPoint:CGPoint){
        let gradient = CAGradientLayer()
        gradient.name = Constant.GRADIENT_LAYER_NAME
        gradient.frame = self.bounds
        
        var gradientColors = [CGColor]()
        for color in colors{
            gradientColors.append(color.cgColor)
        }
        
        gradient.colors = gradientColors
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        gradient.name = Constant.GRADIENT_LAYER_NAME
        
        removeGradientLayer()
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func removeGradientLayer(){
        removeLayer(name:Constant.GRADIENT_LAYER_NAME)
    }
    
    func removeLayer(name: String) {
        let allLayers = self.layer.sublayers ?? []
        for layer in allLayers {
            if layer.name == name {
                layer.removeFromSuperlayer()
            }
        }
    }
}
