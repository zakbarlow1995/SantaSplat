//
//  GameViewController.swift
//  SantaSplat
//
//  Created by Zak Barlow on 10/12/2018.
//  Copyright © 2018 zakbarlow. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(resetSKView), name: .resetSKViewNotificaton, object: nil)
        
        presentView()
    }
    
    @objc func resetSKView(){
        presentView()
    }
    
    func presentView() {
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            let scene = MenuScene(size: view.bounds.size)
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            
            //scene.size = self.view.frame.size
            
            // Present the scene
            view.presentScene(scene)
            
            //Commented out because we want to specify z-order manually
            view.ignoresSiblingOrder = true
            
            //view.showsFPS = true
            //view.showsNodeCount = true
        }
    }
}

extension Notification.Name {
    static var resetSKViewNotificaton: Notification.Name {
        return .init(rawValue: "resetSKViewNotificaton")
    }
}
