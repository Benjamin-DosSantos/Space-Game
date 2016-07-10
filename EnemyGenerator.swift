//
//  EnemyGenerator.swift
//  Space Flight
//
//  Created by Benjamin DosSantos Jr. on 6/28/16.
//  Copyright © 2016 Benjamin DosSantos Jr. All rights reserved.
//

import Foundation;
import SpriteKit;

let scene = GameScene();

var spriteArray: [SKSpriteNode] = [];

func flowToScene(gameScene: SKScene, position: CGPoint){
    let moveDown = SKAction.moveTo(position, duration: 1.5);
    
    for node in spriteArray{
        node.runAction(moveDown);
    }
}

func generateEnemy(gameScene: SKScene){
    let enemy = SKSpriteNode(imageNamed: "Enemy");
    enemy.color = UIColor.redColor();
    enemy.position = CGPoint(x: 0, y: 1000);
    enemy.xScale = 0.1;
    enemy.yScale = 0.1;
    
    enemy.physicsBody = SKPhysicsBody(rectangleOfSize: enemy.frame.size);
    enemy.physicsBody!.usesPreciseCollisionDetection = true;
    enemy.physicsBody?.affectedByGravity = false;
    enemy.physicsBody?.allowsRotation = false;
    enemy.physicsBody?.categoryBitMask = scene.enemyCategory;
    
    let moveRight = SKAction.moveByX(50, y:0, duration:1.0);
    let moveleft = SKAction.moveByX(-50, y:0, duration:1.0);
    let sequence = SKAction.sequence([moveRight, moveleft]);
    
    enemy.runAction(SKAction.repeatActionForever(sequence));
    
    activeEnemies = activeEnemies + 1;
    
    spriteArray.append(enemy);
    gameScene.addChild(enemy);
}// End of generateEnemy function

func generateEnemies(gameScene: SKScene){
    let numberOfEnemies = arc4random_uniform(7) + 1;
    var xBuffer = 0;
    
    for _ in 0...numberOfEnemies {
        generateEnemy(gameScene);
        xBuffer = xBuffer + 50;
    }// End of for the number of enemies to be generated
}// End of generate Enemies function

