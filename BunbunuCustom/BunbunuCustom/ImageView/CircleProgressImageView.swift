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

enum ProgressStatus {
    case Normal
    case InProgress
    case Succeed
    case Failure
    case WaitEnding
}
class ProgressAngle: NSObject {
    var value: CGFloat = 0.0
}
class ProgressRadiusMargin: NSObject {
    var value: CGFloat = 5.0
}

@IBDesignable
class CircleProgressImageView: CircleImageView {
    var displayLink: CADisplayLink? = nil
    var progress = NSProgress() {
        didSet {
            if progress.completedUnitCount >= progress.totalUnitCount {
                progress.completedUnitCount = progress.totalUnitCount
            }
            self.setUpdateProgress(progress)
        }
    }
    let imageMaskView = UIView()
    let newImageView = UIImageView()
    var waitMaskAnimation = false
    
    var circleAngle = ProgressAngle()
    var circleRadiusMargin = ProgressRadiusMargin()
    var status = ProgressStatus.Normal
    
    var completion: (() -> Void)?
    var failure: (() -> Void)?
    
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
        
        imageMaskView.backgroundColor = UIColor.blackColor()
        imageMaskView.alpha = 0.0
        self.insertSubview(imageMaskView, belowSubview: newImageView)
        imageMaskView.snp_makeConstraints(closure: { (make) in
            make.edges.equalTo(self)
        })
    }
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let radius = min(rect.width / 2, rect.height / 2)
        let startAngle = CGFloat(-1 * M_PI_2)
        let circlePath = UIBezierPath(arcCenter: newImageView.center,
                                      radius: radius - circleRadiusMargin.value,
                                      startAngle: startAngle,
                                      endAngle: circleAngle.value * CGFloat(M_PI * 2) + startAngle,
                                      clockwise: true)
        circlePath.addLineToPoint(newImageView.center)
        
        let shapeMaskLayer = CAShapeLayer()
        shapeMaskLayer.path = circlePath.CGPath
        newImageView.layer.mask = shapeMaskLayer
    }
    
    override var contentMode: UIViewContentMode {
        didSet {
            self.newImageView.contentMode = contentMode
            self.setNeedsDisplay()
        }
    }
    
    // MARK : - Public
    func progressSucceed() {
        if status == .WaitEnding {
            smoothToFillCircle()
        } else {
            status = .Succeed
        }
    }
    func progressFailed() {
        status = .Failure
        progress.completedUnitCount = 0
        self.setUpdateProgress(progress)
    }
    func resetProgress() {
        circleAngle.pop_removeAnimationForKey("angle")
        circleRadiusMargin.pop_removeAnimationForKey("radiusMargin")
        
        progress.completedUnitCount = 0
        status = .Normal
        circleAngle.value = 0.0
        circleRadiusMargin.value = 5.0
        imageMaskView.alpha = 0.0
        destroyDisplayLink()
        self.setNeedsDisplay()
    }

    // MARK : - Private
    @objc private func displayLinkAction(dis: CADisplayLink) {
        self.setNeedsDisplay()
    }
    
    private func setUpdateProgress(progress: NSProgress) {
        stopAnimation()
        if displayLink == nil {
            initDisplayLink()
        }
        if status == .Normal {
            waitMaskAnimation = true
            fadeinImageMaskView()
            status = .InProgress
        }
        smoothToAngle(CGFloat(progress.fractionCompleted))
    }

    private func stopAnimation() {
        circleAngle.pop_removeAnimationForKey("angle")
    }
    private func destroyDisplayLink() {
        displayLink?.invalidate()
        displayLink = nil
        self.setNeedsDisplay()
    }
    private func initDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(CircleProgressImageView.displayLinkAction(_:)))
        displayLink?.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
    }
    private func smoothToAngle(angle: CGFloat) {
        if waitMaskAnimation == true {
            return
        }
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
            animation.toValue = angle
            animation.completionBlock = {(anim, finished) in
                if finished {
                    if angle >= 1.0 {
                        if self.status == .Succeed {
                            self.smoothToFillCircle()
                        } else {
                            self.status = .WaitEnding
                        }
                    }
                    if angle <= 0 {
                        if self.status == .Failure {
                            self.failure?()
                        }
                        self.status = .Normal
                        self.destroyDisplayLink()
                        self.fadeoutImageMaskView()
                    }
                }
            }
        }
        circleAngle.pop_addAnimation(animation, forKey: "angle")
    }
    private func smoothToFillCircle() {
        let radiusMarginProperty = POPAnimatableProperty.propertyWithName("radiusMargin") { (property) in
            property.readBlock = {(obj, values) in
                values[0] = (obj as! ProgressRadiusMargin).value
            }
            property.writeBlock = {(obj, values) in
                self.circleRadiusMargin.value = values[0]
            }
            property.threshold = 0.01
        }
        let animation = POPBasicAnimation()
        if let prop = radiusMarginProperty as? POPAnimatableProperty {
            animation.duration = 0.33
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            animation.property = prop
            animation.fromValue = circleRadiusMargin.value
            animation.toValue = 0
            animation.completionBlock = {(anim, finished) in
                if finished {
                    self.image = self.newImageView.image
                    self.destroyDisplayLink()
                    self.resetProgress()
                    self.completion?()
                    self.status = .Normal
                }
            }
        }
        circleRadiusMargin.pop_addAnimation(animation, forKey: "radiusMargin")
    }
    private func fadeinImageMaskView() {
        UIView.animateWithDuration(0.33, animations: {
            self.imageMaskView.alpha = 0.6
        }) { (finished) in
            self.waitMaskAnimation = false
            self.setUpdateProgress(self.progress)
        }
    }
    private func fadeoutImageMaskView() {
        UIView.animateWithDuration(0.33) { 
            self.imageMaskView.alpha = 0.0
        }
    }
}