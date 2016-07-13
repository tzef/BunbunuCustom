//
//  CirclePregressDemoView.swift
//  BunbunuCustom
//
//  Created by LEE ZHE YU on 2016/7/7.
//  Copyright © 2016年 LEE ZHE YU. All rights reserved.
//

import UIKit

class CirclePregressDemoView: UIView {
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var demoCircleProgressImageView: CircleProgressImageView!

    let progress = NSProgress(totalUnitCount: 100)
    
    override func awakeFromNib() {
        demoCircleProgressImageView.completion = {
            let alertVC = UIAlertController(title: "INFO", message: "SUCCEED", preferredStyle: UIAlertControllerStyle.Alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(500 * NSEC_PER_MSEC)), dispatch_get_main_queue(), {
                UIViewController.currentViewController().presentViewController(alertVC, animated: true, completion: nil)
            })
        }
        demoCircleProgressImageView.failure = {
            let alertVC = UIAlertController(title: "INFO", message: "FAILED", preferredStyle: UIAlertControllerStyle.Alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(500 * NSEC_PER_MSEC)), dispatch_get_main_queue(), {
                UIViewController.currentViewController().presentViewController(alertVC, animated: true, completion: nil)
            })
        }
    }
    @IBAction func succeedAction(sender: AnyObject) {
        statusLabel.text = "Succeed"
        demoCircleProgressImageView.progressSucceed()
    }
    @IBAction func failedAction(sender: AnyObject) {
        statusLabel.text = "Failed"
        progress.completedUnitCount = 0
        progressLabel.text = "\(progress.completedUnitCount)"
        demoCircleProgressImageView.progressFailed()
    }
    @IBAction func resetAction(sender: AnyObject) {
        demoCircleProgressImageView.image = UIImage(named: "app_icon_60")
        statusLabel.text = "Normal"
        progress.completedUnitCount = 0
        progressLabel.text = "\(progress.completedUnitCount)"
        demoCircleProgressImageView.resetProgress()
    }
    @IBAction func startAction(sender: AnyObject) {
        if statusLabel.text != "Succeed" {
            statusLabel.text = "InProgress"
        }
        progress.completedUnitCount += 33
        if progress.completedUnitCount > 100 {
            progress.completedUnitCount = 100
        }
        progressLabel.text = "\(progress.completedUnitCount)"
        demoCircleProgressImageView.progress = progress
    }
}
