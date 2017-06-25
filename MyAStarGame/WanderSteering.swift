//
//  WanderSteering.swift
//  MyAStarGame
//
//  Created by Franco Prudhomme on 6/29/17.
//  Copyright © 2017 Franco Prudhomme. All rights reserved.
//

import SpriteKit
import GameplayKit

class WanderSteering : SteeringBehavior {
    public var finishMoving = true
    
    func move(point: CGPoint) -> CGPoint {
        var randomX : CGFloat = 0
        var randomY : CGFloat = 0
        
        repeat {
            randomX = point.x + CGFloat((Int(arc4random_uniform(60)) - Int(arc4random_uniform(60))))
        } while (randomX <= GameMap.MAP_MIN_WIDTH) || (randomX >= GameMap.MAP_MAX_WIDTH)
        
        repeat {
            randomY = point.y + CGFloat((Int(arc4random_uniform(60)) - Int(arc4random_uniform(60))))
        } while (randomY <= GameMap.MAP_MIN_HEIGHT) || (randomY >= GameMap.MAP_MAX_HEIGHT)
        
        return CGPoint(x: randomX, y: randomY)
    }
    
    func finishedMoving() -> Bool {
        return finishMoving
    }
    
    func setFinishedMoving(bool: Bool) {
        finishMoving = bool
    }
}
