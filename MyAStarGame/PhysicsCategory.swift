//
//  PhysicsCategory.swift
//  MyAStarGame
//
//  Created by Franco Prudhomme on 6/24/17.
//  Copyright © 2017 Franco Prudhomme. All rights reserved.
//

public struct PhysicsCategory {
    static let None       : UInt32 = 0
    static let Box        : UInt32 = 0b1
    static let Player     : UInt32 = 0b10
    static let Enemy      : UInt32 = 0b100
    static let Projectile : UInt32 = 0b1000
    static let Character  : UInt32 = 0b10000
    static let Ammo       : UInt32 = 0b100000
    static let Life       : UInt32 = 0b1000000
    static let Weapon     : UInt32 = 0b10000000
    static let All        : UInt32 = UInt32.max
}
