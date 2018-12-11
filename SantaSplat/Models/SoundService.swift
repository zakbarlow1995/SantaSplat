//
//  SoundService.swift
//  SantaSplat
//
//  Created by Zak Barlow on 10/12/2018.
//  Copyright © 2018 zakbarlow. All rights reserved.
//

import AudioToolbox
import AVFoundation
import SpriteKit

class SoundService {
    
    public static let sharedInstance = SoundService()
    
    public let splatSound = SKAction.playSoundFileNamed("splat", waitForCompletion: false)
    public let splashSound = SKAction.playSoundFileNamed("splash", waitForCompletion: false)
    
    
    public var splashPlayer: AVAudioPlayer = {
        guard let path = Bundle.main.path(forResource: "splash", ofType: "wav") else {
            return AVAudioPlayer()
        }
        let url = URL(fileURLWithPath: path)
        
        guard let audioPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil) else {
            return AVAudioPlayer()
        }
        
        //audioPlayer.prepareToPlay()
        
        return audioPlayer
    }()
    
    public var splatPlayer: AVAudioPlayer = {
        guard let path = Bundle.main.path(forResource: "splat", ofType: "wav") else {
            return AVAudioPlayer()
        }
        let url = URL(fileURLWithPath: path)
        
        guard let audioPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil) else {
            return AVAudioPlayer()
        }
        
        //audioPlayer.prepareToPlay()
        
        return audioPlayer
    }()
    
    public var coinPlayer: AVAudioPlayer = {
        guard let path = Bundle.main.path(forResource: "coin", ofType: "wav") else {
            return AVAudioPlayer()
        }
        let url = URL(fileURLWithPath: path)
        
        guard let audioPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil) else {
            return AVAudioPlayer()
        }
        
        //audioPlayer.prepareToPlay()
        
        return audioPlayer
    }()
    
    init() {
        splatPlayer.prepareToPlay()
        splashPlayer.prepareToPlay()
        coinPlayer.prepareToPlay()
    }
}
