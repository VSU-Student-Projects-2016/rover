//
//  File.swift
//  carAndHuman
//
//  Created by xcode on 19.11.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import Foundation
import SpriteKit
import GameKit

class Platform : SKNode{
    
    var platform: SKShapeNode!
    
    init(pos: CGPoint){
        super.init()
        
        //let rockTexture = SKTexture(imageNamed: "rockImage")
        
        platform = SKShapeNode(rectOf: CGSize(width: 200, height: 10))
        platform.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 200, height: 10))
        platform.fillColor = SKColor.gray
        //rock.physicsBody = SKPhysicsBody(texture: rockTexture, size: rockTexture.size())
        platform.physicsBody?.categoryBitMask = platformCategory
        platform.physicsBody?.collisionBitMask =  bodyCategory | headCategory | arm1Category | leg1Category | carCategory
        platform.physicsBody?.contactTestBitMask =  bodyCategory | headCategory | arm1Category | leg1Category | arm2Category | leg2Category
        platform.physicsBody?.isDynamic = false
        
        
        platform.position = pos
        platform.zPosition = 10
        platform.zRotation = 60
        

    }
    func add(to scene: SKScene){
        scene.addChild(platform)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
