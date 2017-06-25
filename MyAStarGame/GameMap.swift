//
//  GameMap.swift
//  MyAStarGame
//
//  Created by Franco Prudhomme on 6/25/17.
//  Copyright © 2017 Franco Prudhomme. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

public class GameMap {
    static let TILE_SIZE: CGFloat = 50
    static let MAP_MIN_WIDTH: CGFloat = -655
    static let MAP_MAX_WIDTH: CGFloat = 627
    static let MAP_MIN_HEIGHT: CGFloat = -950
    static let MAP_MAX_HEIGHT: CGFloat = 840
    
    private let scene: SKScene
    
    public var tiles: [Tile] = []
    
    public init(scene: SKScene) {
        self.scene = scene
        generate()
    }
    
    public func generate() {
        var currentX = GameMap.MAP_MIN_WIDTH + GameMap.TILE_SIZE / 2
        
        while currentX < GameMap.MAP_MAX_WIDTH {
            var currentY = GameMap.MAP_MIN_HEIGHT + GameMap.TILE_SIZE / 2
            
            while currentY < GameMap.MAP_MAX_HEIGHT {
                let midPoint = CGPoint(x: currentX, y: currentY)
                let walkable = scene.nodes(at: midPoint).filter { $0.name == "Box" }.isEmpty
                tiles.append(Tile(position: midPoint, walkable: walkable))
                currentY += GameMap.TILE_SIZE
            }
            currentX += GameMap.TILE_SIZE
        }
    }
    
    public func getTile(point: CGPoint) -> Tile? {
        return tiles.first {
            point.x >= ($0.position.x - GameMap.TILE_SIZE / 2) &&
            point.x <= ($0.position.x + GameMap.TILE_SIZE / 2) &&
            point.y >= ($0.position.y - GameMap.TILE_SIZE / 2) &&
            point.y <= ($0.position.y + GameMap.TILE_SIZE / 2)
        }
    }
    
    public func getNeighbours(tile: Tile) -> [Tile]? {
        var neighbours: [Tile] = []
        if let tile = getTile(point: CGPoint(x: tile.position.x + GameMap.TILE_SIZE, y: tile.position.y + GameMap.TILE_SIZE)) {
            neighbours.append(tile)
        }
        if let tile = getTile(point: CGPoint(x: tile.position.x - GameMap.TILE_SIZE, y: tile.position.y + GameMap.TILE_SIZE)) {
            neighbours.append(tile)
        }
        if let tile = getTile(point: CGPoint(x: tile.position.x + GameMap.TILE_SIZE, y: tile.position.y - GameMap.TILE_SIZE)) {
            neighbours.append(tile)
        }
        if let tile = getTile(point: CGPoint(x: tile.position.x - GameMap.TILE_SIZE, y: tile.position.y - GameMap.TILE_SIZE)) {
            neighbours.append(tile)
        }
        //
        if let tile = getTile(point: CGPoint(x: tile.position.x - GameMap.TILE_SIZE, y: tile.position.y)) {
            neighbours.append(tile)
        }
        if let tile = getTile(point: CGPoint(x: tile.position.x + GameMap.TILE_SIZE, y: tile.position.y)) {
            neighbours.append(tile)
        }
        if let tile = getTile(point: CGPoint(x: tile.position.x, y: tile.position.y - GameMap.TILE_SIZE)) {
            neighbours.append(tile)
        }
        if let tile = getTile(point: CGPoint(x: tile.position.x, y: tile.position.y + GameMap.TILE_SIZE)) {
            neighbours.append(tile)
        }
        
        return neighbours
    }
}
