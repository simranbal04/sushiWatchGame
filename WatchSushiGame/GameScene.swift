//
//  GameScene.swift
//  SushiTower
//
//  Created by Parrot on 2019-02-14.
//  Copyright © 2019 Parrot. All rights reserved.
//


import SpriteKit
import GameplayKit
import WatchConnectivity

class GameScene: SKScene,WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    
    let cat = SKSpriteNode(imageNamed: "character1")
    let sushiBase = SKSpriteNode(imageNamed:"roll")
    // Make a tower
    var sushiTower:[SKSpriteNode] = []
    let SUSHI_PIECE_GAP:CGFloat = 80

    // Make chopsticks
    var chopstickGraphicsArray:[SKSpriteNode] = []
    
    // Make variables to store current position
    var catPosition = "left"
    var chopstickPositions:[String] = []
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        // Output message to terminal
        print("WATCH: I received a message: \(message)")
        
        let name = message["name"] as! String
        print("\(name)")

        
    }
    
    func spawnSushi() {
        
        // -----------------------
        // MARK: PART 1: ADD SUSHI TO GAME
        // -----------------------
        
        // 1. Make a sushi
        let sushi = SKSpriteNode(imageNamed:"roll")
        
        // 2. Position sushi 10px above the previous one
        if (self.sushiTower.count == 0) {
            // Sushi tower is empty, so position the piece above the base piece
            sushi.position.y = sushiBase.position.y
                + SUSHI_PIECE_GAP
            sushi.position.x = self.size.width*0.5
        }
        else {
            // OPTION 1 syntax: let previousSushi = sushiTower.last
            // OPTION 2 syntax:
            let previousSushi = sushiTower[self.sushiTower.count - 1]
            sushi.position.y = previousSushi.position.y + SUSHI_PIECE_GAP
            sushi.position.x = self.size.width*0.5
        }
        
        // 3. Add sushi to screen
        addChild(sushi)
        
        // 4. Add sushi to array
        self.sushiTower.append(sushi)
        
        
        // -----------------------
        // MARK: PART 2: ADD CHOPSTICKS TO SUSHI
        // -----------------------
        
        // Generate  a random number (0, 1, 2)
        // 0 = no stick
            // ???????
        // 1 = stick on right
            // stick.position.x = sushi.position.x + 100
            // stick.position.y = sushi.position.y - 10
        // 2 = stick on left
            // stick.position.x = sushi.position.x - 100
            // stick.position.y = sushi.position.y - 10
        
        
        // generate a number between 1 and 2
        let stickPosition = Int.random(in: 1...2)
        print("Random number: \(stickPosition)")
        if (stickPosition == 1) {
            // save the current position of the chopstick
            self.chopstickPositions.append("right")
            
            // draw the chopstick on the screen
            let stick = SKSpriteNode(imageNamed:"chopstick")
            stick.position.x = sushi.position.x + 100
            stick.position.y = sushi.position.y - 10
            // add chopstick to the screen
            addChild(stick)
            
            // add the chopstick object to the array
            self.chopstickGraphicsArray.append(stick)
            
            // redraw stick facing other direciton
            let facingRight = SKAction.scaleX(to: -1, duration: 0)
            stick.run(facingRight)
        }
        else if (stickPosition == 2) {
            // save the current position of the chopstick
            self.chopstickPositions.append("left")
            
            // left
            let stick = SKSpriteNode(imageNamed:"chopstick")
            stick.position.x = sushi.position.x - 100
            stick.position.y = sushi.position.y - 10
            // add chopstick to the screen
            addChild(stick)
            
            // add the chopstick to the array
            self.chopstickGraphicsArray.append(stick)
        }
        
        
        // Add this if you cannot see the chopsticks
        // sushi.zPosition = -1
        
       
        
        
    }
    
    
  
    override func didMove(to view: SKView) {
        if(WCSession.isSupported() == true) {
            
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        else{
            

        }
        // add background
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = -1
        addChild(background)
        
        // add cat
        cat.position = CGPoint(x:self.size.width*0.25, y:100)
        addChild(cat)
        
        // add base sushi pieces
        sushiBase.position = CGPoint(x:self.size.width*0.5, y: 100)
        addChild(sushiBase)
        
        // build the tower
        self.buildTower()
    }
    
    func buildTower() {
        for _ in 0...5 {
            self.spawnSushi()
        }
        for i in 0...5 {
            print(self.chopstickPositions[i])
        }
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        // This is the shortcut way of saying:
        //      let mousePosition = touches.first?.location
        //      if (mousePosition == nil) { return }
        guard let mousePosition = touches.first?.location(in: self) else {
            return
        }

        print(mousePosition)
        
        // ------------------------------------
        // MARK: UPDATE THE SUSHI TOWER GRAPHICS
        //  When person taps mouse,
        //  remove a piece from the tower & redraw the tower
        // -------------------------------------
        let pieceToRemove = self.sushiTower.first
        let stickToRemove = self.chopstickGraphicsArray.first
        
        if (pieceToRemove != nil && stickToRemove != nil) {
            // SUSHI: hide it from the screen & remove from game logic
            pieceToRemove!.removeFromParent()
            self.sushiTower.remove(at: 0)
        
            // STICK: hide it from screen & remove from game logic
            stickToRemove!.removeFromParent()
            self.chopstickGraphicsArray.remove(at:0)
            
            // STICK: Update stick positions array:
            self.chopstickPositions.remove(at:0)
            
            // SUSHI: loop through the remaining pieces and redraw the Tower
            for piece in sushiTower {
                piece.position.y = piece.position.y - SUSHI_PIECE_GAP
            }
            
            // STICK: loop through the remaining sticks and redraw
            for stick in chopstickGraphicsArray {
                stick.position.y = stick.position.y - SUSHI_PIECE_GAP
            }
        }
        
        // ------------------------------------
        // MARK: SWAP THE LEFT & RIGHT POSITION OF THE CAT
        //  If person taps left side, then move cat left
        //  If person taps right side, move cat right
        // -------------------------------------
        
        // 1. detect where person clicked
        let middleOfScreen  = self.size.width / 2
        if (mousePosition.x < middleOfScreen) {
            print("TAP LEFT")
            // 2. person clicked left, so move cat left
            cat.position = CGPoint(x:self.size.width*0.25, y:100)
            
            // change the cat's direction
            let facingRight = SKAction.scaleX(to: 1, duration: 0)
            self.cat.run(facingRight)
            
            // save cat's position
            self.catPosition = "left"
            
        }
            
        else {
            print("TAP RIGHT")
            // 2. person clicked right, so move cat right
            cat.position = CGPoint(x:self.size.width*0.85, y:100)
            
            // change the cat's direction
            let facingLeft = SKAction.scaleX(to: -1, duration: 0)
            self.cat.run(facingLeft)
            
            // save cat's position
            self.catPosition = "right"
        }

        // ------------------------------------
        // MARK: ANIMATION OF PUNCHING CAT
        // -------------------------------------
        
        // show animation of cat punching tower
        let image1 = SKTexture(imageNamed: "character1")
        let image2 = SKTexture(imageNamed: "character2")
        let image3 = SKTexture(imageNamed: "character3")
        
        let punchTextures = [image1, image2, image3, image1]
        
        let punchAnimation = SKAction.animate(
            with: punchTextures,
            timePerFrame: 0.1)
        
        self.cat.run(punchAnimation)
        
        
        // ------------------------------------
        // MARK: WIN AND LOSE CONDITIONS
        // -------------------------------------
        
        // 1. if CAT and STICK are on same side - OKAY, keep going
        // 2. if CAT and STICK are on opposite sides -- YOU LOSE

        
        let firstChopstick = self.chopstickPositions[0]
        if (catPosition == "left" && firstChopstick == "left") {
            // you lose
            print("Cat Position = \(catPosition)")
            print("Stick Position = \(firstChopstick)")
            print("Conclusion = LOSE")
            print("------")
        }
        else if (catPosition == "right" && firstChopstick == "right") {
            // you lose
            print("Cat Position = \(catPosition)")
            print("Stick Position = \(firstChopstick)")
            print("Conclusion = LOSE")
            print("------")
        }
        else if (catPosition == "left" && firstChopstick == "right") {
            // you win
            print("Cat Position = \(catPosition)")
            print("Stick Position = \(firstChopstick)")
            print("Conclusion = WIN")
            print("------")
        }
        else if (catPosition == "right" && firstChopstick == "left") {
            // you win
            print("Cat Position = \(catPosition)")
            print("Stick Position = \(firstChopstick)")
            print("Conclusion = WIN")
            print("------")
        }

        
        
        
//
//        if (catPosition == chopstickPosition) {
//            // YOU LOSE
//        }
//        else if (catPosition != chopstickPosition) {
//            // YOU WIN
//        }
        
        
        
        
        
    }
 
}
