//
//  SoundService.swift
//  SantaSplat
//
//  Created by Zak Barlow on 10/12/2018.
//  Copyright © 2018 zakbarlow. All rights reserved.
//

import AudioToolbox
import SpriteKit

class SoundService {
    
    public static let sharedInstance = SoundService()
    
    public let splatSound = SKAction.playSoundFileNamed("splat", waitForCompletion: false)
    public let splashSound = SKAction.playSoundFileNamed("splash", waitForCompletion: false)
}
