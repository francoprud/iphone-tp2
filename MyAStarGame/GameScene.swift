//
//  GameScene.swift
//  MyAStarGame
//
//  Created by Franco Prudhomme on 6/23/17.
//  Copyright © 2017 Franco Prudhomme. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    private let ammoLabel = SKLabelNode(fontNamed: "Arial")
    private let lifeLabel = SKLabelNode(fontNamed: "Arial")
    
    private lazy var gameMap : GameMap = GameMap(scene: self)
    
    private lazy var player : Player = Player(size: ObjectDimension.PlayerSize, gameMap: GameMap(scene: self))
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        size = view.frame.size
        backgroundColor = .gray
        physicsWorld.gravity = CGVector.zero
        physicsWorld.contactDelegate = self
        addPlayer()
        addCamera()
        addLabels()
        addAssets()
        addEnemies()
    }
    
    private func addPlayer() {
        player.position = CGPoint(x: 0, y: 0)
        player.zPosition = 20
        addChild(player)
    }
    
    private func addCamera() {
        let mainCamera = SKCameraNode()
        camera = mainCamera
        addChild(mainCamera)
    }
    
    private func addLabels() {
        lifeLabel.text = String(format: "Lifes: %d", player.getLife())
        lifeLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        lifeLabel.zPosition = 1000
        lifeLabel.fontSize = 24
        lifeLabel.position = CGPoint(x: -size.width / 2 + lifeLabel.frame.width - 30, y: size.height / 2 - lifeLabel.frame.height - 10)
        camera?.addChild(lifeLabel)
        
        ammoLabel.text = String(format: "Ammo: %d", player.getAmmo())
        ammoLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        ammoLabel.zPosition = 1000
        ammoLabel.fontSize = 24
        ammoLabel.position = CGPoint(x: -size.width / 2 + lifeLabel.frame.width - 30, y: size.height / 2 - lifeLabel.frame.height - 30)
        camera?.addChild(ammoLabel)
    }
    
    private func addAssets() {
        children.filter { $0.name == "Box" }
            .forEach {
                $0.physicsBody = SKPhysicsBody(rectangleOf: $0.frame.size)
                $0.physicsBody?.isDynamic = false
                $0.physicsBody?.categoryBitMask = PhysicsCategory.Box
                $0.physicsBody?.contactTestBitMask = PhysicsCategory.Player | PhysicsCategory.Enemy
                $0.physicsBody?.collisionBitMask = PhysicsCategory.None
        }
        
        children.filter { $0.name == "Ammo" }
            .forEach {
                $0.physicsBody = SKPhysicsBody(rectangleOf: $0.frame.size)
                $0.physicsBody?.isDynamic = false
                $0.physicsBody?.categoryBitMask = PhysicsCategory.Ammo
                $0.physicsBody?.contactTestBitMask = PhysicsCategory.Player
                $0.physicsBody?.collisionBitMask = PhysicsCategory.None
        }
        
        children.filter { $0.name == "Life" }
            .forEach {
                $0.physicsBody = SKPhysicsBody(rectangleOf: $0.frame.size)
                $0.physicsBody?.isDynamic = false
                $0.physicsBody?.categoryBitMask = PhysicsCategory.Life
                $0.physicsBody?.contactTestBitMask = PhysicsCategory.Player
                $0.physicsBody?.collisionBitMask = PhysicsCategory.None
        }
    }
    
    private func addEnemies() {
        addEnemy(position: CGPoint(x: 495, y: 215))
        addEnemy(position: CGPoint(x: -544, y: 75))
        addEnemy(position: CGPoint(x: -500, y: -600))
        addEnemy(position: CGPoint(x: -182, y: -861))
        addEnemy(position: CGPoint(x: -537, y: -861))
        addEnemy(position: CGPoint(x: 386, y: -801))
        addEnemy(position: CGPoint(x: 435, y: -345))
        addEnemy(position: CGPoint(x: -537, y: -861))
        addEnemy(position: CGPoint(x: 317, y: 714))
//        
//        addEnemy(position: CGPoint(x: 6, y: 145))
    }
    
    private func addEnemy(position: CGPoint) {
        let enemy = Enemy(size: ObjectDimension.EnemySize, gameMap: gameMap)
        enemy.color = .clear
        enemy.position = position
        enemy.zPosition = 20
        addChild(enemy)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        let allNodes = nodes(at: touchLocation).filter { $0.name != "Ammo" && $0.name != "Life" }
        allNodes.forEach {
            if $0.name == "Enemy" {
                if player.getAmmo() > 0 {
                    shootBullet(touchLocation: touchLocation)
                }
            } else if $0.name == "Box" {
                // DO NOTHING
            }
        }
        if allNodes.isEmpty {
            player.moveTo(to: touchLocation)
        }
        
    }
    
    private func shootBullet(touchLocation: CGPoint) {
        player.reduceAmo()
        run(SKAction.playSoundFileNamed("pew-pew-lei.caf", waitForCompletion: false))
        
        let projectile = SKSpriteNode(imageNamed: "projectile")
        projectile.position = player.position
        projectile.zPosition = 20
        
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
        projectile.physicsBody?.isDynamic = true
        projectile.physicsBody?.categoryBitMask = PhysicsCategory.Projectile
        projectile.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy | PhysicsCategory.Box
        projectile.physicsBody?.collisionBitMask = PhysicsCategory.None
        projectile.physicsBody?.usesPreciseCollisionDetection = true
        
        // 3 - Determine offset of location to projectile
        let offset = touchLocation - projectile.position
        
        // 5 - OK to add now - you've double checked position
        addChild(projectile)
        
        // 6 - Get the direction of where to shoot
        let direction = offset.normalized()
        
        // 7 - Make it shoot far enough to be guaranteed off screen
        let shootAmount = direction * 1000
        
        // 8 - Add the shoot amount to the current position
        let realDest = shootAmount + projectile.position
        
        // 9 - Create the actions
        let actionMove = SKAction.move(to: realDest, duration: 2.0)
        let actionMoveDone = SKAction.removeFromParent()
        projectile.run(SKAction.sequence([actionMove, actionMoveDone]))
    }

    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.Enemy != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Projectile != 0)) {
            if let enemy = firstBody.node as? SKSpriteNode, let
                projectile = secondBody.node as? SKSpriteNode {
                projectileDidCollideWithEnemy(projectile: projectile, enemy: enemy)
            }
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.Player != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Ammo != 0)) {
            if let ammo = secondBody.node as? SKSpriteNode {
                player.addAmo()
                ammo.removeFromParent()
            }
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.Player != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Enemy != 0)) {
            if let enemy = secondBody.node as? Enemy {
                if enemy.canAttack() {
                    player.reduceLife()
                    enemy.lastAttackTime = CFAbsoluteTimeGetCurrent()
                }
            }
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.Player != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Life != 0)) {
            if let life = secondBody.node as? SKSpriteNode {
                player.addLife()
                life.removeFromParent()
            }
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.Box != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Projectile != 0)) {
            if let projectile = secondBody.node as? SKSpriteNode {
                projectile.removeFromParent()
            }
        }
    }
    
    // Called after the scene has finished all of the steps required to process animations
    public override func didFinishUpdate() {
        super.didFinishUpdate()
        manageCamera()
    }
    
    private func manageCamera() {
        let playerF = player.calculateAccumulatedFrame()
        camera?.position = CGPoint(x: playerF.origin.x + playerF.width / 2, y: playerF.origin.y + playerF.height / 2)
        ammoLabel.text = String(format: "Ammo: %d", player.getAmmo())
        lifeLabel.text = String(format: "Lifes: %d", player.getLife())
    }
    
    func projectileDidCollideWithEnemy(projectile: SKSpriteNode, enemy: SKSpriteNode) {
        projectile.removeFromParent()
        enemy.removeFromParent()
    }
    
    override func update(_ currentTime: TimeInterval) {
        if player.getLife() <= 0 {
            let reveal = SKTransition.flipHorizontal(withDuration: 5)
            let gameOverScene = GameOverScene(size: self.size, won: false)
            self.view?.presentScene(gameOverScene, transition: reveal)
        }
        
        let enemies = children.filter { $0.name == "Enemy" }
        
        if enemies.count == 0 {
            let reveal = SKTransition.flipHorizontal(withDuration: 5)
            let gameOverScene = GameOverScene(size: self.size, won: true)
            self.view?.presentScene(gameOverScene, transition: reveal)
        }
        
        enemies.forEach {
            if let enemy = $0 as? Enemy {
                if let enemy = $0 as? Enemy {
                    var status : EnemyStatus
                    if distanceTo(point1: enemy.position, point2: player.position) < GameMap.TILE_SIZE * 2 {
                        // Perseguir
                        status = EnemyStatus.chasing
                    } else {
                        // Patrullando
                        status = EnemyStatus.patrolling
                    }
                    enemy.moveWithSteering(playerPosition: player.position, enemyStatus: status)
                }
            }
        }
    }
    
    public func distanceTo(point1: CGPoint, point2: CGPoint) -> CGFloat {
        return sqrt(pow(point1.x - point2.x, 2) + pow(point1.y - point2.y, 2))
    }
}
