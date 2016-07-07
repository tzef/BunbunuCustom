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

    let progress = NSProgress(totalUnitCount: 100)
    
    @IBAction func startAction(sender: AnyObject) {
        
        progress.completedUnitCount += 1
        demoCircleProgressImageView.setUpdateProgress(progress)
    }
}
