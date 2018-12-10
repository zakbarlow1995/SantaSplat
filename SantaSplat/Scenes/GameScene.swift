//
//  GameScene.swift
//  SantaSplat
//
//  Created by Zak Barlow on 10/12/2018.
//  Copyright © 2018 zakbarlow. All rights reserved.
//

import SpriteKit

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
    
    override func didMove(to view: SKView) {
        setupPhysics()
        layoutScene()
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
        deathWall.color = .orange
        deathWall.size = CGSize(width: frame.size.width, height: frame.size.width/4)
        deathWall.position = CGPoint(x: frame.midX, y: frame.minY + bucket.size.height/4)
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
        UserDefaults.standard.set(score, forKey: "RecentScore")
        if score > UserDefaults.standard.integer(forKey: "HighScore") {
            UserDefaults.standard.set(score, forKey: "HighScore")
        }
        
        let menuScene = MenuScene(size: view!.bounds.size)
        view!.presentScene(menuScene)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        
        if location.x < frame.midX {
            print("\tGo left!")
            moveBucketLeft()
        } else if location.x > frame.midX {
            print("\tGo right!")
            moveBucketRight()
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
                //run(SoundService.sharedInstance.splashSound)
                run(SKAction.playSoundFileNamed("splash.wav", waitForCompletion: false))
                score += 1
                updateScoreLabel()
                
                santa.run(SKAction.fadeOut(withDuration: 0.05)) {
                    santa.removeFromParent()
                    //self.run(SKAction.playSoundFileNamed("splash.wav", waitForCompletion: false))
                    //SoundService.sharedInstance.splashSound.play()
                    self.spawnSanta()
                }
            }
        } else {
            if let santa = contact.bodyA.node?.name == "Santa" ? contact.bodyA.node as? SKSpriteNode : contact.bodyB.node as? SKSpriteNode {
                run(SoundService.sharedInstance.splatSound)
                
                santa.run(SKAction.fadeOut(withDuration: 0.01)) {
                    santa.removeFromParent()
                    //self.run(SKAction.playSoundFileNamed("splat.wav", waitForCompletion: true))
                    //SoundService.sharedInstance.splatSound.play()
                    self.gameOver()
                }
            }
        }
    }
}
