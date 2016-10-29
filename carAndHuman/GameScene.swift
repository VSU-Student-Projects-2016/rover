//
//  GameScene.swift
//  play
//
//  Created by Ivan on 21.10.16.
//  Copyright © 2016 Ivan. All rights reserved.
//
import SpriteKit
import GameplayKit

let carCategory: UInt32 = 1 << 0
let groundCategory: UInt32 = 1 << 1
let pipeCategory: UInt32 = 1 << 2
let bodyCategory: UInt32 = 1 << 4
let armCategory: UInt32 = 1 << 5
let legCategory: UInt32 = 1 << 6
let headCategory: UInt32 = 1 << 7
let sawCategory: UInt32 = 1 << 8
let spikeCategory: UInt32 = 1 << 9
let wheelCategory: UInt32 = 1 << 10
let springCategory: UInt32 = 1 << 11


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var myNewMan: Human!
    var myNewCar: Car!
    var cam: SKCameraNode!
    var ground1: SKShapeNode!
    var ground2: SKShapeNode!
    var ground: SKShapeNode!
    var moveGround1: SKAction!
    var moveGround2: SKAction!
    var pipe: SKShapeNode!
    
    var isTouch = false
    var spawn = false
    var notContact = true
    var camCar = true
    var speedCar: CGFloat = 0.0
    var distance = 0
    
    override func didMove(to view: SKView) {
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0)
        self.physicsWorld.contactDelegate = self
        
        self.backgroundColor = SKColor.blue
        
        createGround()
        
        myNewCar = Car()
        myNewCar.add(to: self)
        
        view.showsPhysics = true
        
        cam = SKCameraNode()
        self.camera = cam
        cam.xScale = 2
        cam.yScale = 2
        addChild(cam)
        cam.position = myNewCar.bodyCar.position
    }
    
    
    func createGround()
    {
        let groundPath = UIBezierPath()
        groundPath.move(to: CGPoint(x: -400, y: 0))
        groundPath.addLine(to: CGPoint(x: 600, y: 0))
        groundPath.addLine(to: CGPoint(x: 1200, y: 600))
        groundPath.addLine(to: CGPoint(x: 1200, y: 0))
        groundPath.addCurve(to: CGPoint(x: 8000,y: 0), controlPoint1: CGPoint(x: 3000,y: 300), controlPoint2: CGPoint(x: 4000, y: 0))
        groundPath.addLine(to: CGPoint(x: 8000, y: 1000))
        groundPath.addLine(to: CGPoint(x: 8000, y: 0))
        ground = SKShapeNode(path: groundPath.cgPath)
        ground.lineWidth = 2
        ground.fillColor = SKColor.orange
        ground.strokeColor = SKColor.orange
        ground.position = CGPoint(x: 0, y: 0)
        
        ground.physicsBody = SKPhysicsBody(edgeChainFrom: groundPath.cgPath)
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = groundCategory
        ground.physicsBody?.collisionBitMask = headCategory | bodyCategory | armCategory | legCategory | carCategory | wheelCategory | springCategory
        
        addChild(ground)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouch = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouch = false
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        if camCar{
            cam.position = myNewCar.circle2.position
        }
        else{
            cam.position = myNewMan.arm1.position
        }
        if isTouch && notContact{
            speedCar = speedCar + 20
            myNewCar.run(speed: speedCar)
        }
        else{
            if speedCar > 0 && notContact{
                speedCar = speedCar - 20
            }
            myNewCar.run(speed: speedCar)
        }
            if spawn{
            spawnPipe()
            spawnSaw()
            spawnSpike()
            spawn = false
        }
    }
    
    func spawnPipe(){
        pipe = SKShapeNode(rectOf: CGSize(width: 100, height: 100))
        pipe.fillColor = SKColor.red
        pipe.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 100, height: 100))
        pipe.physicsBody?.isDynamic = false
        pipe.physicsBody?.categoryBitMask = pipeCategory
        pipe.position = CGPoint(x: myNewCar.bodyCar.position.x + self.frame.width, y: 100)
        addChild(pipe)
        
        
    }
    
    func spawnSaw()
    {
        let saw = SKShapeNode(circleOfRadius:40)
        saw.physicsBody = SKPhysicsBody(circleOfRadius: 40)
        saw.fillColor = SKColor.black
        saw.physicsBody?.categoryBitMask = sawCategory
        saw.physicsBody?.collisionBitMask =  bodyCategory | headCategory | armCategory | legCategory
        saw.physicsBody?.isDynamic = false
        saw.position = CGPoint(x: myNewCar.bodyCar.position.x + self.frame.width + 1000, y: 100)
        addChild(saw)
        
    }
    
    func spawnSpike()
    {
        let spikePath = UIBezierPath() // Создаем и инициализируем объект типа UIBezierPath.
        spikePath.move(to: CGPoint.init(x: 0, y: 0))
        spikePath.addLine(to: CGPoint.init(x: -50, y: -100))
        spikePath.addLine(to: CGPoint.init(x: 50, y: -100))
        spikePath.addLine(to: CGPoint.init(x: 0, y: 0))
        
        
        let spike = SKShapeNode.init(path: spikePath.cgPath, centered: true)
        spike.position = CGPoint(x: myNewCar.bodyCar.position.x + self.frame.width + 700, y: 100)
        spike.lineWidth = 2 // задаем размер линий.
        spike.fillColor = SKColor.gray
        spike.strokeColor = SKColor.gray
        spike.physicsBody = SKPhysicsBody.init(polygonFrom: spikePath.cgPath)
        spike.physicsBody?.categoryBitMask = spikeCategory
        spike.physicsBody?.collisionBitMask =  bodyCategory | headCategory | armCategory | legCategory
        
        addChild(spike)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == pipeCategory || contact.bodyB.categoryBitMask == pipeCategory{
            let impulse = speedCar
            print(impulse)
            notContact = false
            speedCar = 0
            myNewCar.run(speed: speedCar)
            myNewCar.bodyCar.physicsBody?.applyImpulse(CGVector(dx: -impulse, dy: 100))
            
            camCar = false
            
            myNewMan = Human(pos: myNewCar.bodyCar.position)
            myNewMan.add(to: self)
            myNewMan.impulse(force: impulse/700)
            
            
            
            
        }
    }
}
