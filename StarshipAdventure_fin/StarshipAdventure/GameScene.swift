//
//  GameScene.swift
//  StarshipAdventure
//
//  Created by Nurfajri on 11/11/20.
//  Copyright © 2020 Nurfajri Rafiuddin. All rights reserved.
//

import SpriteKit
import GameplayKit




class GameScene: SKScene {
    
    
    
    weak var viewController: GameViewController?

    private var station: SKSpriteNode?
    private var rocket: SKSpriteNode?
   // private var moon: SKSpriteNode?
    
    var rk = SKSpriteNode()
    var moonWithRocket = SKSpriteNode()
    var moon = SKSpriteNode()
    var randomX: Float = 0.0
    var randomY: Float = 0.0
    
    var gameOver = true
    var music = SKAudioNode(url: Bundle.main.url(forResource: "retro-space-music", withExtension: "mp3")!)
    
    override func didMove(to view: SKView) {

        physicsWorld.contactDelegate = self

        setBackground()
        
        startGame()
        
        rocket = self.childNode(withName: "//rocket") as? SKSpriteNode
        station = self.childNode(withName: "//station") as? SKSpriteNode

    }
    
    override func update(_ currentTime: TimeInterval) {
       // if !gameOver && rk.position.y < rk.frame.size.height {
         //     stopGame()
           //}
       }
    
    
    // set background picture and animated stars
    func setBackground(){
        
        let backgroundImg = SKSpriteNode(imageNamed: "background2.png")
        backgroundImg.position = CGPoint(x: 0, y: -150)
        backgroundImg.zPosition = -10
        
        //frame width: 2.5 - 12
        //frame height: 5 - 50
        
        //width for stars: -frame.width/2 ... -frame.width/2
         //width for stars: -frame.height/2 ...
          randomX = Float.random(in: 2.5...12)
          randomY = Float.random(in: 5...50)
        moon = makeMoon(position: CGPoint(x: frame.width/CGFloat(randomX), y: frame.height/CGFloat(randomY)))
        addChild(backgroundImg)
        addChild(moon)
        
        //adding random stars
        for _ in 0...30 {
            let thisScale = Double.random(in: 0.01...0.03)
            let thisX = Double.random(in: Double(-frame.width)...Double(frame.width))
            let thisY = Double.random(in: Double(-frame.height)...Double(frame.height))
            let star = makeStarDot(position: CGPoint(x: CGFloat(thisX), y: CGFloat(thisY)), scale:thisScale)
            addChild(star)
        }
        
        
        //let moon = makeMoon(position: CGPoint(x: frame.width/2.5, y: frame.height/5))
        //let star1 = makeStar(position: CGPoint(x: frame.width/5, y: frame.height/6))
       // let star2 = makeStar(position: CGPoint(x: frame.width/3, y: -frame.height/4))
       //let coin1 = makeCoin(position: CGPoint(x: frame.width/4, y: frame.height/6))
       // let star1 = makeStarDot(position: CGPoint(x: frame.width/5, y: frame.height / 5))
        //let star2 = makeStarDot(position: CGPoint(x: frame.width/3, y: -frame.height/4))

        //addChild(star1)
       // addChild(star2)
        //addChild(coin1)
    }
    
    func makeStar(position: CGPoint) -> SKSpriteNode {

        let starTexture = SKTexture(imageNamed: "star_1")
        let star = SKSpriteNode(texture: starTexture)
        star.name = "star"
        star.zPosition = -9
        star.position = position
        
       // star.physicsBody = SKPhysicsBody(texture: starTexture, size: starTexture.size())
        //star.physicsBody?.isDynamic = false
        
        star.setScale(0.1)
        
        let anim = SKAction.animate(with: [
            SKTexture(imageNamed: "star_1"),
            SKTexture(imageNamed: "star_2")], timePerFrame: 0.3)
        let forever = SKAction.repeatForever(anim)
        star.run(forever)
        
        return star
    }
    
    func makeStarDot(position: CGPoint, scale: Double) -> SKSpriteNode {

        let starTexture = SKTexture(imageNamed: "dot")
        let star = SKSpriteNode(texture: starTexture)
        star.name = "starDot"
        star.zPosition = -9
        star.position = position
        
       // star.physicsBody = SKPhysicsBody(texture: starTexture, size: starTexture.size())
        //star.physicsBody?.isDynamic = false
        
        star.setScale(CGFloat(scale))
        
//        let anim = SKAction.animate(with: [
//            SKTexture(imageNamed: "star_1"),
//            SKTexture(imageNamed: "star_2")], timePerFrame: 0.3)
//        let forever = SKAction.repeatForever(anim)
        
        let anim = SKAction.sequence([SKAction.fadeIn(withDuration: 1.0), SKAction.fadeOut(withDuration: 1.0)])
        let forever = SKAction.repeatForever(anim)
        star.run(forever)
        return star
    }
    
    // convert degree into radians
    func deg2rad(degree: Int) -> Double{
        return Double(degree) * .pi/180
    }
    
    
    // launch the rocket
    func launch(angle: Int, velocity: Int){
        
        let radians = deg2rad(degree: angle)
        let speed = Double(velocity)*10
        
        rk.physicsBody?.angularVelocity = -1
        
        let impulse = CGVector(dx: cos(radians)*speed, dy: sin(radians)*speed)

        rk.physicsBody?.applyImpulse(impulse)
        
        let anim = SKAction.animate(with: [
            SKTexture(imageNamed: "flying-rocket/1"),
            SKTexture(imageNamed: "flying-rocket/2"),
            SKTexture(imageNamed: "flying-rocket/3"),
            SKTexture(imageNamed: "flying-rocket/4")], timePerFrame: 0.1)
        let forever = SKAction.repeatForever(anim)
        rk.run(forever)
        
    }
    
    
    // game logic
    func startGame() {
        gameOver = false
        rk = makeRocket()
        //moonWithRocket = makeMoonWithRocket(position: CGPoint(x: frame.width/2.5, y: frame.height/5))
        //moonWithRocket = makeMoonWithRocket(position: CGPoint(x: moon.anchorPoint.x, y: moon.anchorPoint.y))
        addChild(music)
    }
    
