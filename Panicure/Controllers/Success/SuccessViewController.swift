//
//  SuccessViewController.swift
//  Panicure
//
//  Created by Sam Meech Ward on 2016-03-06.
//  Copyright © 2016 Panicuru. All rights reserved.
//

import UIKit

class SuccessViewController: UIViewController {

    var panic: Panic?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startRecording()
    }
    
    private func startRecording() {
        self.panic = EVANetworkHelper.sharedInstance().lastPanic as? Panic
        startRecordingImages()
    }
    
    
    let frontImageHelper = ImageCaptureHelper()
    let backImageHelper = ImageCaptureHelper()
    private func startRecordingImages() {
        frontImageHelper.frontCamera = true
        backImageHelper.frontCamera = false
        
        let group = dispatch_group_create()
        dispatch_group_enter(group)
        dispatch_group_notify(group, dispatch_get_main_queue()) { () -> Void in
            self.backImageHelper.capture { (image, error) -> Void in
                if let image = image {
                    EVANetworkHelper.sharedInstance().saveFrontCameraImage(image, toPanic: self.panic!)
                }
            }
        }
        
        frontImageHelper.capture { (image, error) -> Void in
            if let image = image {
                EVANetworkHelper.sharedInstance().saveFrontCameraImage(image, toPanic: self.panic!)
            }
            dispatch_group_leave(group)
        }
        
        
    }
}
