//
//  ShortestPathStep.swift
//  MyAStarGame
//
//  Created by Franco Prudhomme on 6/26/17.
//  Copyright © 2017 Franco Prudhomme. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

/** A single step on the computed path; used by the A* pathfinding algorithm */
public class ShortestPathStep: Hashable {
    let tile: Tile
    var parent: ShortestPathStep?
    
    var gScore: CGFloat = 0
    var hScore: CGFloat = 0
    var fScore: CGFloat {
        return gScore + hScore
    }
    
    public var hashValue: Int {
        get {
            return tile.hashValue
        }
    }
    
    init(tile: Tile) {
        self.tile = tile
    }
    
    func setParent(parent: ShortestPathStep, withMoveCost moveCost: CGFloat) {
        // The G score is equal to the parent G score + the cost to move from the parent to it
        self.parent = parent
        self.gScore = parent.gScore + moveCost
    }
}

// Equatable
public func ==(left: ShortestPathStep, right: ShortestPathStep) -> Bool {
    return left.hashValue == right.hashValue
}
