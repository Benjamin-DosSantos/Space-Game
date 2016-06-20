//
//  GameScene.swift
//  Ball Fall Clone
//
//  Created by Benjamin DosSantos Jr. on 6/19/16.
//  Copyright (c) 2016 Benjamin DosSantos Jr. All rights reserved.
//

import SpriteKit
import CoreMotion

class GameScene: SKScene {
    
    let player = SKSpriteNode(imageNamed:"Spaceship")
    
    let score = SKLabelNode(fontNamed:"Copperplate")
    let level = SKLabelNode(fontNamed:"Copperplate")
    
    var currentScore: Int = 0;
    var currentLevel: Int = 1;
    let amountWon = 10;
    
    var motionManager = CMMotionManager()
    var destX:CGFloat  = 0.0
    
    let leftArrow = UIImage(named: "leftArrow") as UIImage?
    let rightArrow = UIImage(named: "rightArrow") as UIImage?
    let fireButtonImage = UIImage(named: "fireButton") as UIImage?
    
    let leftButton = UIButton(type: UIButtonType.Custom) as UIButton
    let rightButton = UIButton(type: UIButtonType.Custom) as UIButton
    let fireButton = UIButton(type: UIButtonType.Custom) as UIButton
    
    var rightTimer: NSTimer!
    var leftTimer: NSTimer!
    var fireTimer: NSTimer!
    
    let playerMoveAmount: CGFloat = 20;
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        setupScoreLabel();
        setupLevelLabel();
        createPlayer(CGPoint(x:CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame) - 100));
        setupButtons();
        generateEnemy(CGPoint(x: CGRectGetMidY(self.frame), y: CGRectGetMidX(self.frame)));
    }// End of didMoveToView function
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
    }// End of touchesBegan function
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }// End of update function
    
    func createPlayer(location: CGPoint){
        player.xScale = 0.2
        player.yScale = 0.2
        player.position = location;
        
        self.addChild(player)
    }// End of createPlayer function
    
    func setupScoreLabel(){
        score.fontSize = 45
        score.position = CGPoint(x:CGRectGetMidX(self.frame) + 100, y:CGRectGetMaxY(self.frame) - 50)
        self.addChild(score)
    }// End of setupScoreLable function
    
    func setupLevelLabel(){
        level.fontSize = 45
        level.position = CGPoint(x: CGRectGetMidX(self.frame) - 100, y:CGRectGetMaxY(self.frame) - 50)
        level.text = "Level: " + String(currentLevel);
        self.addChild(level)
    }// End of setupLevelLevel function
    
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
        fireTimer = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: #selector(rapidFire), userInfo: nil, repeats: true)
    }// End of fireButtonDown funciton
    
    func fireButtonUp(sender: AnyObject) {
        fireTimer.invalidate()
    }// End of fireButtonUp function
    
    func singleFire() {
        let missile = SKSpriteNode(imageNamed: "missile");
        missile.position = player.position;
        
        missile.xScale = 0.03;
        missile.yScale = 0.03;
        missile.zPosition = -1;
        
        missile.physicsBody = SKPhysicsBody(rectangleOfSize: missile.frame.size);
        missile.physicsBody!.usesPreciseCollisionDetection = true;
        missile.physicsBody?.affectedByGravity = false;
        missile.name = "missile";
        
        self.addChild(missile)
        
        let moveForward = SKAction.moveToY(CGRectGetMaxY(self.frame) + 100, duration: 3.0)
        missile.runAction(moveForward)
        
    }// End of singleFire function
    
    func rapidFire() {
        singleFire();
    }// End of rapidFire function
    
    func generateEnemy(position: CGPoint){
        let enemy = SKSpriteNode(imageNamed: "Spaceship");
        enemy.color = UIColor.redColor();
        enemy.position = position;
        enemy.xScale = 0.2;
        enemy.yScale = 0.2;
        
        enemy.physicsBody = SKPhysicsBody(rectangleOfSize: enemy.frame.size);
        enemy.physicsBody!.usesPreciseCollisionDetection = true;
        enemy.physicsBody?.affectedByGravity = false;
        
        self.addChild(enemy);
    }// End of generateEnemy function
}// End of class
