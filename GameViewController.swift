//
//  GameViewController.swift
//  Ball Fall Clone
//
//  Created by Benjamin DosSantos Jr. on 6/19/16.
//  Copyright (c) 2016 Benjamin DosSantos Jr. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let scene = GameScene(fileNamed:"GameScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
        }
    }// End of viewDidLoad function

    override func shouldAutorotate() -> Bool {
        return true
    }// End of shouldAutorotate function

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }// End of supportedInterfaceOrentations function

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }// End of didRecieveMemoryWarning function

    override func prefersStatusBarHidden() -> Bool {
        return true
    }// End of prefersStatucBarHidden function
}// End of class
