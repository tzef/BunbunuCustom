//
//  CircleProgressImageView.swift
//  BunbunuCustom
//
//  Created by LEE ZHE YU on 2016/7/7.
//  Copyright © 2016年 LEE ZHE YU. All rights reserved.
//

import UIKit
import SnapKit

@IBDesignable
class CircleProgressImageView: CircleImageView {
    let newImageView = UIImageView()
    var progress = NSProgress()
    
    @IBInspectable var newImage: UIImage? {
        didSet {
            newImageView.image = newImage
        }
    }
    
    override func awakeFromNib() {
        self.addSubview(newImageView)
        newImageView.snp_makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    func setUpdateProgress(progress: NSProgress) {
        self.progress = progress
        self.setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let maxRadius = max(rect.width / 2, rect.height / 2)
        let startAngle = CGFloat(-1 * M_PI_2)
        let endAngle = CGFloat((Double(progress.completedUnitCount) / Double(progress.totalUnitCount)) * M_PI * 2)
        let path = UIBezierPath(arcCenter: newImageView.center,
                                radius: maxRadius,
                                startAngle: startAngle,
                                endAngle: endAngle + startAngle,
                                clockwise: true)
        path.addLineToPoint(newImageView.center)

        let context = UIGraphicsGetCurrentContext()
        CGContextAddPath(context, path.CGPath)
        UIColor.greenColor().setFill()
        CGContextFillPath(context)
        let shapeMaskLayer = CAShapeLayer()
        shapeMaskLayer.path = path.CGPath
        newImageView.layer.mask = shapeMaskLayer
    }
}
