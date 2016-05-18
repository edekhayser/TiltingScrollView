//
//  TiltingScrollView.swift
//  TiltingScrollView
//
//  Created by Evan Dekhayser on 3/6/16.
//  Copyright © 2016 Evan Dekhayser. All rights reserved.
//

import UIKit
import CoreMotion

public extension UIScrollView {

	private struct AssociatedKeys {
		static var TiltingFactor = "tsv_TiltingFactor"
		
		static var MotionManager = "tsv_MotionManager"
		static var InitialAcceleration = "tsv_InitialAcceleration"
	}
	
    // MARK: Public Variables
    
    /// Factor by which the accelerometer data is multiplied to scroll the view. Larger values cause faster scrolling.
	
	public var tiltingFactor: CGFloat {
		get {
			return CGFloat((objc_getAssociatedObject(self, &AssociatedKeys.TiltingFactor) as? NSNumber ?? 20).floatValue)
		}
		set {
			objc_setAssociatedObject(self, &AssociatedKeys.TiltingFactor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}
	
    // MARK: Private Variables
	
	private var motionManager: CMMotionManager {
		get {
			let motionManager = objc_getAssociatedObject(self, &AssociatedKeys.MotionManager) as? CMMotionManager
			if let motionManager = motionManager{
				return motionManager
			} else {
				objc_setAssociatedObject(self, &AssociatedKeys.MotionManager, CMMotionManager(), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
				return objc_getAssociatedObject(self, &AssociatedKeys.MotionManager) as! CMMotionManager
			}
		}
		set {
			objc_setAssociatedObject(self, &AssociatedKeys.TiltingFactor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}
	
	private var initialAcceleration: Double! {
		get {
			return (objc_getAssociatedObject(self, &AssociatedKeys.InitialAcceleration) as? NSNumber)?.doubleValue
		}
		set {
			objc_setAssociatedObject(self, &AssociatedKeys.InitialAcceleration, NSNumber(double: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}
	
    // MARK: Public Methods
    
    /// Enables or disables the tilting behavior of the scroll view.
    /// - true: Tilting the device causes the scroll view to scroll. `scrollingEnabled = false`
    /// - false: Tilting the device does nothing. `scrollEnabled = true`
    
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
    
    /// Resets the internal calculations to use the current angle of the device as the reference point.
    /// At the device's current angle, the scroll view will not scroll.
    
    public func calibrate(){
        guard let data = motionManager.accelerometerData else { return }
        if UIInterfaceOrientationIsPortrait(UIApplication.sharedApplication().statusBarOrientation){
            initialAcceleration = data.acceleration.y
        } else {
            initialAcceleration = data.acceleration.x
        }
    }

    // MARK: Private Methods
    
    private func beginTiltToScroll(){
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
			print(yAcceleration)
            
            let shouldOffsetBeFlipped = UIApplication.sharedApplication().statusBarOrientation == .LandscapeLeft || UIApplication.sharedApplication().statusBarOrientation == .PortraitUpsideDown 
            
            let yOffset = self.tiltingFactor * CGFloat(yAcceleration) * (shouldOffsetBeFlipped ? -1 : 1)
            self.contentOffset = CGPoint(x: self.frame.origin.x, y: max(min(self.contentOffset.y - yOffset, self.contentSize.height - self.frame.size.height), 0))
        }
    }
    
}
