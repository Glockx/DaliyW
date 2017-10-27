//
//  DRGradientProgressView.swift
//  DaliyW
//
//  Created by Nijat Muzaffarli on 10/27/17.
//  Copyright © 2017 Mammademin Muzaffarli. All rights reserved.
//

import Foundation
import UIKit

class DRGradientProgressView: UIView,CAAnimationDelegate {
    
    var progress:CGFloat
    
    var proglayer: CAGradientLayer
    
    override init(frame: CGRect) {
        progress = 1.0
        proglayer = CAGradientLayer()
        
        super.init(frame: frame)
        
        self.layer.addSublayer(shadowAsInverse())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func shadowAsInverse() -> CAGradientLayer {
        let newShadowFrame = CGRect(x: 0, y: 0, width: 0, height: self.bounds.height)
        
        proglayer.frame = newShadowFrame
        
        proglayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        proglayer.endPoint   = CGPoint(x: 1.0, y: 0.5)
       
        let colors = NSMutableArray()
        var hue = 0
        for _ in 0...370 {
            if hue > 370 {
                break
            }
            let color:UIColor
            color = UIColor(hue: 1.0 * CGFloat(hue) / 360.0, saturation: 1, brightness: 1.0, alpha: 0.8)
            colors.add(color.cgColor)
            hue += 5
        }
        
        proglayer.colors = colors as [AnyObject]
        
        
        let colorArray = NSMutableArray(array: proglayer.colors!)
        let lastColor = colorArray.lastObject!
        colorArray.removeLastObject()
        colorArray.insert(lastColor, at: 0)
        let shiftedColors = NSArray(array: colorArray)
        proglayer.colors = shiftedColors as [AnyObject]
        let animation = CABasicAnimation(keyPath: "zxq_colors")
        animation.toValue = shiftedColors
        animation.duration = 0.02
        animation.fillMode = kCAFillModeForwards
        animation.delegate = self
        proglayer.add(animation, forKey: "zxq_animateGradient")
        
        return proglayer;
    }
}



extension DRGradientProgressView {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        let newShadowFrame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        proglayer.frame = newShadowFrame
        
        let colorArray = NSMutableArray(array: proglayer.colors!)
        let lastColor = colorArray.lastObject!
        colorArray.removeLastObject()
        colorArray.insert(lastColor, at: 0)
        let shiftedColors = NSArray(array: colorArray)
        proglayer.colors = shiftedColors as [AnyObject]
        
        let animation = CABasicAnimation(keyPath: "zxq_colors")
        animation.toValue = shiftedColors
        animation.duration = 0.02
        animation.fillMode = kCAFillModeForwards
        animation.delegate = self
        proglayer.add(animation, forKey: "zxq_animateGradient")
        
        
        let maskLayer = CALayer()
        maskLayer.frame = CGRect(x: 0.0, y: 0.0, width: 0.0, height: self.bounds.height)
        maskLayer.backgroundColor = UIColor.black.cgColor
        proglayer.mask = maskLayer
        
        var maskRect = maskLayer.frame
        maskRect.size.width = self.bounds.width * progress
        maskLayer.frame = maskRect
        
    }
    
}
