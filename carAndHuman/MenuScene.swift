//
//  MenuScene.swift
//  carAndHuman
//
//  Created by xcode on 03.12.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

let buttonTexture = SKTexture(imageNamed: "play")

let buttonPlay = SKSpriteNode(texture: buttonTexture)

class MenuScene: SKScene {
    
    override func didMove(to view: SKView) {
        
        
        self.addChild(buttonPlay)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            
            let location = touch.location(in: self)
            
            if buttonPlay.contains(location) {
                startGame()
            }
            
        }
    }
    func startGame(){
        let transition:SKTransition = SKTransition.fade(withDuration: 1)
        /*let scene:SKScene = GameScene(size: self.size)
        self.view?.presentScene(scene, transition: transition)*/
        if let scene = GameScene.unarchiveFromFileGame("GameScene") as? GameScene {
            // Configure the view.
            view!.showsFPS = true
            view!.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            view!.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .aspectFill
            
            view!.presentScene(scene)
        }
    }
}
