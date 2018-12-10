//
//  Sound.swift
//  SantaSplat
//
//  Created by Zak Barlow on 10/12/2018.
//  Copyright © 2018 zakbarlow. All rights reserved.
//
import AudioToolbox

class Sound {
    
    var soundEffect: SystemSoundID = 0
    init(name: String, type: String) {
        let path  = Bundle.main.path(forResource: name, ofType: type)!
        let pathURL = NSURL(fileURLWithPath: path)
        AudioServicesCreateSystemSoundID(pathURL as CFURL, &soundEffect)
    }
    
    func play() {
        AudioServicesPlaySystemSound(soundEffect)
    }
}
