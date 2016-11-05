//
//  Heart.swift
//  carAndHuman
//
//  Created by xcode on 05.11.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import Foundation
import SpriteKit
import GameKit

class Heart: SKNode{
   
    var heart: SKSpriteNode!
    var count: Int!
    
    init(pos: CGPoint){
        super.init()
        count = 3
        let heartTexture = SKTexture(imageNamed: "heartImage")
        
        heart = SKSpriteNode(texture: heartTexture)
        heart.position = pos
        heart.zPosition = 20
        heart.scale(to: CGSize(width: 100, height: 100))

    }
    func add(to scene: SKScene){
        scene.addChild(heart)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
