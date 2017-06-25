//
//  Tile.swift
//  MyAStarGame
//
//  Created by Franco Prudhomme on 6/25/17.
//  Copyright © 2017 Franco Prudhomme. All rights reserved.
//

import Foundation
import UIKit

public class Tile: Hashable {
    public var position: CGPoint
    public var walkable: Bool
    
    public init(position: CGPoint, walkable: Bool) {
        self.position = position
        self.walkable = walkable
    }
    
    public var hashValue : Int {
        get {
            return "\(self.position.x),\(self.position.y)".hashValue
        }
    }
}

// Equatable
public func ==(left: Tile, right: Tile) -> Bool {
    return left.hashValue == right.hashValue
}
