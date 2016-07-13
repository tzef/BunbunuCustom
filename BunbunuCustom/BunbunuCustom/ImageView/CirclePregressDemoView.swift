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
            print("Succeed")
        }
        demoCircleProgressImageView.failure = {
            print("Failure")
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
