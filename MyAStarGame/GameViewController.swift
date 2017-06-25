//
//  GameViewController.swift
//  MyAStarGame
//
//  Created by Franco Prudhomme on 6/23/17.
//  Copyright © 2017 Franco Prudhomme. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

public class GameViewController: UIViewController {
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        let scene = GameScene(fileNamed: "GameScene")
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene?.scaleMode = .resizeFill
        skView.presentScene(scene)
    }
    
    override public var prefersStatusBarHidden: Bool {
        return true
    }
}