    func stopGame(){
        gameOver = true
        removeAllActions()
        startGame()
    }
    
    func resetGame(){
        //removeAllActions()
        gameOver = false
        rk = makeRocket()
        moonWithRocket.removeFromParent()
        moon.removeFromParent()
        setBackground()
    }
    
    // make a rocket on the station
    func makeRocket() -> SKSpriteNode {

        let rocketTexture = SKTexture(imageNamed: "landed-rocket")
        rk = SKSpriteNode(texture: rocketTexture)
        rk .name = "rocket"
        rk .zPosition = 0
        rk .position = CGPoint(x:-470,y: 100)

        rk .setScale(0.3)
        rk.physicsBody = SKPhysicsBody(circleOfRadius: rk.size.width/2)

        rk .physicsBody?.contactTestBitMask = rk .physicsBody!.collisionBitMask
        rk .physicsBody?.isDynamic = true
        rk .physicsBody?.allowsRotation = false
        rk .physicsBody?.affectedByGravity = true

        addChild(rk)
        return rk
    }
    
    
    func makeMoon(position: CGPoint) -> SKSpriteNode {

        let moonTexture = SKTexture(imageNamed: "mars")
        let mn = SKSpriteNode(texture: moonTexture)
        mn.name = "moon"
        mn.zPosition = 0
        mn.position = position
        
        mn.physicsBody = SKPhysicsBody(texture: moonTexture, size: moonTexture.size())
        mn.physicsBody?.isDynamic = false
        
        mn.setScale(0.3)
        
        return mn
    }
    
    func makeMoonWithRocket (position: CGPoint) -> SKSpriteNode {

        let moonTexture = SKTexture(imageNamed: "mars-with-rocket")
        let mn = SKSpriteNode(texture: moonTexture)
        mn.name = "moon-with-rocket"
        mn.zPosition = 0
        mn.position = position
        
        mn.physicsBody = SKPhysicsBody(texture: moonTexture, size: moonTexture.size())
        mn.physicsBody?.isDynamic = false
        
        mn.setScale(0.3)
        
        return mn
    }
    
    // make animated coin
    func makeCoin(position: CGPoint) -> SKSpriteNode {

        let coinTexture = SKTexture(imageNamed: "coin.png")
        let coin = SKSpriteNode(texture: coinTexture)
        coin.name = "coin"
        coin.zPosition = 1
        coin.position = position
        
        coin.physicsBody = SKPhysicsBody(texture: coinTexture, size: coinTexture.size())
        coin.physicsBody?.isDynamic = false
        
        coin.setScale(0.1)
        
        let anim = SKAction.animate(with: [
            SKTexture(imageNamed: "coin 2.png"),
            SKTexture(imageNamed: "coin 3.png"),
            SKTexture(imageNamed: "coin 4.png"),
            SKTexture(imageNamed: "coin.png")], timePerFrame: 0.2)
        let forever = SKAction.repeatForever(anim)
        coin.run(forever)
        
        return coin
    }

    //
    //    func touchDown(atPoint pos : CGPoint) {
    //        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
    //            n.position = pos
    //            n.strokeColor = SKColor.green
    //            self.addChild(n)
    //        }
    //    }
    //
    //    func touchMoved(toPoint pos : CGPoint) {
    //        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
    //            n.position = pos
    //            n.strokeColor = SKColor.blue
    //            self.addChild(n)
    //        }
    //    }
    //
    //    func touchUp(atPoint pos : CGPoint) {
    //        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
    //            n.position = pos
    //            n.strokeColor = SKColor.red
    //            self.addChild(n)
    //        }
    //    }
    //
    //    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    //        if gameOver == true{
    //            for touch in touches {
    //                let location = touch.location(in: self)
    //                if launchBtn.contains(location) {
    //
    //                }
    //            }
    //        }
    //    }
    //
    //    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    //        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    //    }
    //
    //    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    //        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    //    }
    //
    //    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    //        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    //    }
    //
    //
    //    override func update(_ currentTime: TimeInterval) {
    //        // Called before each frame is rendered
    //    }
    //
    //
    //
    //
    //

}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "coin" || contact.bodyB.node?.name == "coin" {
            if contact.bodyA.node == rk {
                contact.bodyB.node?.removeFromParent()
            } else {
                contact.bodyA.node?.removeFromParent()
            }
            //add sound, and add points
            
            //run(sndCollect)
            //score += 1
        } else if contact.bodyA.node?.name == "moon" || contact.bodyB.node?.name == "moon" {
            //remove the moon and rocket, and replace them with the moon-rocket image
            //also add points maybe
            moonWithRocket = makeMoonWithRocket(position: CGPoint(x: frame.width/CGFloat(randomX), y: frame.height/CGFloat(randomY)))
           // moonWithRocket = makeMoonWithRocket(position: CGPoint(x: moon.anchorPoint.x, y: moon.anchorPoint.y))
            addChild(moonWithRocket)

            contact.bodyB.node?.removeFromParent()
            contact.bodyA.node?.removeFromParent()
        }
        
    }
}
