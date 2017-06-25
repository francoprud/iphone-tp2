//
//  Player.swift
//  MyAStarGame
//
//  Created by Franco Prudhomme on 6/24/17.
//  Copyright © 2017 Franco Prudhomme. All rights reserved.
//

import SpriteKit
import UIKit

public class Player: SKSpriteNode {
    private var life: Int = 3
    private var ammo: Int = 5
    
    private var gameMap: GameMap
    
    public var status: Status = Status.idle
    
    var pathfinder: AStarPathfinder
    var shortestPath: [Tile]?
    private var currentStepAction: SKAction?
    private var pendingMove: Tile?
    
    
    public init(size: CGSize, gameMap: GameMap) {
        self.gameMap = gameMap
        pathfinder = AStarPathfinder(gameMap: gameMap)
        let texture = SKTexture(imageNamed: "survivor-idle_rifle_0")
        super.init(texture: texture, color: .clear, size: size)
        configurePhysicsBody(size: size)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func reduceLife() {
        life -= 1
    }
    
    public func addLife() {
        life += 1
    }
    
    public func addAmo() {
        ammo += 1
    }
    
    public func reduceAmo() {
        ammo -= 1
    }
    
    public func getLife() -> Int {
        return life
    }
    
    public func getAmmo() -> Int {
        return ammo
    }

    func moveTo(to: CGPoint) {
        let toTile : Tile = gameMap.getTile(point: to)!

        if currentStepAction != nil {
            pendingMove = toTile
            return
        }
        
        // Get the current and desired tile coordinates
        let fromTile = gameMap.getTile(point: position)!
        
        // Check that we are actually moving somewhere
        if fromTile == toTile {
            print("You're already there!")
            return
        }
        
        // Must check that the desired location is walkable
        if !toTile.walkable {
            print("tile not walkable!")
            return
        }
        
        shortestPath = pathfinder.shortestPath(from: fromTile.position, to: toTile.position)
        if let shortestPath = shortestPath {
            popStepAndAnimate()
        }
    }

    func popStepAndAnimate() {
        // finished with a step; first much check if the user has changed their
        // mind about where the cat should go?
        currentStepAction = nil
        if let newMoveTargetTile = pendingMove {
            pendingMove = nil
            shortestPath = nil
            moveTo(to: newMoveTargetTile.position)
            return
        }
        
        // check if we are done moving; if so, change cat state to the resting state
        if shortestPath == nil || shortestPath!.isEmpty {
            return
        }
        
        // get the next step to move to and remove it from the shortestPath
        let nextTileCoord = shortestPath!.remove(at: 0)
        
        currentStepAction = SKAction.move(to: nextTileCoord.position, duration: 0.4)
        run(currentStepAction!, completion: {
            self.popStepAndAnimate()
        })
    }
    
    private func configurePhysicsBody(size: CGSize) {
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = PhysicsCategory.Player
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy
        self.physicsBody?.collisionBitMask = PhysicsCategory.Box
    }
}
