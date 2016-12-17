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
let btnBackTexture = SKTexture(imageNamed: "play")
let btnLevelTexture = SKTexture(imageNamed: "sawImage")

let buttonPlay = SKSpriteNode(texture: buttonTexture)
let buttonBack = SKSpriteNode(texture: btnBackTexture)
var arr:[SKSpriteNode] = [SKSpriteNode]()

var NumColumns = 27
var NumRows = 52
var positionLevels = 0
var positionStart = 0

var containerLevels:SKNode!
var countLevels:Int = 6

let bgSound : SKAudioNode = SKAudioNode.init(fileNamed: "Whiskey")

class MenuScene: SKScene {
    
    override func didMove(to view: SKView) {
        containerLevels = SKNode.init()
        
        self.addChild(buttonPlay)
        var i:Int = 0
        while i < countLevels {
            arr.append(SKSpriteNode(texture: btnLevelTexture))
            arr[i].position = CGPoint(x: positionLevels + i * 110, y: 20)
            arr[i].scale(to: CGSize(width: 100 , height: 100))
            containerLevels.addChild(arr[i])
            i+=1
        }
        
        buttonBack.position.y -= 100
        buttonBack.position.x += 275
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
                containerLevels.run(SKAction.move(to: CGPoint(x: -275, y: 0), duration: 0.5))
                buttonPlay.run(SKAction.move(to: CGPoint(x: -450, y: 0), duration: 0.3))
            }
            
            let location1 = touch.location(in: containerLevels)
            
            if buttonBack.contains(location1){
                containerLevels.run(SKAction.move(to: CGPoint(x: 600, y: 0), duration: 0.4))
                buttonPlay.run(SKAction.move(to: CGPoint(x: 0, y: 0), duration: 0.5))

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
        let gameScene = GameScene(size: self.size, lvl: level)
        // Configure the view.
        view!.showsFPS = true
        view!.showsNodeCount = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        view!.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        gameScene.scaleMode = .aspectFill
        
        //scene.setLevel(levelName: level)
        
        view!.presentScene(gameScene)
    }
}
