//
//  DeviceViewController.swift
//  SwiftStarter
//
//  Created by Stephen Schiffli on 10/20/15.
//  Copyright © 2015 MbientLab Inc. All rights reserved.
//

import UIKit
import MetaWear
import AVFoundation
protocol SendMetaWear : class {
    func getValues(x : Double, y : Double, z: Double)
}
class DeviceViewController: UIViewController {
    
    @IBOutlet weak var deviceStatus: UILabel!
    @IBOutlet weak var headView: headViewController!
    
    let PI : Double = 3.14159265359
    
    var device: MBLMetaWear!
    var timer : Timer?
    var startTime : TimeInterval?
    
    var playSoundsController : PlaySoundsController!
    
    weak var sendMetaWear : SendMetaWear!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        device.addObserver(self, forKeyPath: "state", options: NSKeyValueObservingOptions.new, context: nil)
        device.connectAsync().success { _ in
            self.device.led?.flashColorAsync(UIColor.green, withIntensity: 1.0, numberOfFlashes: 3)
            NSLog("We are connected")
        }
        
        device.sensorFusion?.eulerAngle.startNotificationsAsync { (obj, error) in
            self.getFusionValues(obj: obj!)
            }.success { result in
                print("Successfully subscribed")
            }.failure { error in
                print("Error on subscribe: \(error)")
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        /*
        super.viewWillDisappear(animated)
        
        device.removeObserver(self, forKeyPath: "state")
        device.led?.flashColorAsync(UIColor.red, withIntensity: 1.0, numberOfFlashes: 3)
        device.disconnectAsync()
 */
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        OperationQueue.main.addOperation {
            switch (self.device.state) {
            case .connected:
                self.deviceStatus.text = "Connected";
                self.device.sensorFusion?.mode = MBLSensorFusionMode.imuPlus
            case .connecting:
                self.deviceStatus.text = "Connecting";
            case .disconnected:
                self.deviceStatus.text = "Disconnected";
            case .disconnecting:
                self.deviceStatus.text = "Disconnecting";
            case .discovery:
                self.deviceStatus.text = "Discovery";
            }
        }
    }
    
    func radians(_ degree: Double) -> Double {
        return ( PI/180 * degree)
    }
    func degrees(_ radian: Double) -> Double {
        return (180 * radian / PI)
    }
     
    func getFusionValues(obj: MBLEulerAngleData){
        
        let x = radians((obj.p * -1) + 90)
        let y = radians(abs(365 - obj.y))
        let z = radians(obj.r)
        headView.setPointerPosition(w: 0.0, x : x, y: y, z: z)
        playSoundsController.updateAngularOrientation(abs(Float(365 - obj.y)))
        sendMetaWear.getValues(x: x, y: y, z: z)
    }
    
}
