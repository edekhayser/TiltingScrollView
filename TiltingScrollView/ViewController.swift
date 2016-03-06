//
//  ViewController.swift
//  TiltingScrollView
//
//  Created by Evan Dekhayser on 3/6/16.
//  Copyright © 2016 Evan Dekhayser. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var scrollView: TiltingScrollView!
    @IBOutlet weak var calibrateButton: UIButton!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.beginTiltToScroll()
    }

    @IBAction func calibrate(sender: UIButton) {
        scrollView.calibrate()
        
        calibrateButton.setTitle("Calibrated 🎉", forState: .Normal)
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.calibrateButton.setTitle("Calibrate", forState: .Normal)
        }
    }
}

