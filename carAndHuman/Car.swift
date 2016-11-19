//
//  Car.swift
//  carAndHuman
//
//  Created by xcode on 29.10.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import Foundation
import GameKit
import SpriteKit


class Car: SKNode{
    
    
    //let bodyCar = SKShapeNode(rect: CGRect(x: 0.0, y: 0.0, width: 120.0, height: 40.0))
    var bodyCar: SKSpriteNode!
    var circle1: SKSpriteNode!
    var circle2: SKSpriteNode!
    var pinCircle1Pin = SKPhysicsJointPin()
    var pinCircle2Pin = SKPhysicsJointPin()
    var pinCircle1Spring = SKPhysicsJointSliding()
    var pinCircle2Spring = SKPhysicsJointSliding()
    let spring1 = SKShapeNode(rectOf: CGSize(width: 10, height: 30))
    let spring2 = SKShapeNode(rectOf: CGSize(width: 10, height: 30))
    
    
    override init() {
        super.init()
        bodyCar = SKSpriteNode(imageNamed: "car")
        bodyCar.zPosition = 1
        bodyCar.size = CGSize(width: 300, height: 150)
        circle1 = SKSpriteNode(imageNamed: "wheel")
        circle1.zPosition = 3
        circle1.size = CGSize(width: 80, height: 80)
        circle2 = SKSpriteNode(imageNamed: "wheel")
        circle2.zPosition = 3
        circle2.size = CGSize(width: 80, height: 80)
        
        let carTexture = SKTexture(imageNamed: "car")
        //bodyCar.physicsBody = SKPhysicsBody(rectangleOf: bodyCar.frame.size)
        bodyCar.physicsBody = SKPhysicsBody(texture: carTexture, size: CGSize(width: 300, height: 150))
        bodyCar.physicsBody?.categoryBitMask = carCategory
        bodyCar.physicsBody?.collisionBitMask =  groundCategory | pipeCategory | rockCategory
        bodyCar.physicsBody?.contactTestBitMask = pipeCategory
        bodyCar.physicsBody?.isDynamic = true
       // bodyCar.physicsBody?.mass = 1
        
        
        
        addChild(bodyCar)
        
        
        circle1.physicsBody = SKPhysicsBody(circleOfRadius: 40)
        circle1.physicsBody?.categoryBitMask = wheelCategory
        circle1.physicsBody?.collisionBitMask =  groundCategory
        //circle1.physicsBody?.contactTestBitMask = carCategory
        circle1.physicsBody?.isDynamic = true
        circle1.physicsBody?.mass = 1
        circle1.physicsBody?.friction = 100
        //circle1.physicsBody?.restitution = 2
        
        addChild(circle1)
        
        circle2.physicsBody = SKPhysicsBody(circleOfRadius: 40)
        circle2.physicsBody?.categoryBitMask = wheelCategory
        circle2.physicsBody?.collisionBitMask =  groundCategory
        //circle2.physicsBody?.contactTestBitMask = carCategory | groundCategory
        circle2.physicsBody?.isDynamic = true
        circle2.physicsBody?.mass = 1
       // circle2.physicsBody?.friction = 100
       // circle2.physicsBody?.restitution = 2
        
        addChild(circle2)
        
        spring1.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: 90))
        spring1.fillColor = SKColor.red
        spring1.zPosition = 10
        spring1.physicsBody?.isDynamic = true
        spring1.physicsBody?.categoryBitMask = springCategory
        spring1.physicsBody?.collisionBitMask = groundCategory
        
        spring2.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: 90))
        spring2.fillColor = SKColor.red
        spring2.zPosition = 10
        spring2.physicsBody?.isDynamic = true
        spring2.physicsBody?.categoryBitMask = springCategory
        spring2.physicsBody?.collisionBitMask = groundCategory
        
        addChild(spring1)
        addChild(spring2)
    }
    
    func add(to scene: SKScene) {
        bodyCar.position = CGPoint(x: -150, y: 85)
        circle1.position = CGPoint(x: bodyCar.position.x - 80, y: bodyCar.position.y - 50)
        circle2.position = CGPoint(x: bodyCar.position.x + 80, y: bodyCar.position.y - 50)
        
        spring1.position = CGPoint(x: circle1.position.x, y: circle1.position.y + 20)
        spring2.position = CGPoint(x: circle2.position.x, y: circle2.position.y + 20)
        
        scene.addChild(self)
        
        pinCircle1Pin = SKPhysicsJointPin.joint(withBodyA: spring1.physicsBody!, bodyB: circle1.physicsBody!, anchor: circle1.position)
        pinCircle2Pin = SKPhysicsJointPin.joint(withBodyA: spring2.physicsBody!, bodyB: circle2.physicsBody!, anchor: circle2.position)
        pinCircle2Pin.frictionTorque = 0.0
        pinCircle1Pin.frictionTorque = 0.0
        
        pinCircle1Spring = SKPhysicsJointSliding.joint(withBodyA: bodyCar.physicsBody!, bodyB:  spring1.physicsBody!, anchor: CGPoint (x: bodyCar.position.x - 80, y: bodyCar.position.y-10), axis: CGVector((dx: CGFloat(0.0), dy: CGFloat(1.0))))
        pinCircle1Spring.shouldEnableLimits = true
        pinCircle1Spring.lowerDistanceLimit = -10
        pinCircle1Spring.upperDistanceLimit = 0
        
        pinCircle2Spring = SKPhysicsJointSliding.joint(withBodyA: bodyCar.physicsBody!, bodyB: spring2.physicsBody!, anchor: CGPoint (x: bodyCar.position.x + 80, y: bodyCar.position.y - 10), axis: CGVector((dx: CGFloat(0.0), dy: CGFloat(1.0))))
        pinCircle2Spring.shouldEnableLimits = true
        pinCircle2Spring.lowerDistanceLimit = -10
        pinCircle2Spring.upperDistanceLimit = 0
        
        let exhaustPipe = SKShapeNode(rectOf: CGSize(width: 30, height: 10))
        exhaustPipe.fillColor = SKColor.black
        exhaustPipe.position = CGPoint(x: -150, y: -60)
        let exhaust = SKEmitterNode(fileNamed: "smoke.sks")
        exhaust?.targetNode = scene
        exhaust?.position = CGPoint(x: -160, y: -60)
        exhaust?.run(SKAction.rotate(byAngle: -30, duration: 0))
        bodyCar.addChild(exhaust!)
        bodyCar.addChild(exhaustPipe)
        
        
        
        scene.physicsWorld.add(pinCircle1Spring)
        scene.physicsWorld.add(pinCircle2Spring)
        scene.physicsWorld.add(pinCircle1Pin)
        scene.physicsWorld.add(pinCircle2Pin)
        
        
        
    }
    
    
    func run (speed: CGFloat){
        circle1.physicsBody?.applyTorque(-speed * 0.001)
        circle2.physicsBody?.applyTorque(-speed * 0.001)
        //circle1.physicsBody?.velocity = CGVector(dx: speed, dy: 0)
        //circle2.physicsBody?.velocity = CGVector(dx: speed, dy: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
