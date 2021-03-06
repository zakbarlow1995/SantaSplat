//
//  GameScene.swift
//  SantaSplat
//
//  Created by Zak Barlow on 10/12/2018.
//  Copyright © 2018 zakbarlow. All rights reserved.
//

import SpriteKit
// import AVFoundation

enum BucketState: Int {
    case left, centre, right
}

class GameScene: SKScene {
    
    var bucket: SKSpriteNode!
    var deathWall: SKSpriteNode!
    var bucketState = BucketState.centre
    var currentSantaIndex: Int?
    
    let scoreLabel = SKLabelNode(text: "0")
    var score = 0
    
    var tickCount: Int = 100
    var spawnRate = 100
    
    var gameTimer = Timer()
    var isGameOver = false
    
    override func didMove(to view: SKView) {
        isGameOver = false
//        SoundService.sharedInstance.splashPlayer.prepareToPlay()
//        SoundService.sharedInstance.splatPlayer.prepareToPlay()
        setupPhysics()
        layoutScene()
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector:#selector(self.tick) , userInfo: nil, repeats: true)
    }
    
    func setupPhysics() {
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0)
        physicsWorld.contactDelegate = self
    }
    
    func layoutScene() {
        backgroundColor = UIColor(red: 44/255, green: 80/255, blue: 62/255, alpha: 1.0)
        
        setupBucket()
        setupDeathWall()
        setupScoreLabel()
        spawnSanta()
    }
    
    func setupBucket() {
        bucket = SKSpriteNode(imageNamed: "bucket")
        bucket.size = CGSize(width: frame.size.width/4, height: frame.size.width/4)
        bucket.position = CGPoint(x: frame.midX, y: frame.minY + bucket.size.height)
        bucket.zPosition = ZPositions.bucket
        bucket.name = "Bucket"
        
        //Setup physics body
        bucket.physicsBody = SKPhysicsBody(rectangleOf: bucket.size)
        bucket.physicsBody?.categoryBitMask = PhysicsCategories.bucketCategory
        bucket.physicsBody?.isDynamic = false
        
        addChild(bucket)
    }
    
    func setupDeathWall() {
        deathWall = SKSpriteNode()
        //deathWall.color = UIColor(red: 40/255, green: 72/255, blue: 56/255, alpha: 1.0)//.orange
        if UIScreen.main.bounds.width == 320 {
            deathWall.size = CGSize(width: frame.size.width, height: frame.size.width/8)
            deathWall.position = CGPoint(x: frame.midX, y: frame.minY)
        } else {
            deathWall.size = CGSize(width: frame.size.width, height: frame.size.width/4)
            deathWall.position = CGPoint(x: frame.midX, y: frame.minY + bucket.size.height/3)
        }

        deathWall.position = CGPoint(x: frame.midX, y: frame.minY + bucket.size.height/3)
        deathWall.name = "DeathWall"
        
        //Setup physics body
        deathWall.physicsBody = SKPhysicsBody(rectangleOf: deathWall.size)
        deathWall.physicsBody?.categoryBitMask = PhysicsCategories.deathCategory
        deathWall.physicsBody?.isDynamic = false
        
        addChild(deathWall)
    }
    
    func setupScoreLabel() {
        scoreLabel.fontName = "Menlo-Bold"
        scoreLabel.fontSize = 70.0
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        scoreLabel.zPosition = ZPositions.label
        addChild(scoreLabel)
    }
    
    func updateScoreLabel() {
        scoreLabel.text = "\(score)"
    }
    
    func spawnSanta() {
//        SoundService.sharedInstance.splashPlayer.prepareToPlay()
//        SoundService.sharedInstance.splatPlayer.prepareToPlay()
        
        currentSantaIndex = Int.random(in: 0...2)
        
        let santa = SKSpriteNode(imageNamed: "santa")
        santa.size = CGSize(width: bucket.size.width/1.5, height: bucket.size.height/1.5)
        santa.position = CGPoint(x: (1.0+CGFloat(currentSantaIndex!))/4.0*frame.maxX, y: frame.maxY + santa.size.height)
        santa.zPosition = ZPositions.santa
        santa.name = "Santa"
        
        //Setup physics body
        santa.physicsBody = SKPhysicsBody(rectangleOf: santa.size)
        santa.physicsBody?.categoryBitMask = PhysicsCategories.santaCategory
        
        //Setup contact & collision test bit masks
        santa.physicsBody?.contactTestBitMask = PhysicsCategories.bucketCategory | PhysicsCategories.deathCategory
        santa.physicsBody?.collisionBitMask = PhysicsCategories.none
        
        addChild(santa)
    }
    
    func moveBucketLeft() {
        if let newState = BucketState(rawValue: bucketState.rawValue - 1) {
            bucketState = newState
            bucket.run(SKAction.moveBy(x: -frame.maxX/4.0, y: 0, duration: 0.08))
        }
        print(bucketState.rawValue)
    }
    
    func moveBucketRight() {
        if let newState = BucketState(rawValue: bucketState.rawValue + 1) {
            bucketState = newState
            bucket.run(SKAction.moveBy(x: frame.maxX/4.0, y: 0, duration: 0.08))
        }
        print(bucketState.rawValue)
    }
    
    func gameOver() {
        isGameOver = true
        UserDefaults.standard.set(score, forKey: "RecentScore")
        if score > UserDefaults.standard.integer(forKey: "HighScore") {
            UserDefaults.standard.set(score, forKey: "HighScore")
        }
        
        gameTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector:#selector(self.transitionBackToMenu) , userInfo: nil, repeats: false)
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
//            // Put your code which should be executed with a delay here
//            let menuScene = MenuScene(size: self.view!.bounds.size)
//            self.view!.presentScene(menuScene)
//        })
    }
    
    @objc func tick() {
        if !isGameOver {
            print(tickCount)
            if (tickCount == 0) {
                self.spawnSanta()
                if self.spawnRate <= 15 {
                    spawnRate = 14 + Int.random(in: 0...6)
                } else {
                    self.spawnRate = spawnRate - 2 // Change this to determine how quickly the spawn rate increases
                }
                self.tickCount=self.spawnRate
            }
            self.tickCount -= 1
        }
    }
    
    @objc func transitionBackToMenu() {
        self.removeAllChildren()
        
        // Removing Specific Children
        for child in self.children {
            
            //Determine Details
            if child.name == "Santa" {
                print("removed santa")
                child.removeFromParent()
            }
        }
        
        NotificationCenter.default.post(name: .resetSKViewNotificaton, object: self)
        
//        let menuScene = MenuScene(size: view!.bounds.size)// ?? UIScreen.screens[0].bounds.size)
//        self.view!.presentScene(menuScene)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        
//        if location.x < frame.midX {
//            run(SKAction.playSoundFileNamed("whoosh", waitForCompletion: false))
//            moveBucketLeft()
//        } else if location.x > frame.midX {
//            run(SKAction.playSoundFileNamed("whoosh", waitForCompletion: false))
//            moveBucketRight()
//        }
        
        if location.x <= frame.maxX/3.0 {
            moveBucketTo(.left)
        } else if location.x > frame.maxX/3 && location.x <= frame.maxX*2.0/3.0 {
            moveBucketTo(.centre)
        } else if location.x > frame.maxX*2.0/3.0 {
            moveBucketTo(.right)
        }
    }
    
    func moveBucketTo(_ newBucketState: BucketState) {
        if bucketState != newBucketState {
            run(SKAction.playSoundFileNamed("whoosh", waitForCompletion: false))
            bucketState = newBucketState
            bucket.run(SKAction.moveTo(x: (1.0+CGFloat(bucketState.rawValue))/4.0*frame.maxX, duration: 0.08))
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

extension GameScene: SKPhysicsContactDelegate {
    //  01
    //  10
    //> 11
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        // Usually use a switch statement
        if contactMask == PhysicsCategories.santaCategory | PhysicsCategories.bucketCategory {
            if let santa = contact.bodyA.node?.name == "Santa" ? contact.bodyA.node as? SKSpriteNode : contact.bodyB.node as? SKSpriteNode {
                
                if !isGameOver {
                    score += 1
                }
                updateScoreLabel()
                run(SKAction.playSoundFileNamed("splash", waitForCompletion: false))
                //SoundService.sharedInstance.splashPlayer.play()
                splash(on: santa)
                
                santa.run(SKAction.fadeOut(withDuration: 0.05)) {
                    santa.removeFromParent()
                    //self.spawnSanta()
                }
            }
        } else {
            if let santa = contact.bodyA.node?.name == "Santa" ? contact.bodyA.node as? SKSpriteNode : contact.bodyB.node as? SKSpriteNode {
                isGameOver = true
                run(SKAction.playSoundFileNamed("splat", waitForCompletion: false))
                //SoundService.sharedInstance.splatPlayer.play()
                splat(on: santa)
                santa.run(SKAction.fadeOut(withDuration: 0.01)) {
                    santa.removeFromParent()
                    self.gameOver()
                }
            }
        }
    }
    
    func splash(on santa: SKSpriteNode) {
        let emitter = SKEmitterNode(fileNamed: Emitter.splash)!
        var santaPosition = santa.position
        
        santaPosition.y -= santa.size.height
        
        emitter.position = santaPosition
        emitter.zPosition = ZPositions.emitter
        addChild(emitter)
    }
    
    func splat(on santa: SKSpriteNode) {
        let emitter = SKEmitterNode(fileNamed: Emitter.splat)!
        var santaPosition = santa.position
        
        santaPosition.y -= santa.size.height/1.5
        
        emitter.position = santaPosition
        emitter.zPosition = ZPositions.emitter
        addChild(emitter)
    }
}
