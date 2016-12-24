//
//  MenuScene.swift
//  carAndHuman
//
//  Created by xcode on 03.12.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

let buttonTexture = SKTexture(imageNamed: "play")
let btnBackTexture = SKTexture(imageNamed: "back")
let btnLevelTexture = SKTexture(imageNamed: "sawImage")
let btnSoundTexture = SKTexture(imageNamed: "volume-on")
let btnInfoTexture = SKTexture(imageNamed: "info")

let buttonPlay = SKSpriteNode(texture: buttonTexture)
let buttonBack = SKSpriteNode(texture: btnBackTexture)
let buttonSound = SKSpriteNode(texture: btnSoundTexture)
let buttonInfo = SKSpriteNode(texture: btnInfoTexture)


class MenuScene: SKScene {
    
    
        var arr:[SKSpriteNode] = [SKSpriteNode]()
    
    let lbNameGame: SKLabelNode = SKLabelNode.init(text: "Name")
    let lbLevels: SKLabelNode = SKLabelNode.init(text: "Levels")
    var NumColumns = 27
    var NumRows = 52
    var positionLevels = 0
    var positionStart = 0
    
    var containerLevels:SKNode!
    let countLevels:Int = 4
    
    var containerMenu:SKNode!
    
    let bgSound : SKAudioNode = SKAudioNode.init(fileNamed: "Whiskey")
    
    override func didMove(to view: SKView) {
        
        containerMenu = SKNode.init()
        
        lbNameGame.fontSize = 80
        lbNameGame.position.y += 100
        
        buttonPlay.position.y += 0
        buttonPlay.scale(to: CGSize.init(width: 70, height: 70))
        
        buttonInfo.position.y -= 80
        buttonInfo.scale(to: CGSize.init(width: 70, height: 70))
        
        buttonSound.position.x += 60
        buttonSound.position.y -= 150
        buttonSound.scale(to: CGSize.init(width: 50, height: 50))
        
        containerMenu.addChild(lbNameGame)
        containerMenu.addChild(buttonPlay)
        containerMenu.addChild(buttonInfo)
        containerMenu.addChild(buttonSound)
        self.addChild(containerMenu)
        
        containerLevels = SKNode.init()
        var i:Int = 0
        if (arr.count == 0){
            while i < countLevels {
                arr.append(SKSpriteNode(texture: btnLevelTexture))
                arr[i].position = CGPoint(x: positionLevels + i * 110, y: 20)
                arr[i].scale(to: CGSize(width: 100 , height: 100))
                containerLevels.addChild(arr[i])
                i+=1
            }
        }
        
        buttonBack.position.y -= 100
        buttonBack.position.x += 275
        
        lbLevels.fontSize = 80
        lbLevels.position.y += 100
        lbLevels.position.x += 275
        
        
        containerLevels.addChild(lbLevels)
        containerLevels.addChild(buttonBack)
        containerLevels.position.x = 600
        self.addChild(containerLevels)
        
        //background sound
        self.addChild(bgSound)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            
            let location = touch.location(in: self)
            
            if buttonPlay.contains(location) {
                //startGame()
                //containerLevels.run(SKAction.move(to: CGPoint(x: -275, y: 0), duration: 0.5))
                //buttonPlay.run(SKAction.move(to: CGPoint(x: -450, y: 0), duration: 0.3))

                containerLevels.run(SKAction.move(to: CGPoint(x: -275, y: 0), duration: 0.5))
                containerMenu.run(SKAction.move(to: CGPoint(x: -650, y: 0), duration: 0.3))
            }
            
            let location1 = touch.location(in: containerLevels)
            
            if buttonBack.contains(location1){
                containerLevels.run(SKAction.move(to: CGPoint(x: 600, y: 0), duration: 0.4))
                containerMenu.run(SKAction.move(to: CGPoint(x: 0, y: 0), duration: 0.5))

            }

            var i:Int = 0
            for item in arr {
                i += 1
                if item.contains(location1){
                    startGame(level: "lvlGame" + String(i))
                }
            }
        }
    }
    func startGame(level: String){
        /*let gameScene = GameScene(size: self.size, lvl: level)
        // Configure the view.
        view!.showsFPS = true
        view!.showsNodeCount = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        view!.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        gameScene.scaleMode = .aspectFill
        
        //scene.setLevel(levelName: level)
        
        view!.presentScene(gameScene)*/
        let scene = GameScene(size: self.size, lvl: level)
        //let skView = self.view as SKView!
        

        view!.ignoresSiblingOrder = true
        scene.scaleMode = .aspectFill
        
        //scene.size = (view!.bounds.size)

        view!.presentScene(scene)
    }
}
