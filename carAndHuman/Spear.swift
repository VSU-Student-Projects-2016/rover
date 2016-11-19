//
//  Spear.swift
//  carAndHuman
//
//  Created by xcode on 19.11.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import Foundation
import GameKit
import SpriteKit

class Spear{
    var spear: SKShapeNode!
    var spearHead: SKShapeNode!
    var jointSpear = SKPhysicsJointFixed()
    
    init(pos: CGPoint){
        spear = SKShapeNode(rectOf: CGSize(width: 20, height: 300))
        spear.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 20, height: 300))
        spear.physicsBody?.categoryBitMask = spearCategory
        spear.physicsBody?.isDynamic = false
        spear.physicsBody?.collisionBitMask = bodyCategory | arm1Category | arm2Category | leg1Category | leg2Category | headCategory | groundCategory
        spear.position = CGPoint(x: pos.x + 10, y: pos.y + 150)
        spear.fillColor = SKColor.brown
        
        let spearHeadPath = UIBezierPath()
        spearHeadPath.move(to: CGPoint(x: -10, y: 300))
        spearHeadPath.addLine(to: CGPoint(x: 10, y: 330))
        spearHeadPath.addLine(to: CGPoint(x: 30, y: 300))
        spearHeadPath.addLine(to: CGPoint(x: -10, y: 300))
        spearHead = SKShapeNode(path: spearHeadPath.cgPath)
        spearHead.physicsBody = SKPhysicsBody(edgeChainFrom: spearHeadPath.cgPath)
        spearHead.physicsBody?.categoryBitMask = spearHeadCategory
        spearHead.physicsBody?.isDynamic = false
        //spearHead.physicsBody?.collisionBitMask = bodyCategory | arm1Category | arm2Category | leg1Category | leg2Category | headCategory | groundCategory
        spearHead.physicsBody?.contactTestBitMask = bodyCategory | arm1Category | arm2Category | leg1Category | leg2Category | headCategory
        spearHead.position = CGPoint(x: pos.x, y: pos.y)
        spearHead.fillColor = SKColor.brown
        
        //jointSpear = SKPhysicsJointFixed.joint(withBodyA: spear.physicsBody!, bodyB: spearHead.physicsBody!, anchor: CGPoint(x: pos.x, y: pos.y))
    }
    
    func add(to scene: SKScene){
        scene.addChild(spear)
        scene.addChild(spearHead)
        //scene.physicsWorld.add(jointSpear)
    }

}
