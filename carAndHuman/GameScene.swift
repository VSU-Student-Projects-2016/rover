//
//  GameScene.swift
//  play
//
//  Created by Ivan on 21.10.16.
//  Copyright © 2016 Ivan. All rights reserved.
//
import SpriteKit
import GameplayKit
import Foundation

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
let rockCategory: UInt32 = 1 << 17
let platformCategory: UInt32 = 1 << 18
let petrolCategory: UInt32 = 1 << 19
let bgGameSound : SKAudioNode = SKAudioNode.init(fileNamed: "Sun_Spots")

let btnMenuTexture = SKTexture(imageNamed: "menu")
let btnMenu = SKSpriteNode(texture: btnMenuTexture)

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var myNewMan: Human!
    var myNewCar: Car!
    var newSaw: Saw!
    var newSpear: Spear!
    var newPlatform: Platform!
    var rocks = [Rock]()
    var cam: SKCameraNode!
    var ground1: SKShapeNode!
    var ground2: SKShapeNode!
    var ground: SKShapeNode!
    var moveGround1: SKAction!
    var moveGround2: SKAction!
    var pipe: SKShapeNode!
    var petrol: Petrol!
    var score: SKLabelNode!
    var speedometer: SKShapeNode!
    var arrow: SKShapeNode!
    var wheelCar: SKPhysicsBody!
    var accelerator: SKShapeNode!
    var brakePedal: SKShapeNode!
    var gameover: UIView?
    var replayButton: UIButton!
    
    var xyGround = [CGPoint]()
    var isBrake = false
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
    
    var brakeSpeed: CGFloat = 0
    var scoreCount = 0
    var timer: Int = 0
    var timers = [Int]()
    var timerLast = 0
    let zero: CGFloat = 0.0
    var lvlName:String = ""
    


    init(size: CGSize, lvl: String){
        super.init(size: size)
        lvlName = lvl
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        

        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0)
        self.physicsWorld.contactDelegate = self
        self.backgroundColor = SKColor.blue
        
        gameover = UIView()
        
        replayButton = UIButton(frame: CGRect(x:  self.frame.midX - 250, y: self.frame.midY, width: 100.0, height: 100.0))
        replayButton.setTitle("Replay", for: .normal)
        replayButton.setTitleColor(.green, for: .normal)
        replayButton.titleLabel!.font = UIFont(name: "PressStart2P", size: 14)
        replayButton.addTarget(self, action: #selector(self.replayButtonPressed(_:)), for: .touchUpInside)
        
        let wait = SKAction.wait(forDuration: 0.5)
        let block = SKAction.run({() in
            self.timer = self.timer + 1
        })
        
        run(SKAction.repeatForever(SKAction.sequence([wait, block])))
        
        myNewCar = Car()
        myNewCar.add(to: self)
        
        wheelCar = myNewCar.circle1.physicsBody
        
        
        cam = SKCameraNode()
        self.camera = cam
        cam.xScale = 2
        cam.yScale = 2
        addChild(cam)
        cam.position = myNewCar.bodyCar.position
        
        petrol = Petrol.init(pos: CGPoint(x: -320, y: 180))
        cam.addChild(petrol.pn)
        
        createSpeedometer()
        
        createPedal()
        
        score = SKLabelNode(text: "0")
        score.fontSize = 50
        //score.position = CGPoint(x: cam.position.x +  100, y: cam.position.y +  100)
        score.position = CGPoint(x: 270, y: 180)
        createLevel()
        cam.addChild(score)
        
        //background sound
        self.addChild(bgGameSound)
        
        btnMenu.scale(to: CGSize(width: 60, height: 60))
        btnMenu.position = CGPoint(x: -320, y: 200)
        cam.addChild(btnMenu)
        
    }
    
    func createSpear(xf: CGFloat){
        self.physicsWorld.enumerateBodies(alongRayStart: CGPoint(x: xf, y: 800), end: CGPoint(x: xf, y: 0)) { (b:SKPhysicsBody, position: CGPoint, vector: CGVector, boolPointer: UnsafeMutablePointer<ObjCBool>) in
            if b.categoryBitMask == groundCategory{
                self.newSpear = Spear(pos: position)
                self.newSpear.add(to: self)
            }
        } 
    }
    
    func resetScene(){
        reset = true
        isSpear = false
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
        wheelCar = myNewCar.circle1.physicsBody
        let resetCam = SKAction.run({() in
                self.reset = false
        })
    
            scoreCount = 0
            score.text = "0"
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

        
        cam.run(SKAction.sequence([SKAction.move(to: myNewCar.circle2.position, duration: 5), resetCam]))
    }
    
    func createRocks(){
        var step: Int!
        step = 150
        rocks.append(Rock.init(pos: CGPoint(x: 3500 + step, y: 150)))
        rocks.append(Rock.init(pos: CGPoint(x: 3500 + (step * 2), y: 200)))
        rocks.append(Rock.init(pos: CGPoint(x: 3500 + (step * 3), y: 200)))
        rocks.append(Rock.init(pos: CGPoint(x: 3500 + (step * 4), y: 200)))
        rocks.append(Rock.init(pos: CGPoint(x: 3500 + (step * 5), y: 200)))
        rocks.append(Rock.init(pos: CGPoint(x: 3500 + (step * 6), y: 200)))
        
        for rock: Rock in rocks{
            rock.add(to: self)
        }
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
        ground.physicsBody?.friction = 100
        addChild(ground)
        
        ground2 = SKShapeNode(rectOf: CGSize(width: 2000, height: 100))
        ground2.fillColor = SKColor.green
        ground2.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 2000, height: 100))
        ground2.physicsBody?.isDynamic = false
        ground2.physicsBody?.categoryBitMask = groundCategory
         ground.physicsBody?.collisionBitMask = headCategory | bodyCategory | arm1Category | leg1Category | carCategory | wheelCategory | springCategory
        ground2.position = CGPoint(x: 2500, y: 400)
        ground2.physicsBody?.friction = 100
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
    
    func createSpeedometer()
    {
        
        speedometer = SKShapeNode(circleOfRadius: 40)
        speedometer.fillColor = SKColor.black
        
        arrow = SKShapeNode(rectOf: CGSize(width: 10, height: 50))
        arrow.fillColor = SKColor.green
        arrow.position = CGPoint(x: 0, y: 0)
        
        speedometer.addChild(arrow)
        speedometer.position = CGPoint(x: -300, y: -200)
        cam.addChild(speedometer)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches {
            let location = touch.location(in: cam)
            if accelerator.contains(location) {
                isTouch = true
            }
            
            if brakePedal.contains(location){
                isBrake = true
            }
            
            if btnMenu.contains(location) {
                backMenu()
            }
        }
    }
    
    func backMenu(){
        let menuScene = MenuScene(size: self.size)
        // Configure the view.
        view!.showsFPS = true
        view!.showsNodeCount = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        view!.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        menuScene.scaleMode = .aspectFill
        
        //scene.setLevel(levelName: level)
        
        view!.presentScene(menuScene)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouch = false
        isBrake = false
    }
    
    func replayButtonPressed(_ sender: UIButton!){
        gameover!.removeFromSuperview()
        gameover = nil
        
        let scene = GameScene(size: self.size,lvl: self.lvlName)
        let skView = self.view as SKView!
        skView?.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        scene.size = (skView?.bounds.size)!
        skView?.presentScene(scene)
    }
    
    func gameOver(){
        gameover?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        gameover?.sizeThatFits(self.frame.size)
        //exitButton.frame.origin = CGPoint(x: self.frame.midX + 50, y: self.frame.midY + 100)
        replayButton.frame.origin = CGPoint(x: self.view!.frame.width/2 - 50, y: self.view!.frame.height/2 - 50)
        //gameover?.addSubview(exitButton)
        gameover?.addSubview(replayButton)
        gameover?.frame = self.view!.frame
        self.view?.addSubview(gameover!)
    }
    
    override func update(_ currentTime: TimeInterval) {
        petrol.updatePetrol()
        if petrol.count < 0{
            gameOver()
        }
        arrow.zRotation = wheelCar.angularVelocity / 20
        if !reset{
            if camCar{
                cam.position = myNewCar.circle2.position
            }
            else{
                cam.position = myNewMan.arm1.position
            }
        }

        if timerLast > 0 && timer - timerLast > 4 || timer > 60{
            resetScene()
        }
        
        if isTouch && notContact{
            petrol.expenditure()
            speedCar += 50
            myNewCar.run(speed: speedCar)
        }
        else{
            if isBrake && notContact{
                if isBrake{
                    petrol.expenditure()
                    brakeSpeed += 50
                    myNewCar.run(speed: -brakeSpeed)
                }
            }
            else{
                if (myNewCar.circle1.physicsBody?.angularVelocity)! > 0 && notContact{
                    speedCar = 0
                    brakeSpeed = 0
                    myNewCar.run(speed: 0)
                }
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
    
    func createPedal(){
        accelerator = SKShapeNode(rectOf: CGSize(width: 60, height: 80))
        accelerator.fillColor = SKColor.purple
        accelerator.position = CGPoint(x: 300, y: -200)
        accelerator.zPosition = 20
        
        brakePedal = SKShapeNode(rectOf: CGSize(width: 60, height: 80))
        brakePedal.fillColor = SKColor.brown
        brakePedal.position = CGPoint(x: 200, y: -200)
        brakePedal.zPosition = 20
        
        cam.addChild(accelerator)
        cam.addChild(brakePedal)
        
    }
    
    func spawnSpike(){
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
    
    func createPetrol(pos: CGPoint){
        let petTexture = SKTexture(imageNamed: "gasoline")
        let pet = SKSpriteNode(texture: petTexture)
        pet.physicsBody = SKPhysicsBody(texture: petTexture, size: petTexture.size())
        pet.physicsBody?.categoryBitMask = petrolCategory
        pet.physicsBody?.isDynamic = false
        pet.physicsBody?.contactTestBitMask = carCategory | bodyCategory | arm1Category | arm2Category | leg1Category | leg2Category | headCategory
        pet.position = pos
        addChild(pet)
    }
    
    func createGroundxml(){
        let groundPath = UIBezierPath()
        groundPath.move(to: xyGround[0])
        xyGround.remove(at: 0)
        for point in xyGround{
            groundPath.addLine(to: point)
        }
        groundPath.close()
        
        ground = SKShapeNode(path: groundPath.cgPath)
        ground.lineWidth = 2
        ground.fillColor = SKColor.orange
        ground.strokeColor = SKColor.orange
        ground.position = CGPoint(x: 0, y: 0)
        ground.physicsBody = SKPhysicsBody(edgeChainFrom: groundPath.cgPath)
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = groundCategory
        ground.physicsBody?.collisionBitMask = headCategory | bodyCategory | arm1Category | leg1Category | carCategory | wheelCategory | springCategory
        ground.physicsBody?.friction = 100
        addChild(ground)

    }
    
    func createLevel(){
        let opt = AEXMLOptions()
        guard
            let xmlPath = Bundle.main.path(forResource: lvlName, ofType: "xml"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: xmlPath))
        else {return}
        
        do {
            let xmlDoc = try AEXMLDocument(xml: data, options: opt)
            print(xmlDoc.xml)
            for elem in xmlDoc.root["elements"].children{
                let ch = elem.name
                switch ch {
                case "saw":
                    let x = elem.attributes["X"]
                    let xf = CGFloat(NumberFormatter().number(from: x!)!)
                    let y = elem.attributes["Y"]
                    let yf = CGFloat(NumberFormatter().number(from: y!)!)
                    let newSaw1 = Saw(pos: CGPoint(x: xf, y: yf))
                    newSaw1.add(to: self)
                    break
                case "spear":
                    let x = elem.attributes["X"]
                    let xf = CGFloat(NumberFormatter().number(from: x!)!)
                    createSpear(xf: xf)
                    break
                case "petrol":
                    let x = elem.attributes["X"]
                    let xf = CGFloat(NumberFormatter().number(from: x!)!)
                    let y = elem.attributes["Y"]
                    let yf = CGFloat(NumberFormatter().number(from: y!)!)
                    let point  = CGPoint(x: xf, y: yf)
                    createPetrol(pos: point)
                    break
                case "diamond":
                    let x = elem.attributes["X"]
                    let xf = CGFloat(NumberFormatter().number(from: x!)!)
                    let y = elem.attributes["Y"]
                    let yf = CGFloat(NumberFormatter().number(from: y!)!)
                    let point = CGPoint(x: xf, y: yf)
                    spawnDiamonds(pos: point)
                    break
                case "pipe":
                    let x = elem.attributes["X"]
                    let xf = CGFloat(NumberFormatter().number(from: x!)!)
                    let y = elem.attributes["Y"]
                    let yf = CGFloat(NumberFormatter().number(from: y!)!)
                    let point = CGPoint(x: xf, y: yf)
                    spawnPipe(position: point)
                default:
                    break
                }
            }
            for elem in xmlDoc.root["ground"].children{
                let x = elem.attributes["X"]
                let xf = CGFloat(NumberFormatter().number(from: x!)!)
                let y = elem.attributes["Y"]
                let yf = CGFloat(NumberFormatter().number(from: y!)!)
                let point = CGPoint(x: xf, y: yf)
                xyGround.append(point)
            }
            createGroundxml()
        }
        catch{
            print("error")
        }
    }
    
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == petrolCategory || contact.bodyB.categoryBitMask == petrolCategory{
            if contact.bodyA.categoryBitMask == petrolCategory{
                contact.bodyA.node?.removeFromParent()
            }
            if contact.bodyB.categoryBitMask == petrolCategory{
                contact.bodyB.node?.removeFromParent()
            }
            petrol.addPetrol()
        }

        
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
            if contact.collisionImpulse > 1000{
                //let impulse = speedCar
                //print(impulse)
                //print(contact.collisionImpulse)
                notContact = false
                speedCar = 0
                myNewCar.run(speed: speedCar)
                myNewCar.bodyCar.physicsBody?.applyImpulse(CGVector(dx: 50, dy: 100))
            
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
                print("saw")
            }
        }
        
    }
}
