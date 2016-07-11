//
//  CircleProgressImageView.swift
//  BunbunuCustom
//
//  Created by LEE ZHE YU on 2016/7/7.
//  Copyright © 2016年 LEE ZHE YU. All rights reserved.
//

import UIKit
import SnapKit
import pop

class ProgressAngle: NSObject {
    var value: CGFloat = 0.0
}

@IBDesignable
class CircleProgressImageView: CircleImageView {
    var displayLink: CADisplayLink? = nil
    let newImageView = UIImageView()
    var circleAngle = ProgressAngle()
    
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
        circleAngle.pop_removeAnimationForKey("angle")
        if progress.completedUnitCount >= progress.totalUnitCount {
            progress.completedUnitCount = progress.totalUnitCount
        }
        
        displayLink?.invalidate()
        displayLink = nil
        displayLink = CADisplayLink(target: self, selector: #selector(CircleProgressImageView.displayLinkAction(_:)))
        displayLink?.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
        
        let angleProperty = POPAnimatableProperty.propertyWithName("angle") { (property) in
            property.readBlock = {(obj, values) in
                values[0] = (obj as! ProgressAngle).value
            }
            property.writeBlock = {(obj, values) in
                self.circleAngle.value = values[0]
            }
            property.threshold = 0.01

        }
        let animation = POPBasicAnimation()
        if let prop = angleProperty as? POPAnimatableProperty {
            animation.duration = 0.33
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            animation.property = prop
            animation.fromValue = circleAngle.value
            animation.toValue = Double(progress.completedUnitCount) / Double(progress.totalUnitCount)
            animation.completionBlock = {(anim, finished) in
                if finished {
                    self.setNeedsDisplay()
                    self.displayLink?.invalidate()
                    self.displayLink = nil
                }
            }
        }
        
        circleAngle.pop_addAnimation(animation, forKey: "angle")
    }

    func displayLinkAction(dis: CADisplayLink) {
        self.setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let maxRadius = max(rect.width / 2, rect.height / 2)
        let startAngle = CGFloat(-1 * M_PI_2)
        let circlePath = UIBezierPath(arcCenter: newImageView.center,
                                radius: maxRadius,
                                startAngle: startAngle,
                                endAngle: circleAngle.value * CGFloat(M_PI * 2) + startAngle,
                                clockwise: true)
        circlePath.addLineToPoint(newImageView.center)

        let shapeMaskLayer = CAShapeLayer()
        shapeMaskLayer.path = circlePath.CGPath
        
        newImageView.layer.mask = shapeMaskLayer
    }
}
