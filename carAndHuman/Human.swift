//
//  Human.swift
//  carAndHuman
//
//  Created by xcode on 29.10.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import Foundation
import SpriteKit
import GameKit


class Human: SKNode {
    let bodyMan = SKShapeNode(circleOfRadius:30)
    let leg1 = SKShapeNode(ellipseOf: CGSize(width: 70, height: 25))
    let leg2 = SKShapeNode(ellipseOf: CGSize(width: 70, height: 25))
    let arm1 = SKShapeNode(ellipseOf: CGSize(width: 70, height: 25))
    let arm2 = SKShapeNode(ellipseOf: CGSize(width: 70, height: 25))
    let headMan = SKShapeNode(circleOfRadius:20)
    
    var jointHead = SKPhysicsJointFixed()
    var jointLeg1 = SKPhysicsJointFixed()
    var jointLeg2 = SKPhysicsJointFixed()
    var man3 = SKPhysicsJointFixed()
    var jointArm2 = SKPhysicsJointFixed()
    var jointArm1 = SKPhysicsJointPin()
    
    init (pos: CGPoint) {
        super.init()
        bodyMan.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        bodyMan.physicsBody?.isDynamic = true
        bodyMan.physicsBody?.categoryBitMask = bodyCategory
        bodyMan.physicsBody?.collisionBitMask =  groundCategory | sawCategory | spikeCategory | rockCategory | spearCategory
        bodyMan.physicsBody?.contactTestBitMask = groundCategory
        bodyMan.fillColor = SKColor.red
        bodyMan.position = CGPoint (x: pos.x - 30, y: pos.y)
        self.addChild(bodyMan)
        
        leg1.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 60, height: 20))
        leg1.physicsBody?.isDynamic = true
        leg1.physicsBody?.categoryBitMask = leg1Category
        leg1.physicsBody?.collisionBitMask =  groundCategory | sawCategory | spikeCategory | rockCategory | spearCategory
        leg1.physicsBody?.contactTestBitMask = groundCategory
        leg1.fillColor = SKColor.red
        leg1.position = CGPoint (x: pos.x - 80 , y: pos.y - 20)
        self.addChild(leg1)
        
        
        leg2.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 90, height: 20))
        leg2.physicsBody?.isDynamic = true
        leg2.physicsBody?.categoryBitMask = leg2Category
        leg2.physicsBody?.collisionBitMask =  groundCategory | sawCategory | spikeCategory | rockCategory | spearCategory
        leg2.physicsBody?.contactTestBitMask = groundCategory
        leg2.fillColor = SKColor.red
        leg2.position = CGPoint (x: pos.x - 80 , y: pos.y + 20)
        addChild(leg2)
        
        
        arm1.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 90, height: 20))
        arm1.physicsBody?.isDynamic = true
        arm1.physicsBody?.categoryBitMask = arm1Category
        arm1.physicsBody?.collisionBitMask =  groundCategory | sawCategory | spikeCategory | rockCategory | spearCategory
        arm1.physicsBody?.contactTestBitMask = groundCategory
        arm1.fillColor = SKColor.red
        arm1.position = CGPoint (x: pos.x + 40 , y: pos.y - 20)
        addChild(arm1)
        
        
        arm2.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 90, height: 20))
        arm2.physicsBody?.isDynamic = true
        arm2.physicsBody?.categoryBitMask = arm2Category
        arm2.physicsBody?.collisionBitMask =  groundCategory | sawCategory | spikeCategory | rockCategory | spearCategory
        arm2.physicsBody?.contactTestBitMask = groundCategory
        arm2.fillColor = SKColor.red
        arm2.position = CGPoint (x: pos.x + 40 , y: pos.y + 20)
        addChild(arm2)
        
        headMan.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        headMan.physicsBody?.isDynamic = true
        
        headMan.physicsBody?.categoryBitMask = headCategory
        headMan.physicsBody?.collisionBitMask =  groundCategory | sawCategory | spikeCategory | rockCategory | spearCategory
        headMan.physicsBody?.contactTestBitMask = groundCategory
        headMan.fillColor = SKColor.red
        headMan.position = pos
        addChild(headMan)
        
        jointHead = SKPhysicsJointFixed.joint(withBodyA: headMan.physicsBody!, bodyB: bodyMan.physicsBody!, anchor: CGPoint (x: pos.x - 20, y: pos.y))
        jointLeg1 = SKPhysicsJointFixed.joint(withBodyA: bodyMan.physicsBody!, bodyB: leg1.physicsBody!, anchor: CGPoint(x: pos.x - 45, y: pos.y + 20))
        jointLeg2 = SKPhysicsJointFixed.joint(withBodyA: bodyMan.physicsBody!, bodyB: leg2.physicsBody!, anchor: CGPoint(x: pos.x - 45, y: pos.y + 20))
        //let man3 = SKPhysicsJointFixed.joint(withBodyA: Circle2.physicsBody!, bodyB: arm1.physicsBody!, anchor: CGPoint(x: bird.position.x - 45, y: bird.position.y + 20))
        jointArm2 = SKPhysicsJointFixed.joint(withBodyA: bodyMan.physicsBody!, bodyB: arm2.physicsBody!, anchor: CGPoint(x: pos.x - 45, y: pos.y + 20))
        jointArm1 = SKPhysicsJointPin.joint(withBodyA: bodyMan.physicsBody!, bodyB: arm1.physicsBody!, anchor: CGPoint(x: pos.x - 5 , y: pos.y + 5))
        jointArm1.shouldEnableLimits = true
        jointArm1.lowerAngleLimit = CGFloat(GLKMathDegreesToRadians(-90))
        jointArm1.upperAngleLimit = CGFloat(GLKMathDegreesToRadians(20))
    }
    
    func add(to scene: SKScene) {
        scene.addChild(self)
        
        scene.physicsWorld.add(jointHead)
        scene.physicsWorld.add(jointLeg1)
        scene.physicsWorld.add(jointLeg2)
        scene.physicsWorld.add(jointArm2)
        scene.physicsWorld.add(jointArm1)
    }
    
    func impulse(force: CGFloat){
        bodyMan.physicsBody?.applyImpulse(CGVector(dx: force * 100, dy: force * 100))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

