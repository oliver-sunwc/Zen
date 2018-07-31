//
//  ViewControllerPark.swift
//  iOS
//
//  Created by Temp on 7/25/18.
//  Copyright © 2018 MBIENTLAB, INC. All rights reserved.
//

import Foundation
import MetaWear
import AVFoundation

class ViewControllerPark : UIViewController, SendMetaWear {

    
    
    @IBOutlet weak var deviceStatus: UILabel!
    let PI : Double = 3.14159265359
    
    var device: MBLMetaWear!
    var timer : Timer?
    var startTime : TimeInterval?
    weak var mainViewDelegate : DeviceViewController!
    var playSoundsController : PlaySoundsController!
    
    func getValues(x: Double, y: Double, z: Double) {
        
        playSoundsController.updateListenerPosition(Float(x),Float(y),Float(z));
        print(x)
        print(y)
        print(z)
    }
    
    
    
    
}

