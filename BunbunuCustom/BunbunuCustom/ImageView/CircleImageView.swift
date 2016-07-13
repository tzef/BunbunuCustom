//
//  CircleImageView.swift
//  BunbunuCustom
//
//  Created by LEE ZHE YU on 2016/7/7.
//  Copyright © 2016年 LEE ZHE YU. All rights reserved.
//

import UIKit

@IBDesignable
class CircleImageView: UIView {
    var imgRatio: CGFloat = 1
    var imgSize = CGSizeZero
    @IBInspectable var image: UIImage? {
        didSet {
            if let w = image?.size.width, let h = image?.size.height {
                imgRatio = w / h
                imgSize = CGSize(width: w, height: h)
            }
            self.setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        var size = CGSize(width: imgSize.width, height: imgSize.height)
        var imgRect = CGRect(x: 0, y: 0, width: rect.width, height: rect.height)
        
        let rectRatio = rect.width / rect.height
        switch contentMode {
        case .ScaleAspectFill:
            if rectRatio > imgRatio {
                size = CGSize(width: rect.width, height: rect.width / imgRatio)
                imgRect = CGRect(x: 0, y: (rect.height - size.height) / 2, width: size.width, height: size.height)
            } else {
                size = CGSize(width: rect.height * imgRatio, height: rect.height)
                imgRect = CGRect(x: (rect.width - size.width) / 2, y: 0, width: size.width, height: size.height)
            }
        case .ScaleAspectFit:
            if rectRatio > imgRatio {
                size = CGSize(width: rect.height * imgRatio, height: rect.height)
                imgRect = CGRect(x: (rect.width - size.width) / 2, y: 0, width: size.width, height: size.height)
            } else {
                size = CGSize(width: rect.width, height: rect.width / imgRatio)
                imgRect = CGRect(x: 0, y: (rect.height - size.height) / 2, width: size.width, height: size.height)
            }
        default:
            break
        }
        image?.drawInRect(imgRect)
        
        let circleShapeLayer = CAShapeLayer()
        circleShapeLayer.path = UIBezierPath(ovalInRect: rect).CGPath
        self.layer.mask = circleShapeLayer
    }
    
    override var contentMode: UIViewContentMode {
        didSet {
            self.setNeedsDisplay()
        }
    }
}
