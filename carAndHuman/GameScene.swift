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

class Car: SKNode{
    
    
    //let bodyCar = SKShapeNode(rect: CGRect(x: 0.0, y: 0.0, width: 120.0, height: 40.0))
    var bodyCar: SKSpriteNode!
    var circle1: SKSpriteNode!
    var circle2: SKSpriteNode!
    var pinCircle1Fix = SKPhysicsJointFixed()
    var pinCircle2Fix = SKPhysicsJointFixed()
    var pinCircle1Spring = SKPhysicsJointPin()
    var pinCircle2Spring = SKPhysicsJointPin()
    
    
    override init() {
        super.init()
        bodyCar = SKSpriteNode(imageNamed: "car")
        bodyCar.zPosition = 0
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
        bodyCar.physicsBody?.collisionBitMask =  groundCategory
        bodyCar.physicsBody?.contactTestBitMask = pipeCategory
        bodyCar.physicsBody?.isDynamic = true
        
        addChild(bodyCar)
        
        circle1.physicsBody = SKPhysicsBody(circleOfRadius: 40)
        circle1.physicsBody?.categoryBitMask = wheelCategory
        circle1.physicsBody?.collisionBitMask =  groundCategory
        //circle1.physicsBody?.contactTestBitMask = carCategory
        circle1.physicsBody?.isDynamic = true
        
        addChild(circle1)
        
        circle2.physicsBody = SKPhysicsBody(circleOfRadius: 40)
        circle2.physicsBody?.categoryBitMask = wheelCategory
        circle2.physicsBody?.collisionBitMask =  groundCategory
        //circle2.physicsBody?.contactTestBitMask = carCategory | groundCategory
        circle2.physicsBody?.isDynamic = true
        //circle2.physicsBody?.mass = 1000
        
        addChild(circle2)
        /*
         pinCircle1Fix = SKPhysicsJointFixed.joint(withBodyA: bodyCar.physicsBody!, bodyB: circle1.physicsBody!, anchor: CGPoint (x: bodyCar.position.x - 80, y: bodyCar.position.y-10))
         pinCircle2Fix = SKPhysicsJointFixed.joint(withBodyA: bodyCar.physicsBody!, bodyB: circle2.physicsBody!, anchor: CGPoint (x: bodyCar.position.x + 80, y: bodyCar.position.y-10))
         pinCircle1Spring = SKPhysicsJointSliding.joint(withBodyA: bodyCar.physicsBody!, bodyB:  circle1.physicsBody!, anchor: CGPoint (x: bodyCar.position.x - 80, y: bodyCar.position.y-10), axis: CGVector((dx: CGFloat(0.0), dy: CGFloat(1.0))))
         pinCircle1Spring.shouldEnableLimits = true
         pinCircle1Spring.lowerDistanceLimit = 10
         pinCircle1Spring.upperDistanceLimit = 10
         
         pinCircle2Spring = SKPhysicsJointSliding.joint(withBodyA: bodyCar.physicsBody!, bodyB: circle2.physicsBody!, anchor: CGPoint (x: bodyCar.position.x + 80, y: bodyCar.position.y-10), axis: CGVector((dx: CGFloat(0.0), dy: CGFloat(1.0))))
         pinCircle2Spring.shouldEnableLimits = true
         pinCircle2Spring.lowerDistanceLimit = 10
         pinCircle2Spring.upperDistanceLimit = 10
         //   leftSlide.shouldEnableLimits = TRUE;
         // leftSlide.lowerDistanceLimit = 5;
         // leftSlide.upperDistanceLimit = wheelOffsetY;
         
         */
        
        //pinCircle2Spring.rotationSpeed = 0.01
    }
    
