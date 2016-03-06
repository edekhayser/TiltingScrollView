//
//  TiltingScrollView.swift
//  TiltingScrollView
//
//  Created by Evan Dekhayser on 3/6/16.
//  Copyright © 2016 Evan Dekhayser. All rights reserved.
//

import UIKit
import CoreMotion

public class TiltingScrollView: UIScrollView {

    public var tiltingFactor: CGFloat = 20
    
    private var motionManager = CMMotionManager()
    
    private var initialAcceleration: Double!
    
    public func calibrate(){
        if UIInterfaceOrientationIsPortrait(UIApplication.sharedApplication().statusBarOrientation){
            initialAcceleration = motionManager.accelerometerData!.acceleration.y
        } else {
            initialAcceleration = motionManager.accelerometerData!.acceleration.x
        }
    }

    public func beginTiltToScroll(){
        guard motionManager.accelerometerAvailable else {
            print("TiltingScrollView: Accelerometer is not available on this device.")
            return
        }
        scrollEnabled = false
        motionManager.accelerometerUpdateInterval = 0.001
        motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue()) { (data, error) in
            guard let data = data else { return }
            
            if self.initialAcceleration == nil{
                self.calibrate()
            }
            
            let yAcceleration: Double
            if UIInterfaceOrientationIsPortrait(UIApplication.sharedApplication().statusBarOrientation){
                yAcceleration = self.initialAcceleration - data.acceleration.y
            } else {
                yAcceleration = self.initialAcceleration - data.acceleration.x
            }
            
            let yOffset = self.tiltingFactor * CGFloat(yAcceleration)
            self.contentOffset = CGPoint(x: self.frame.origin.x, y: max(min(self.contentOffset.y - yOffset, self.contentSize.height - self.frame.size.height), 0))
        }
    }
    
    public func setTiltingEnabled(tiltingEnabled: Bool){
        if tiltingEnabled{
            if !motionManager.accelerometerActive{
                calibrate()
                beginTiltToScroll()
            }
            scrollEnabled = false
        } else {
            motionManager.stopAccelerometerUpdates()
            scrollEnabled = true
        }
    }
    
}
