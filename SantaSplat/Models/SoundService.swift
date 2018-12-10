//
//  SoundService.swift
//  SantaSplat
//
//  Created by Zak Barlow on 10/12/2018.
//  Copyright © 2018 zakbarlow. All rights reserved.
//

import Foundation
import AudioToolbox

class SoundService {
    
    public static let sharedInstance = SoundService()
    
    public let splatSound: Sound
    public let splashSound: Sound
    
    init() {
        splashSound = Sound(name: "splash", type: "mp3")
        splatSound = Sound(name: "splat", type: "mp3")
    }
}
