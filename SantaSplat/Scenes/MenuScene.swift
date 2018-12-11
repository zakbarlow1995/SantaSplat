//
//  MenuScene.swift
//  SantaSplat
//
//  Created by Zak Barlow on 10/12/2018.
//  Copyright © 2018 zakbarlow. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(red: 44/255, green: 80/255, blue: 62/255, alpha: 1.0)
//        SoundService.sharedInstance.coinPlayer.prepareToPlay()
        addLogo()
        addLabels()
    }
    
    func addLogo() {
        let logo = SKSpriteNode(imageNamed: "santa")
        logo.size = CGSize(width: frame.size.width/4, height: frame.size.width/4)
        logo.position = CGPoint(x: frame.midX, y: frame.midY + frame.size.height/4)
        addChild(logo)
    }
    
    func addLabels() {
        let playLabel = SKLabelNode(text: "Tap to play!")
        playLabel.fontName = "Menlo-Bold"
        playLabel.fontSize = 45.0
        playLabel.fontColor = .white
        playLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(playLabel)
        animate(label: playLabel)
        
        let highscoreLabel = SKLabelNode(text: "Highscore: \(UserDefaults.standard.integer(forKey: "HighScore"))")
        highscoreLabel.fontName = "Menlo-Bold"
        highscoreLabel.fontSize = 35.0
        highscoreLabel.fontColor = .white
        highscoreLabel.position = CGPoint(x: frame.midX, y: frame.midY - highscoreLabel.frame.size.height*3)
        addChild(highscoreLabel)
        
        let recentScoreLabel = SKLabelNode(text: "Recent Score: \(UserDefaults.standard.integer(forKey: "RecentScore"))")
        recentScoreLabel.fontName = "Menlo-Bold"
        recentScoreLabel.fontSize = 35.0
        recentScoreLabel.fontColor = .white
        recentScoreLabel.position = CGPoint(x: frame.midX, y: highscoreLabel.position.y - recentScoreLabel.frame.size.height*2)
        addChild(recentScoreLabel)
    }
    
    func animate(label: SKLabelNode) {
        let fadeOut = SKAction.fadeOut(withDuration: 0.8)
        let fadeIn = SKAction.fadeIn(withDuration: 0.8)
        
        let scaleUp = SKAction.scale(to: 1.05, duration: 0.8)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.8)
        
        let sequenceOne = SKAction.sequence([fadeOut, fadeIn])
        let sequenceTwo = SKAction.sequence([scaleDown, scaleUp])
        label.run(SKAction.repeatForever(sequenceOne))
        label.run(SKAction.repeatForever(sequenceTwo))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //SoundService.sharedInstance.splashPlayer.prepareToPlay()
        SoundService.sharedInstance.coinPlayer.play()
        let gameScene = GameScene(size: view!.bounds.size)
        view!.presentScene(gameScene)
    }
    
}
