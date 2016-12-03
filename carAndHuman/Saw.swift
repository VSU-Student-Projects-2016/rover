//
//  Saw.swift
//  carAndHuman
//
//  Created by Ivan on 03.11.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import Foundation
import SpriteKit
import GameKit

class Saw : SKNode{
    
    var saw: SKSpriteNode!
    
    init(pos: CGPoint){
        super.init()
        
        let sawTexture = SKTexture(imageNamed: "sawImage")
        
        saw = SKSpriteNode(texture: sawTexture)
        saw.physicsBody = SKPhysicsBody(texture: sawTexture, size: sawTexture.size())
        saw.physicsBody?.categoryBitMask = sawCategory
        saw.physicsBody?.collisionBitMask =  bodyCategory | headCategory | arm1Category | leg1Category
        saw.physicsBody?.contactTestBitMask =  bodyCategory | headCategory | arm1Category | leg1Category | arm2Category | leg2Category
        saw.physicsBody?.isDynamic = false
        saw.physicsBody?.friction = 0
        let rotateSaw = SKAction.rotate(byAngle: 180, duration: 1)
        let rotateSawForever = SKAction.repeatForever(rotateSaw)
        saw.run(rotateSawForever)
        saw.position = pos
        saw.physicsBody?.friction = 100
        saw.zPosition = 10
        saw.scale(to: CGSize(width: 100, height: 100))
        //addChild(saw)
    }
    func add(to scene: SKScene){
                scene.addChild(saw)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
