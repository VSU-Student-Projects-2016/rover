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

class Petrol: SKNode{
   
    var petrol: SKShapeNode!
    var pn: SKShapeNode!
    var count: CGFloat!
    
    init(pos: CGPoint){
        super.init()
        count = 1.0
        pn = SKShapeNode(rectOf: CGSize(width: 100, height: 10))
        pn.fillColor = SKColor.white
        
        petrol = SKShapeNode(rectOf: CGSize(width: 100, height: 10))
        petrol.fillColor = SKColor.darkGray
        
        pn.position = pos
        pn.addChild(petrol)
    }
    func addPetrol(){
        count = count + 0.3
        petrol.position = CGPoint(x: petrol.position.x + 15, y: petrol.position.y)
        if count > 1{
            count = 1.0
            petrol.position = CGPoint(x: 0, y: 0)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updatePetrol(){
        
        petrol.xScale = count!
        
    }
    
    func expenditure(){
        count = count - 0.001
        petrol.position = CGPoint(x: petrol.position.x - 0.05, y: petrol.position.y)
    }
}