    func add(to scene: SKScene) {
        bodyCar.position = CGPoint(x: -150, y: 450)
        circle1.position = CGPoint(x: bodyCar.position.x - 80, y: bodyCar.position.y - 50)
        circle2.position = CGPoint(x: bodyCar.position.x + 80, y: bodyCar.position.y - 50)
        
        scene.addChild(self)
        pinCircle1Spring = SKPhysicsJointPin.joint(withBodyA: bodyCar.physicsBody!, bodyB: circle1.physicsBody!, anchor: circle1.position)
        pinCircle2Spring = SKPhysicsJointPin.joint(withBodyA: bodyCar.physicsBody!, bodyB: circle2.physicsBody!, anchor: circle2.position)
        pinCircle2Spring.frictionTorque = 0.0
        // pinCircle2Spring.shouldEnableLimits = true
        //pinCircle2Spring.lowerAngleLimit = CGFloat(GLKMathDegreesToRadians(-90))
        
        pinCircle1Spring.frictionTorque = 0.0
        // pinCircle1Spring.shouldEnableLimits = true
        
        //scene.physicsWorld.add(pinCircle1Fix)
        scene.physicsWorld.add(pinCircle1Spring)
        scene.physicsWorld.add(pinCircle2Spring)
        // scene.physicsWorld.add(pinCircle2Fix)
        
        
    }
    
    
    func run (speed: CGFloat){
        //circle2.physicsBody?.velocity = CGVector(dx: speed, dy: 0)
        circle2.physicsBody?.applyForce(CGVector(dx: speed * 0.1, dy: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


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
        
        /*ground1 = SKShapeNode(rectOf: CGSize(width: self.frame.width * 2, height: 100))
         ground1.fillColor = SKColor.green
         ground1.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 100))
         ground1.physicsBody?.isDynamic = false
         ground1.physicsBody?.categoryBitMask = groundCategory
         ground1.physicsBody?.collisionBitMask = headCategory | bodyCategory | armCategory | legCategory
         ground1.position = CGPoint(x: 0, y: 0)
         addChild(ground1)
         
         ground2 = SKShapeNode(rectOf: CGSize(width: self.frame.width * 2, height: 100))
         ground2.fillColor = SKColor.green
         ground2.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 100))
         ground2.physicsBody?.isDynamic = false
         ground2.physicsBody?.categoryBitMask = groundCategory
         ground2.physicsBody?.collisionBitMask = headCategory | bodyCategory | armCategory | legCategory
         ground2.position = CGPoint(x: -self.frame.width, y: 0)
         addChild(ground2)*/
        
        createGround()
        
        
        //moveGround1 = SKAction.moveBy(x: ground1.position.x + self.frame.width * 2, y: 0, duration: 0)
        //moveGround2 = SKAction.moveBy(x: ground2.position.x + self.frame.width * 2, y: 0, duration: 0)
        
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
        /* let groundMain = SKNode()
         let groundPath = UIBezierPath() // Создаем и инициализируем объект типа UIBezierPath.
         groundPath.move(to: CGPoint.init(x: 0, y: 0))
         groundPath.addLine(to: CGPoint.init(x: 20, y: 200))
         groundPath.addLine(to: CGPoint.init(x: 400, y: 200))
         groundPath.addLine(to: CGPoint.init(x: 800, y: 220))
         groundPath.addLine(to: CGPoint(x: 800, y: 0))
         groundPath.addLine(to: CGPoint(x: 0, y: 0))
         groundPath.close()
         let groundPath2 = UIBezierPath()
         groundPath2.move(to: CGPoint(x: 800, y: 0))
         groundPath2.addLine(to: CGPoint(x: 800, y: 220))
         groundPath2.addLine(to: CGPoint.init(x: 1200, y: 500))
         groundPath2.addLine(to: CGPoint.init(x: 1600, y: 200))
         groundPath2.addLine(to: CGPoint.init(x: 1800, y: 0))
         //groundPath.addLine(to: CGPoint.init(x: 1800, y: 2000))
         //groundPath.addLine(to: CGPoint.init(x: 1810, y: 0))
         groundPath2.addLine(to: CGPoint.init(x: 800, y: 0))
         groundPath2.close()
         /*groundPath.move(to: CGPoint(x: 0, y: 0))
         groundPath.addCurve(to: CGPoint(x: 800,y: 500), controlPoint1: CGPoint(x: 400,y: 700), controlPoint2: CGPoint(x: 600, y: 600))
         groundPath.addLine(to: CGPoint(x: 1000, y: 100))
         groundPath.addLine(to: CGPoint(x: 1500, y: 0))
         groundPath.addLine(to: CGPoint(x: 0, y: 0))
         groundPath.close()*/
         
         
         
         //ground = SKShapeNode(path: groundPath.cgPath)
         ground = SKShapeNode(path: groundPath.cgPath)
         ground.lineWidth = 2
         ground.fillColor = SKColor.orange
         ground.strokeColor = SKColor.orange
         ground.position = CGPoint(x: 0, y: 0)
         
         ground.physicsBody = SKPhysicsBody(polygonFrom: groundPath.cgPath)
         ground.physicsBody?.isDynamic = false
         ground.physicsBody?.categoryBitMask = groundCategory
         ground.physicsBody?.collisionBitMask = headCategory | bodyCategory | armCategory | legCategory | carCategory | carCategory
         
         ground2 = SKShapeNode(path: groundPath2.cgPath)
         ground2.lineWidth = 2
         ground2.fillColor = SKColor.orange
         ground2.strokeColor = SKColor.orange
         ground2.position = CGPoint(x: 0, y: 0)
         
         ground2.physicsBody = SKPhysicsBody(polygonFrom: groundPath2.cgPath)
         ground2.physicsBody?.isDynamic = false
         ground2.physicsBody?.categoryBitMask = groundCategory
         ground2.physicsBody?.collisionBitMask = headCategory | bodyCategory | armCategory | legCategory | carCategory | carCategory
         
         
         groundMain.addChild(ground)
         groundMain.addChild(ground2)
         
         addChild(groundMain)
         */
        let groundPath = UIBezierPath()
        groundPath.move(to: CGPoint(x: -400, y: 0))
        groundPath.addLine(to: CGPoint(x: -400, y: 0))
        groundPath.addLine(to: CGPoint(x: 0, y: 0))
        groundPath.addCurve(to: CGPoint(x: 1800,y: 0), controlPoint1: CGPoint(x: 400,y: 300), controlPoint2: CGPoint(x: 1000, y: 0))
        groundPath.addCurve(to: CGPoint(x: 3000, y: 500), controlPoint1: CGPoint(x: 2400, y: 200), controlPoint2: CGPoint(x: 2800, y: 300))
        groundPath.addLine(to: CGPoint(x: 3000, y: 0))
        groundPath.addLine(to: CGPoint(x: 0, y: 0))
        ground = SKShapeNode(path: groundPath.cgPath)
        ground = SKShapeNode(path: groundPath.cgPath)
        ground.lineWidth = 2
        ground.fillColor = SKColor.orange
        ground.strokeColor = SKColor.orange
        ground.position = CGPoint(x: 0, y: 0)
        
        ground.physicsBody = SKPhysicsBody(edgeChainFrom: groundPath.cgPath)
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = groundCategory
        ground.physicsBody?.collisionBitMask = headCategory | bodyCategory | armCategory | legCategory | carCategory | carCategory
        
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
        /*if camCar{
         if myNewCar.bodyCar.position.x > ground1.position.x && ground1.position.x > ground2.position.x{
         ground2.run(moveGround1)
         distance = distance + 1
         if distance == 6{
         spawn = true
         }
         }
         if myNewCar.bodyCar.position.x > ground2.position.x && ground2.position.x > ground1.position.x{
         ground1.run(moveGround1)
         distance = distance + 1
         if distance == 4{
         spawn = true
         }
         }
         }
         else{
         if myNewMan.arm1.position.x > ground1.position.x && ground1.position.x > ground2.position.x{
         ground2.run(moveGround1)
         distance = distance + 1
         }
         if myNewMan.arm1.position.x > ground2.position.x && ground2.position.x > ground1.position.x{
         ground1.run(moveGround1)
         distance = distance + 1
         }
         
         }*/
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
