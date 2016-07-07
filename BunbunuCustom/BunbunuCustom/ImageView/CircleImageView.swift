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
    @IBInspectable var image: UIImage?
    
    override func drawRect(rect: CGRect) {
        image?.drawInRect(rect)
        
        let circleShapeLayer = CAShapeLayer()
        circleShapeLayer.path = UIBezierPath(ovalInRect: rect).CGPath
        self.layer.mask = circleShapeLayer
    }
}
