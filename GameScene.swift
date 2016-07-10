//
//  GameScene.swift
//  Ball Fall Clone
//
//  Created by Benjamin DosSantos Jr. on 6/19/16.
//  Copyright (c) 2016 Benjamin DosSantos Jr. All rights reserved.
//

import SpriteKit
import CoreMotion

public var activeEnemies: Int = 0;

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let player = SKSpriteNode(imageNamed:"Spaceship");
    
    let score = SKLabelNode(fontNamed:"Copperplate");
    let level = SKLabelNode(fontNamed:"Copperplate");
    
    var currentScore: Int = 0;
    var currentLevel: Int = 1;
    let amountWon = 10;
    
    var motionManager = CMMotionManager();
    var destX: CGFloat  = 0.0;
    
    let leftArrow = UIImage(named: "leftArrow") as UIImage?;
    let rightArrow = UIImage(named: "rightArrow") as UIImage?;
    let fireButtonImage = UIImage(named: "fireButton") as UIImage?;
    
    let leftButton = UIButton(type: UIButtonType.Custom) as UIButton;
    let rightButton = UIButton(type: UIButtonType.Custom) as UIButton;
    let fireButton = UIButton(type: UIButtonType.Custom) as UIButton;
    
    var rightTimer: NSTimer!;
    var leftTimer: NSTimer!;
    var fireTimer: NSTimer!;
    
    let playerMoveAmount: CGFloat = 20;
    
    let missileCategory: UInt32 = 0x1 << 0;
    let enemyCategory: UInt32 = 0x1 << 1;
    let topCategory: UInt32 = 0x1 << 2;
    
    /*
        Name:
        Parameters:
        Return(s):
        Description:
    */
    override func didMoveToView(view: SKView) {
        physicsWorld.contactDelegate = self
        setupBorder();
        setupScoreLabel();
        setupLevelLabel();
        createPlayer(CGPoint(x:CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame) - 200));
        setupButtons();
        generateEnemies(self);
        flowToScene(self, position: CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame)));
    }// End of didMoveToView function
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
    }// End of touchesBegan function
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }// End of update function
    
    func createPlayer(location: CGPoint){
        player.xScale = 0.1
        player.yScale = 0.1
        player.position = location;
       
        self.addChild(player)
    }// End of createPlayer function
    
    func setupScoreLabel(){
        score.color = UIColor.blackColor();
        score.fontSize = 30
        score.position = CGPoint(x:CGRectGetMidX(self.frame) + 100, y:CGRectGetMaxY(self.frame) - 50)
        score.text = "Score: " + String(currentScore);
        self.addChild(score)
    }// End of setupScoreLable function
    
    func incrementScore(){
        currentScore = currentScore + amountWon;
        score.text = "Score: " + String(currentScore);
    }
    
    func setupLevelLabel(){
        level.color = UIColor.blackColor();
        level.fontSize = 30
        level.position = CGPoint(x: CGRectGetMidX(self.frame) - 130, y:CGRectGetMaxY(self.frame) - 50)
        level.text = "Level: " + String(currentLevel);
        self.addChild(level)
    }// End of setupLevelLevel function
    
    func setupBorder(){
        let topRect = CGRect(x: frame.origin.x, y: frame.height + 100  , width: frame.size.width, height: 1)
        let top = SKNode()
        top.physicsBody = SKPhysicsBody(edgeLoopFromRect: topRect)
        top.physicsBody?.categoryBitMask = topCategory;
        addChild(top);
        
        let leftRect = CGRect(x: frame.origin.x, y: frame.height  , width: 1, height: frame.height)
        let left = SKNode()
        left.physicsBody = SKPhysicsBody(edgeLoopFromRect: leftRect)
        addChild(left);
        
        let rightRect = CGRect(x: frame.width, y: frame.height, width: 1, height: frame.height)
        let right = SKNode()
        right.physicsBody = SKPhysicsBody(edgeLoopFromRect: rightRect)
        addChild(right);
    }
    
    func setupButtons(){
        setupLeftButton();
        setupRightButton();
        setupFireButton();
    }// End of setupButton functon
    
    func setupLeftButton(){
        leftButton.addTarget(self, action: #selector(leftButtonDown), forControlEvents: .TouchDown)
        leftButton.addTarget(self, action: #selector(leftButtonUp), forControlEvents: [.TouchUpInside, .TouchUpOutside])
        
        leftButton.frame = CGRectMake(CGRectGetMinX(self.frame) + 10, CGRectGetMaxY(self.frame) - 150, 100, 100)
        leftButton.setImage(leftArrow, forState: .Normal)
        self.view!.addSubview(leftButton)
    }// End o fsetupLeftButton function
    
    func setupRightButton(){
        rightButton.addTarget(self, action: #selector(rightButtonDown), forControlEvents: .TouchDown)
        rightButton.addTarget(self, action: #selector(rightButtonUp), forControlEvents: [.TouchUpInside, .TouchUpOutside])
        
        rightButton.frame = CGRectMake(CGRectGetMinX(self.frame) + 120, CGRectGetMaxY(self.frame) - 150, 100, 100)
        rightButton.setImage(rightArrow, forState: .Normal)
        self.view!.addSubview(rightButton)
    }// End of setupRightButton function
    
    func setupFireButton(){
        fireButton.addTarget(self, action: #selector(fireButtonDown), forControlEvents: .TouchDown)
        fireButton.addTarget(self, action: #selector(fireButtonUp), forControlEvents: [.TouchUpInside, .TouchUpOutside])
        
        fireButton.frame = CGRectMake(CGRectGetMinX(self.frame) + 300, CGRectGetMaxY(self.frame) - 150, 100, 100)
        fireButton.setImage(fireButtonImage, forState: .Normal)
        self.view!.addSubview(fireButton)
    }// End of setupFireButton function
    
    func leftButtonTouched() {
        let action = SKAction.moveToX(player.position.x - playerMoveAmount, duration: 0.1)
        self.player.runAction(action);
    }// End of leftButtonTouched function
    
    func rightButtonTouched() {
        let action = SKAction.moveToX(player.position.x + playerMoveAmount, duration: 0.1)
        self.player.runAction(action);
    }// End of rightButtontouched function
    
    func fireButtonTouched(sender: UIButton!){
        currentScore += amountWon;
        score.text = String(currentScore);
    }// End of fireButtonTouched function
    
    func rightButtonDown(sender: AnyObject) {
        rightButtonTouched();
        rightTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(rightButtonTouched), userInfo: nil, repeats: true)
    }// End of rightButtonDown function
    
    func rightButtonUp(sender: AnyObject) {
        rightTimer.invalidate()
    }// End of rightButtonUp function
    
    func leftButtonDown(sender: AnyObject) {
        leftButtonTouched();
        leftTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(leftButtonTouched), userInfo: nil, repeats: true)
    }// End of leftButtonDown function
    
    func leftButtonUp(sender: AnyObject) {
        leftTimer.invalidate()
    }// End of leftButtonUp function
    
    func fireButtonDown(sender: AnyObject) {
        singleFire()
        fireTimer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: #selector(rapidFire), userInfo: nil, repeats: true)
    }// End of fireButtonDown funciton
    
    func fireButtonUp(sender: AnyObject) {
        fireTimer.invalidate()
    }// End of fireButtonUp function
    
    func singleFire() {
        let missile = SKSpriteNode(imageNamed: "missile");
        missile.position = player.position;
        
        missile.xScale = 0.01;
        missile.yScale = 0.01;
        missile.zPosition = -1;
        
        missile.physicsBody = SKPhysicsBody(rectangleOfSize: missile.frame.size);
        missile.physicsBody!.usesPreciseCollisionDetection = true;
        missile.physicsBody?.affectedByGravity = false;
        missile.physicsBody?.allowsRotation = false;
        missile.physicsBody?.categoryBitMask = missileCategory;
        missile.physicsBody?.contactTestBitMask = enemyCategory;
        missile.name = "missile";
        
        self.addChild(missile)
        
        let moveForward = SKAction.moveToY(CGRectGetMaxY(self.frame) + 100, duration: 3.0)
        missile.runAction(moveForward)
        
    }// End of singleFire function
    
    func rapidFire() {
        singleFire();
    }// End of rapidFire function
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        var missile : SKNode? = nil
        var enemy: SKNode? = nil;
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            missile = contact.bodyA.node
            enemy = contact.bodyB.node;
        }else{
            missile = contact.bodyB.node
            enemy = contact.bodyA.node;
        }
        
        missile?.removeFromParent();
        enemy?.removeFromParent();
        activeEnemies = activeEnemies - 1;
        if(checkForEnemies()){
            levelUp();
            spriteArray.removeAll();
            generateEnemies(self);
            flowToScene(self, position: CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame)));
        }// End of if there are still Enemies
        incrementScore();
    }// End of didBeginContact
    
    func checkForEnemies() -> Bool{
        if(activeEnemies == 0){
            return true;
        }// End of if there are active
        return false;
    }// End of checkForEnemies function
    
    func levelUp(){
        currentLevel = currentLevel + 1;
        level.text = "Level: " + String(currentLevel);
    }// End of level up function
}// End of class
