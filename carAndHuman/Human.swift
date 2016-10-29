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
    let Circle2 = SKShapeNode(circleOfRadius:30)
    let leg1 = SKShapeNode(ellipseOf: CGSize(width: 70, height: 25))
    let leg2 = SKShapeNode(ellipseOf: CGSize(width: 70, height: 25))
    let arm1 = SKShapeNode(ellipseOf: CGSize(width: 70, height: 25))
    let arm2 = SKShapeNode(ellipseOf: CGSize(width: 70, height: 25))
    let Circle = SKShapeNode(circleOfRadius:20)
    
    var man = SKPhysicsJointFixed()
    var man1 = SKPhysicsJointFixed()
    var man2 = SKPhysicsJointFixed()
    var man3 = SKPhysicsJointFixed()
    var man4 = SKPhysicsJointFixed()
    var man5 = SKPhysicsJointSpring()
    
    init (pos: CGPoint) {
        super.init()
        Circle2.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        Circle2.physicsBody?.isDynamic = true
        Circle2.physicsBody?.categoryBitMask = bodyCategory
        Circle2.physicsBody?.collisionBitMask =  groundCategory | sawCategory | spikeCategory
        Circle2.physicsBody?.contactTestBitMask = groundCategory
        Circle2.fillColor = SKColor.red
        Circle2.position = CGPoint (x: pos.x - 30, y: pos.y)
        self.addChild(Circle2)
        
        leg1.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 60, height: 20))
        leg1.physicsBody?.isDynamic = true
        leg1.physicsBody?.categoryBitMask = legCategory
        leg1.physicsBody?.collisionBitMask =  groundCategory | sawCategory | spikeCategory
        leg1.physicsBody?.contactTestBitMask = groundCategory
        leg1.fillColor = SKColor.red
        leg1.position = CGPoint (x: pos.x - 80 , y: pos.y - 20)
        self.addChild(leg1)
        
        
        leg2.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 90, height: 20))
        leg2.physicsBody?.isDynamic = true
        leg2.physicsBody?.categoryBitMask = legCategory
        leg2.physicsBody?.collisionBitMask =  groundCategory | sawCategory | spikeCategory
        leg2.physicsBody?.contactTestBitMask = groundCategory
        leg2.fillColor = SKColor.red
        leg2.position = CGPoint (x: pos.x - 80 , y: pos.y + 20)
        addChild(leg2)
        
        
        arm1.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 90, height: 20))
        arm1.physicsBody?.isDynamic = true
        arm1.physicsBody?.categoryBitMask = armCategory
        arm1.physicsBody?.collisionBitMask =  groundCategory | sawCategory | spikeCategory
        arm1.physicsBody?.contactTestBitMask = groundCategory
        arm1.fillColor = SKColor.red
        arm1.position = CGPoint (x: pos.x + 40 , y: pos.y - 20)
        addChild(arm1)
        
        
        arm2.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 90, height: 20))
        arm2.physicsBody?.isDynamic = true
        arm2.physicsBody?.categoryBitMask = armCategory
        arm2.physicsBody?.collisionBitMask =  groundCategory | sawCategory | spikeCategory
        arm2.physicsBody?.contactTestBitMask = groundCategory
        arm2.fillColor = SKColor.red
        arm2.position = CGPoint (x: pos.x + 40 , y: pos.y + 20)
        addChild(arm2)
        
        Circle.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        Circle.physicsBody?.isDynamic = true
        
        Circle.physicsBody?.categoryBitMask = headCategory
        Circle.physicsBody?.collisionBitMask =  groundCategory | sawCategory | spikeCategory
        Circle.physicsBody?.contactTestBitMask = groundCategory
        Circle.fillColor = SKColor.red
        Circle.position = pos
        addChild(Circle)
        
        man = SKPhysicsJointFixed.joint(withBodyA: Circle.physicsBody!, bodyB: Circle2.physicsBody!, anchor: CGPoint (x: pos.x - 20, y: pos.y))
        man1 = SKPhysicsJointFixed.joint(withBodyA: Circle2.physicsBody!, bodyB: leg1.physicsBody!, anchor: CGPoint(x: pos.x - 45, y: pos.y + 20))
        man2 = SKPhysicsJointFixed.joint(withBodyA: Circle2.physicsBody!, bodyB: leg2.physicsBody!, anchor: CGPoint(x: pos.x - 45, y: pos.y + 20))
        //let man3 = SKPhysicsJointFixed.joint(withBodyA: Circle2.physicsBody!, bodyB: arm1.physicsBody!, anchor: CGPoint(x: bird.position.x - 45, y: bird.position.y + 20))
        man4 = SKPhysicsJointFixed.joint(withBodyA: Circle2.physicsBody!, bodyB: arm2.physicsBody!, anchor: CGPoint(x: pos.x - 45, y: pos.y + 20))
        man5 = SKPhysicsJointSpring.joint(withBodyA: Circle2.physicsBody!, bodyB: arm1.physicsBody!, anchorA: CGPoint(x: pos.x - 5 , y: pos.y + 5), anchorB: CGPoint(x: pos.x  , y: pos.y ))
    }
    
    func add(to scene: SKScene) {
        scene.addChild(self)
        
        scene.physicsWorld.add(man)
        scene.physicsWorld.add(man1)
        scene.physicsWorld.add(man2)
        scene.physicsWorld.add(man4)
        scene.physicsWorld.add(man5)
    }
    
    func impulse(force: CGFloat){
        Circle2.physicsBody?.applyImpulse(CGVector(dx: force * 100, dy: force * 100))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

