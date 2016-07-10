//
//  CirclePregressDemoView.swift
//  BunbunuCustom
//
//  Created by LEE ZHE YU on 2016/7/7.
//  Copyright © 2016年 LEE ZHE YU. All rights reserved.
//

import UIKit

class CirclePregressDemoView: UIView {
    @IBOutlet weak var demoCircleProgressImageView: CircleProgressImageView!

    var timer = NSTimer()
    let progress = NSProgress(totalUnitCount: 100)
    
    @IBAction func startAction(sender: AnyObject) {
        timer.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(CirclePregressDemoView.timerAction(_:)), userInfo: ["delta" : 0], repeats: true)
    }

    func timerAction(timer: NSTimer) {
        progress.completedUnitCount += 5
        demoCircleProgressImageView.setUpdateProgress(progress)
        if progress.completedUnitCount == progress.totalUnitCount {
            timer.invalidate()
        }
    }
}
