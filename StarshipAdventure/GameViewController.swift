//
//  GameViewController.swift
//  StarshipAdventure
//
//  Created by Nurfajri on 11/11/20.
//  Copyright © 2020 Nurfajri Rafiuddin. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    var currentGame: GameScene?
    
    @IBOutlet weak var angleSlider: UISlider!
    @IBOutlet weak var velocitySlider: UISlider!
    
    @IBOutlet weak var angleLabel: UILabel!
    @IBOutlet weak var velocityLabel: UILabel!
    
    @IBOutlet weak var launchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
                
                // get access to the game scene
                currentGame = scene as? GameScene
                currentGame?.viewController = self
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
        
        angleChanged(angleSlider ?? 45)
        velocityChanged(velocitySlider ?? 50)

    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // Sliders and launch button
    
    @IBAction func angleChanged(_ sender: Any) {
        angleLabel.text = "\(Int(angleSlider.value))"
    }
    
    @IBAction func velocityChanged(_ sender: Any) {
        velocityLabel.text = "\(Int(velocitySlider.value))"
    }
    
    @IBAction func launchBtn(_ sender: Any) {
        if (launchButton.titleLabel!.text == "Launch"){
            currentGame?.launch(angle:Int(angleSlider.value),velocity:Int(velocitySlider.value))
            launchButton.setTitle("Reset", for: .normal)
        } else {
            currentGame?.resetGame()
            launchButton.setTitle("Launch", for: .normal)
        }
        
    }
    
}
