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
    @IBOutlet weak var demoCircleProgressImageView: CircleProgressImageView!

    let progress = NSProgress(totalUnitCount: 100)
    
    @IBAction func failedAction(sender: AnyObject) {
        progressLabel.text = "000"
        demoCircleProgressImageView.progressFailed()
    }
    @IBAction func resetAction(sender: AnyObject) {
        progress.completedUnitCount = 0
        progressLabel.text = "\(progress.completedUnitCount)"
        demoCircleProgressImageView.progress = progress
    }
    @IBAction func startAction(sender: AnyObject) {
        progress.completedUnitCount += 33
        if progress.completedUnitCount > 100 {
            progress.completedUnitCount = 100
        }
        progressLabel.text = "\(progress.completedUnitCount)"
        demoCircleProgressImageView.progress = progress
    }
}
