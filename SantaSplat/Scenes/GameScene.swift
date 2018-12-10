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
    
    override func didMove(to view: SKView) {
        setupPhysics()
        layoutScene()
    }
    
    func setupPhysics() {
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.0)
        physicsWorld.contactDelegate = self
    }
    
    func layoutScene() {
        backgroundColor = UIColor(red: 44/255, green: 80/255, blue: 62/255, alpha: 1.0)
        
        bucket = SKSpriteNode(imageNamed: "bucket")
        bucket.size = CGSize(width: frame.size.width/4, height: frame.size.width/4)
        bucket.position = CGPoint(x: frame.midX, y: frame.minY + bucket.size.height)
        
        //Setup physics body
        bucket.physicsBody = SKPhysicsBody(rectangleOf: bucket.size)
        bucket.physicsBody?.categoryBitMask = PhysicsCategories.bucketCategory
        bucket.physicsBody?.isDynamic = false
        
        addChild(bucket)
        spawnSanta()
    }
    
    func spawnSanta() {
        let santa = SKSpriteNode(imageNamed: "santa")
        santa.size = CGSize(width: bucket.size.width/1.5, height: bucket.size.height/1.5)
        santa.position = CGPoint(x: frame.midX, y: frame.maxY)
        
        //Setup physics body
        santa.physicsBody = SKPhysicsBody(rectangleOf: santa.size)
        santa.physicsBody?.categoryBitMask = PhysicsCategories.santaCategory
        
        //Setup contact & collision test bit masks
        santa.physicsBody?.contactTestBitMask = PhysicsCategories.bucketCategory
        santa.physicsBody?.collisionBitMask = PhysicsCategories.none
        
        addChild(santa)
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
            print("Contact!!")
        }
    }
}
