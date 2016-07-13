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
    case Complete
}
class ProgressAngle: NSObject {
    var value: CGFloat = 0.0
}
class ProgressRadiusMargin: NSObject {
    var value: CGFloat = 0.0
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
    
    var circleAngle = ProgressAngle()
    var circleRadiusMargin = ProgressRadiusMargin()
    var status = ProgressStatus.Normal
    
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
    
    // MARK : - Public
    func progressFailed() {
        progress.completedUnitCount = 0
        self.setUpdateProgress(progress)
    }
    func resetProgress() {
        progress.completedUnitCount = 0
        status = .Normal
        circleAngle.value = 0.0
        imageMaskView.alpha = 0.0
        self.setNeedsDisplay()
    }

    // MARK : - Private
    @objc private func displayLinkAction(dis: CADisplayLink) {
        self.setNeedsDisplay()
    }
    
    private func setUpdateProgress(progress: NSProgress) {
        stopAnimation()
        initDisplayLinkAndShowImageMask()
        status = .InProgress
        smoothToAngle(CGFloat(progress.fractionCompleted))
    }

    private func stopAnimation() {
        circleAngle.pop_removeAnimationForKey("angle")
        displayLink?.invalidate()
        displayLink = nil
    }
    private func initDisplayLinkAndShowImageMask() {
        displayLink = CADisplayLink(target: self, selector: #selector(CircleProgressImageView.displayLinkAction(_:)))
        displayLink?.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
        if status == .Normal {
            circleRadiusMargin.value = 5
            fadeinImageMaskView()
        }
    }
    private func smoothToAngle(angle: CGFloat) {
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
                    self.setNeedsDisplay()
                    if self.progress.completedUnitCount >= self.progress.totalUnitCount {
                        self.status = .Complete
                    }
                    if self.progress.completedUnitCount == 0 {
                        self.status = .Normal
                    }
                    self.stateAnimation()
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
                    self.setNeedsDisplay()
                    self.stopAnimation()
                    self.resetProgress()
                    self.image = self.newImageView.image
                }
            }
        }
        circleRadiusMargin.pop_addAnimation(animation, forKey: "radiusMargin")
    }
    private func fadeinImageMaskView() {
        UIView.animateWithDuration(0.33) {
            self.imageMaskView.alpha = 0.6
        }
    }
    private func fadeoutImageMaskView() {
        UIView.animateWithDuration(0.33) { 
            self.imageMaskView.alpha = 0.0
        }
    }
    private func stateAnimation() {
        switch self.status {
        case .Complete:
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(111 * NSEC_PER_MSEC)), dispatch_get_main_queue(), {
                self.smoothToFillCircle()
            })
        case .Normal:
            self.stopAnimation()
            self.fadeoutImageMaskView()
        default:
            break
        }
    }
    private func installNewImage() {
        
    }
}
