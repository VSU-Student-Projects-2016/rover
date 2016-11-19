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
let arm1Category: UInt32 = 1 << 5
let arm2Category: UInt32 = 1 << 6
let leg1Category: UInt32 = 1 << 7
let leg2Category: UInt32 = 1 << 8
let headCategory: UInt32 = 1 << 9
let sawCategory: UInt32 = 1 << 10
let spikeCategory: UInt32 = 1 << 11
let wheelCategory: UInt32 = 1 << 12
let springCategory: UInt32 = 1 << 13
let dsCategory: UInt32 = 1 << 14
let spearCategory: UInt32 = 1 << 15
let spearHeadCategory: UInt32 = 1 << 16

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var myNewMan: Human!
    var myNewCar: Car!
    var newSaw: Saw!
    var newSpear: Spear!
    var cam: SKCameraNode!
    var ground1: SKShapeNode!
    var ground2: SKShapeNode!
    var ground: SKShapeNode!
    var moveGround1: SKAction!
    var moveGround2: SKAction!
    var pipe: SKShapeNode!
    var heart: Heart!
    var score: SKLabelNode!
    var resetButton: SKSpriteNode!
    
    var isSpear = true
    var heartDel = true
    var isTouch = false
    var notContact = true
    var camCar = true
    var speedCar: CGFloat = 0.0
    var distance = 0
    var maxSpeed:CGFloat = 0.0
    var reset = false
    let widthGround:CGFloat = 8000
    
    var scoreCount = 0
    var timer: Int = 0
    var timers = [Int]()
    var timerLast = 0


    
    override func didMove(to view: SKView) {
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0)
        self.physicsWorld.contactDelegate = self
        
        self.backgroundColor = SKColor.blue
        
        let wait = SKAction.wait(forDuration: 0.5)
        let block = SKAction.run({() in
            self.timer = self.timer + 1
        })
        run(SKAction.repeatForever(SKAction.sequence([wait, block])))
        
        createGround()
        spawnPipe(position: CGPoint(x: ground2.position.x + ground2.frame.size.width/2, y: ground2.position.y + ground2.frame.size.height))
        spawnPipe(position: CGPoint(x: 8000, y: 50))
        newSaw = Saw(pos: CGPoint(x: ground2.position.x + ground2.frame.size.width/2 + 400, y: ground2.position.y + ground2.frame.size.height + 350))
        newSaw.add(to: self)
        
    
        self.physicsWorld.enumerateBodies(alongRayStart: CGPoint(x: ground2.position.x + ground2.frame.size.width/2 + 1500, y: 800), end: CGPoint(x: ground2.position.x + ground2.frame.size.width/2 + 1500, y: 0)) { (b:SKPhysicsBody, position: CGPoint, vector: CGVector, boolPointer: UnsafeMutablePointer<ObjCBool>) in
            if b.categoryBitMask == groundCategory{
                self.newSpear = Spear(pos: position)
                self.newSpear.add(to: self)
            }
        }

        
        
        myNewCar = Car()
        myNewCar.add(to: self)
        
        
        
        view.showsPhysics = true
        
        cam = SKCameraNode()
        self.camera = cam
        cam.xScale = 2
        cam.yScale = 2
        addChild(cam)
        cam.position = myNewCar.bodyCar.position
        
        resetButton = SKSpriteNode(imageNamed: "repeat")
        resetButton.setScale(0.7)
        resetButton.position = CGPoint(x: 0, y: 180)
        cam.addChild(resetButton)
        
        heart = Heart.init(pos: CGPoint(x: 250, y: 180))
        cam.addChild(heart.heart1)
        cam.addChild(heart.heart2)
        cam.addChild(heart.heart3)
        
        score = SKLabelNode(text: "0")
        score.fontSize = 50
        score.position = CGPoint(x: cam.position.x +  100, y: cam.position.y +  100)
        score.position = CGPoint(x: -270, y: 180)
        print(self.frame.width)
        print(self.frame.height)
        cam.addChild(score)
    }
    

    func resetScene(){
        reset = true
        isSpear = false
        heart.delHeart()
        timer = 0
        timerLast = 0
        if !heartDel{
            myNewMan.removeFromParent()
        }
        heartDel = true
        myNewCar.removeFromParent()
        notContact = true
        camCar = true
        myNewCar = Car()
        myNewCar.add(to: self)
        let resetCam = SKAction.run({() in
                self.reset = false
        })
        if heart.count == 0{
            heart.count = 3
            scoreCount = 0
            score.text = "0"
            cam.addChild(heart.heart2)
            cam.addChild(heart.heart3)
            var xDiamond: CGFloat = 0.0
            while xDiamond < widthGround{
                self.physicsWorld.enumerateBodies(alongRayStart: CGPoint(x: xDiamond, y: 800), end: CGPoint(x: xDiamond, y: 0)) { (b:SKPhysicsBody, position: CGPoint, vector: CGVector, boolPointer: UnsafeMutablePointer<ObjCBool>) in
                    if b.categoryBitMask == dsCategory{
                        b.node?.removeFromParent()
                    }
                }
                xDiamond = xDiamond + 300
            }
            xDiamond = 0.0
            while xDiamond < widthGround{
                self.physicsWorld.enumerateBodies(alongRayStart: CGPoint(x: xDiamond, y: 800), end: CGPoint(x: xDiamond, y: 0)) { (b:SKPhysicsBody, position: CGPoint, vector: CGVector, boolPointer: UnsafeMutablePointer<ObjCBool>) in
                    if b.categoryBitMask == groundCategory{
                        self.spawnDiamonds(pos: CGPoint(x: position.x, y: position.y + 100))
                    }
                }
                xDiamond = xDiamond + 300
            }

        }
        cam.run(SKAction.sequence([SKAction.move(to: myNewCar.circle2.position, duration: 5), resetCam]))
    }
    

    func createGround()
    {
        let groundPath = UIBezierPath()
        groundPath.move(to: CGPoint(x: -400, y: 0))
        groundPath.addLine(to: CGPoint(x: 600, y: 0))
        groundPath.addLine(to: CGPoint(x: 1200, y: 400))
        groundPath.addLine(to: CGPoint(x: 1200, y: 0))
        groundPath.addCurve(to: CGPoint(x: 8000,y: 0), controlPoint1: CGPoint(x: 3000,y: 300), controlPoint2: CGPoint(x: widthGround, y: 0))
        ground = SKShapeNode(path: groundPath.cgPath)
        ground.lineWidth = 2
        ground.fillColor = SKColor.orange
        ground.strokeColor = SKColor.orange
        ground.position = CGPoint(x: 0, y: 0)
        ground.physicsBody = SKPhysicsBody(edgeChainFrom: groundPath.cgPath)
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = groundCategory
        ground.physicsBody?.collisionBitMask = headCategory | bodyCategory | arm1Category | leg1Category | carCategory | wheelCategory | springCategory
        ground.physicsBody?.friction = 200
        addChild(ground)
        
        ground2 = SKShapeNode(rectOf: CGSize(width: 2000, height: 100))
        ground2.fillColor = SKColor.green
        ground2.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 2000, height: 100))
        ground2.physicsBody?.isDynamic = false
        ground2.physicsBody?.categoryBitMask = groundCategory
         ground.physicsBody?.collisionBitMask = headCategory | bodyCategory | arm1Category | leg1Category | carCategory | wheelCategory | springCategory
        ground2.position = CGPoint(x: 2500, y: 400)
        addChild(ground2)
        
        var xDiamond: CGFloat = 0.0
        while xDiamond < widthGround{
            self.physicsWorld.enumerateBodies(alongRayStart: CGPoint(x: xDiamond, y: 800), end: CGPoint(x: xDiamond, y: 0)) { (b:SKPhysicsBody, position: CGPoint, vector: CGVector, boolPointer: UnsafeMutablePointer<ObjCBool>) in
                if b.categoryBitMask == groundCategory{
                    self.spawnDiamonds(pos: CGPoint(x: position.x, y: position.y + 100))
                }
            }
            xDiamond = xDiamond + 300
        }

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let location = touch.location(in: cam)
            if resetButton.contains(location){
                resetScene()
            }
            else{
                isTouch = true
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouch = false
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        if !reset{
            if camCar{
                cam.position = myNewCar.circle2.position
            }
            else{
                cam.position = myNewMan.arm1.position
            }
        }

        if timerLast > 0 && timer - timerLast > 4{
            resetScene()
        }
        
        
        if isTouch && notContact{
            speedCar = speedCar + 50
            myNewCar.run(speed: speedCar)
            //maxSpeed = speedCar
            //f = true
        }
        else{
            if speedCar > 0 && notContact{
                speedCar = speedCar - 50
                myNewCar.run(speed: 0)
            }
        }
    }
    
    func spawnPipe(position: CGPoint){
        pipe = SKShapeNode(rectOf: CGSize(width: 100, height: 100))
        pipe.fillColor = SKColor.red
        pipe.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 100, height: 100))
        pipe.physicsBody?.isDynamic = false
        pipe.physicsBody?.categoryBitMask = pipeCategory
        pipe.position = position
        addChild(pipe)
        
        
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
        spike.physicsBody?.collisionBitMask =  bodyCategory | headCategory | arm1Category | leg1Category
        
        addChild(spike)
    }
    
    func spawnDiamonds(pos: CGPoint){
        let diamondTexture = SKTexture(imageNamed: "diamond")
        let diamond = SKSpriteNode(texture: diamondTexture)
        diamond.physicsBody = SKPhysicsBody(texture: diamondTexture, size: diamondTexture.size())
        diamond.physicsBody?.categoryBitMask = dsCategory
        diamond.physicsBody?.isDynamic = false
        diamond.physicsBody?.contactTestBitMask = carCategory | bodyCategory | arm1Category | arm2Category | leg1Category | leg2Category | headCategory
        diamond.position = pos
        addChild(diamond)
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if isSpear && (contact.bodyA.categoryBitMask == spearHeadCategory || contact.bodyB.categoryBitMask == spearHeadCategory) {
            let manCategory: UInt32
            var jointManSpear: SKPhysicsJointSliding
            
            if contact.bodyA.categoryBitMask != spearHeadCategory{
                manCategory = contact.bodyA.categoryBitMask
            }
            else{
                manCategory = contact.bodyB.categoryBitMask
            }
        
            switch manCategory {
            case arm1Category:
                jointManSpear = SKPhysicsJointSliding.joint(withBodyA: newSpear.spearHead.physicsBody!, bodyB: myNewMan.arm1.physicsBody!, anchor: contact.contactPoint, axis: CGVector(dx: 0, dy: 1))
            case arm2Category:
                jointManSpear = SKPhysicsJointSliding.joint(withBodyA: newSpear.spearHead.physicsBody!, bodyB: myNewMan.arm2.physicsBody!, anchor: contact.contactPoint, axis: CGVector(dx: 0, dy: 1))
            case leg1Category:
                jointManSpear = SKPhysicsJointSliding.joint(withBodyA: newSpear.spearHead.physicsBody!, bodyB: myNewMan.leg1.physicsBody!, anchor: contact.contactPoint, axis: CGVector(dx: 0, dy: 1))
            case leg2Category:
                jointManSpear = SKPhysicsJointSliding.joint(withBodyA: newSpear.spearHead.physicsBody!, bodyB: myNewMan.leg2.physicsBody!, anchor: contact.contactPoint, axis: CGVector(dx: 0, dy: 1))
            case headCategory:
                jointManSpear = SKPhysicsJointSliding.joint(withBodyA: newSpear.spearHead.physicsBody!, bodyB: myNewMan.headMan.physicsBody!, anchor: contact.contactPoint,axis: CGVector(dx: 0, dy: 1))
            default:
                jointManSpear = SKPhysicsJointSliding.joint(withBodyA: newSpear.spearHead.physicsBody!, bodyB: myNewMan.bodyMan.physicsBody!, anchor: contact.contactPoint, axis: CGVector(dx: 0, dy: 1))
            }
            myNewMan.arm1.physicsBody?.collisionBitMask = groundCategory | sawCategory
            myNewMan.arm2.physicsBody?.collisionBitMask = groundCategory | sawCategory
            myNewMan.leg1.physicsBody?.collisionBitMask = groundCategory | sawCategory
            myNewMan.leg2.physicsBody?.collisionBitMask = groundCategory | sawCategory
            myNewMan.bodyMan.physicsBody?.collisionBitMask = groundCategory | sawCategory
            myNewMan.headMan.physicsBody?.collisionBitMask = groundCategory | sawCategory
            self.physicsWorld.add(jointManSpear)
            isSpear = false
        }
        
        if contact.bodyA.categoryBitMask == dsCategory || contact.bodyB.categoryBitMask == dsCategory{
            if contact.bodyA.categoryBitMask == dsCategory{
                contact.bodyA.node?.removeFromParent()
            }
            if contact.bodyB.categoryBitMask == dsCategory{
                contact.bodyB.node?.removeFromParent()
            }
            let dsFinish = SKEmitterNode(fileNamed: "diamondRemove.sks")
            dsFinish?.position = CGPoint(x: contact.contactPoint.x + 100, y: contact.contactPoint.y)
            dsFinish?.zPosition = 0
            let waitAction = SKAction.wait(forDuration: 0.4)
            addChild(dsFinish!)
            dsFinish?.run(SKAction.sequence([waitAction, SKAction.removeFromParent()]))
            scoreCount = scoreCount + 10
            score.text = String(scoreCount)
        }
        
        if notContact && (contact.bodyA.categoryBitMask == pipeCategory || contact.bodyB.categoryBitMask == pipeCategory){
            if contact.collisionImpulse > 1400{
                let impulse = speedCar
                //print(impulse)
                //print(contact.collisionImpulse)
                notContact = false
                speedCar = 0
                myNewCar.run(speed: speedCar)
                myNewCar.bodyCar.physicsBody?.applyImpulse(CGVector(dx: -impulse, dy: 100))
            
                camCar = false
            
                myNewMan = Human(pos: myNewCar.bodyCar.position)
                myNewMan.add(to: self)
                myNewMan.impulse(force: contact.collisionImpulse * 0.002)
            
                //минус сердце
                //heart.delHeart()
                heartDel = false
                //resetScene()
                print(timer)
            }
        }
        
        if contact.bodyA.categoryBitMask == groundCategory || contact.bodyB.categoryBitMask == groundCategory{
            print("contact ground")
            timerLast = timer
            timers.append(timer)
        }
        
        if contact.bodyA.categoryBitMask == sawCategory || contact.bodyB.categoryBitMask == sawCategory{
            let manCategory: UInt32
            if contact.bodyA.categoryBitMask != sawCategory{
                manCategory = contact.bodyA.categoryBitMask
            }
            else{
                manCategory = contact.bodyB.categoryBitMask
            }
            //print(contact.collisionImpulse)
            if contact.collisionImpulse > 60{
                switch(manCategory){
                case arm1Category:
                    self.physicsWorld.remove(myNewMan.jointArm1)
                    break
                case arm2Category:
                    self.physicsWorld.remove(myNewMan.jointArm2)
                case leg1Category:
                    self.physicsWorld.remove(myNewMan.jointLeg1)
                case leg2Category:
                    self.physicsWorld.remove(myNewMan.jointLeg2)
                case headCategory:
                    self.physicsWorld.remove(myNewMan.jointHead)
                default:
                    self.physicsWorld.remove(myNewMan.jointHead)
                }
                let bloodMan = SKEmitterNode(fileNamed: "blood.sks")
               // bloodMan?.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: 10))
                //let
                bloodMan?.position = CGPoint(x: myNewMan.bodyMan.position.x - 10, y: myNewMan.bodyMan.position.y)
                bloodMan?.setScale(0.6)
                let waitAction = SKAction.wait(forDuration: 0.4)
                addChild(bloodMan!)
                bloodMan?.run(SKAction.sequence([waitAction, SKAction.removeFromParent()]))
                
            }
        }
        
    }
}
