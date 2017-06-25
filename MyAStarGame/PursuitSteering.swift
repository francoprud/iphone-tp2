//
//  PursuitSteering.swift
//  MyAStarGame
//
//  Created by Franco Prudhomme on 6/29/17.
//  Copyright © 2017 Franco Prudhomme. All rights reserved.
//

import SpriteKit
import GameplayKit

class PursuitSteering : SteeringBehavior {
    public var finishMoving = true
    
    func move(point: CGPoint) -> CGPoint {
        return point
    }
    
    func setFinishedMoving(bool: Bool) {
        finishMoving = bool
    }
    
    func finishedMoving() -> Bool {
        return finishMoving
    }
}
