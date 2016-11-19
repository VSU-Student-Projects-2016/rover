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

class Rock : SKNode{
    
    var rock: SKSpriteNode!
    
    init(pos: CGPoint){
        super.init()
        
        let rockTexture = SKTexture(imageNamed: "rockImage")
        
        rock = SKSpriteNode(texture: rockTexture)
        rock.physicsBody = SKPhysicsBody(texture: rockTexture, size: rockTexture.size())
        rock.physicsBody?.categoryBitMask = rockCategory
        rock.physicsBody?.collisionBitMask =  bodyCategory | headCategory | arm1Category | leg1Category | carCategory
        rock.physicsBody?.contactTestBitMask =  bodyCategory | headCategory | arm1Category | leg1Category | arm2Category | leg2Category
        rock.physicsBody?.isDynamic = false

        rock.position = pos
        //rock.physicsBody?.friction = 100
        rock.zPosition = 10
        rock.scale(to: CGSize(width: 150, height: 150))
        //addChild(saw)
    }
    func add(to scene: SKScene){
        scene.addChild(rock)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
