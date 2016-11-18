//
//  Heart.swift
//  carAndHuman
//
//  Created by xcode on 05.11.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import Foundation
import SpriteKit
import GameKit

class Heart: SKNode{
   
    var heart1: SKSpriteNode!
    var heart2: SKSpriteNode!
    var heart3: SKSpriteNode!
    var count: Int!
    
    init(pos: CGPoint){
        super.init()
        count = 3
        let heartTexture = SKTexture(imageNamed: "heartImage")
        
        heart1 = SKSpriteNode(texture: heartTexture)
        heart1.position = pos
        heart1.zPosition = 20
        heart1.setScale(0.5)
        
        heart2 = SKSpriteNode(texture: heartTexture)
        heart2.position = CGPoint(x: heart1.position.x + 30, y: heart1.position.y)
        heart2.zPosition = 20
        heart2.setScale(0.5)
        
        heart3 = SKSpriteNode(texture: heartTexture)
        heart3.position = CGPoint(x: heart2.position.x + 30, y: heart2.position.y)
        heart3.zPosition = 20
        heart3.setScale(0.5)

    }
    func add(to scene: SKScene){
        scene.addChild(heart1)
        scene.addChild(heart2)
        scene.addChild(heart3)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
        
    func delHeart (){

        if count == 3{
            heart3.removeFromParent()
        }
        
        if count == 2{
            heart2.removeFromParent()
        }
        
        count = count - 1
        
    }
    
    
}
