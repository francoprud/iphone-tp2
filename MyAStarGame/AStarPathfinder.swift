//
//  AStarAlgorithm.swift
//  MyAStarGame
//
//  Created by Franco Prudhomme on 6/25/17.
//  Copyright © 2017 Franco Prudhomme. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

public class AStarPathfinder {
    private let gameMap: GameMap
    
    public init(gameMap: GameMap) {
        self.gameMap = gameMap
    }
    
    public func shortestPath(from: CGPoint, to: CGPoint) -> [Tile]? {
        print("started A*")
        if let fromTile = gameMap.getTile(point: from) {
            if let toTile = gameMap.getTile(point: to) {
                var closedSteps: [ShortestPathStep] = []
                var openSteps: [ShortestPathStep] = []
                
                openSteps.append(ShortestPathStep(tile: fromTile))
                
                while !openSteps.isEmpty {
                    let currentStep = openSteps.remove(at: 0)
                    closedSteps.append(currentStep)
                    
                    if currentStep.tile == toTile {
                        print("found!")
                        return convertStepsToShortestPath(lastStep: currentStep)
                    }
                    
                    let adjacentTiles = gameMap.getNeighbours(tile: currentStep.tile)!.filter { $0.walkable }
                    for tile in adjacentTiles {
                        let step = ShortestPathStep(tile: tile)
                        
                        if closedSteps.contains(step) {
                            continue
                        }
                        
                        // Compute the cost from the current step to that step
                        let moveCost = costToMoveToTile(fromTile: currentStep.tile, toTile: step.tile)
                        
                        // Check if the step is already in the open list
                        if let existingIndex = openSteps.index(of: step) {
                            // already in the open list
                            
                            // retrieve the old one (which has its scores already computed)
                            let step = openSteps[existingIndex]
                            
                            // check to see if the G score for that step is lower if we use the current step to get there
                            if currentStep.gScore + moveCost < step.gScore {
                                // replace the step's existing parent with the current step
                                step.setParent(parent: currentStep, withMoveCost: moveCost)
                                
                                // Because the G score has changed, the F score may have changed too
                                // So to keep the open list ordered we have to remove the step, and re-insert it with
                                // the insert function which is preserving the list ordered by F score
                                openSteps.remove(at: existingIndex)
                                insertStep(step: step, openSteps: &openSteps)
                            }
                            
                        } else { // not in the open list, so add it
                            // Set the current step as the parent
                            step.setParent(parent: currentStep, withMoveCost: moveCost)
                            
                            // Compute the H score which is the estimated movement cost to move from that step to the desired tile coordinate
                            step.hScore = hScoreFromTile(fromTile: step.tile, toTile: toTile)
                            
                            // Add it with the function which preserves the list ordered by F score
                            insertStep(step: step, openSteps: &openSteps)
                        }
                    }
                }
            }
        }
        
        // no path found
        print("no path found")
        return nil
    }
    
    private func convertStepsToShortestPath(lastStep: ShortestPathStep) -> [Tile] {
        var shortestPath = [Tile]()
        var currentStep = lastStep
        while let parent = currentStep.parent { // if parent is nil, then it is our starting step, so don't include it
            shortestPath.insert(currentStep.tile, at: 0)
            currentStep = parent
        }
        return shortestPath
    }
    
    // Insert a path step in the open steps list
    // The open steps list is ordered from lowest to highest fScore
    private func insertStep(step: ShortestPathStep, openSteps: inout [ShortestPathStep]) {
        openSteps.append(step)
        openSteps.sort { $0.fScore <= $1.fScore }
    }
    
    // Compute the H score from a position to another (from the current position to the final desired position)
    func hScoreFromTile(fromTile: Tile, toTile: Tile) -> CGFloat {
        // Here we use the Manhattan method, which calculates the total number of steps moved horizontally and vertically to reach the final desired step from the current step, ignoring any obstacles that may be in teh way
        return abs(toTile.position.x - fromTile.position.x) + abs(toTile.position.y - fromTile.position.y)
    }
    
    func costToMoveToTile(fromTile: Tile, toTile: Tile) -> CGFloat {
        return (fromTile.position.x != toTile.position.x) && (fromTile.position.y != toTile.position.y) ? 30 : 1
    }
}
