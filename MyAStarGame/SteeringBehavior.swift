//
//  SteeringBehavior.swift
//  MyAStarGame
//
//  Created by Franco Prudhomme on 6/29/17.
//  Copyright © 2017 Franco Prudhomme. All rights reserved.
//

import SpriteKit
import GameplayKit

protocol SteeringBehavior {
    func move(point: CGPoint) -> CGPoint
    
    func finishedMoving() -> Bool
    
    func setFinishedMoving(bool: Bool)
}
