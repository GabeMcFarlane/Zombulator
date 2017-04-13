//
//  GameScene.swift
//  Zombulator
//
//  Created by Yong Bakos on 4/5/17.
//  Copyright © 2017 Your School. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let totalPopulation = 100
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var prototypeNode : SKShapeNode?
    private var zombieCount = 0
    private var humanCount = 0
    
    override func sceneDidLoad() {

        self.lastUpdateTime = 0
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.008
        self.prototypeNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
//        if let prototypeNode = self.prototypeNode {
//            //prototypeNode.lineWidth = 1
//            
//            //prototypeNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(M_PI), duration: 1)))
////            prototypeNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
////                                              SKAction.fadeOut(withDuration: 0.5),
////                                              SKAction.removeFromParent()]))
//        }
        
        for _ in 0..<totalPopulation {
            let probability = arc4random_uniform(5)
            if probability < 3 {
                addZombieToScene()
                zombieCount += 1
            } else {
                addHumanToScene()
                humanCount += 1
            }
        }
        
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
            label.text = "zombies: \(zombieCount) humans: \(humanCount)"
        }

    }
    
    private func addZombieToScene() {
        if let zombieNode = prototypeNode?.copy() as! SKShapeNode? {
            zombieNode.position = CGPoint(x: randomX(), y: randomY(min: self.size.height * 0.25, max: self.size.height / 2))
            zombieNode.strokeColor = SKColor.green
            addChild(zombieNode)
        }
    }
    
    private func addHumanToScene() {
        if let humanNode = prototypeNode?.copy() as! SKShapeNode? {
            humanNode.position = CGPoint(x: randomX(), y: randomY(min: self.size.height / -2, max: self.size.height * -0.25))
            humanNode.strokeColor = SKColor.purple
            addChild(humanNode)
        }
    }

    
    private func randomX() -> CGFloat {
        return self.size.width / -2 + CGFloat(arc4random_uniform(UInt32(self.size.width)))
    }
    
    private func randomY(min: CGFloat, max: CGFloat) -> CGFloat {
        return min + CGFloat(arc4random_uniform(UInt32(max - min)))
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
}
