//
//  GameScene.swift
//  SwiftPinball
//
//  Created by 飯久保大成 on 2020/04/28.
//  Copyright © 2020 飯久保大成. All rights reserved.
//

import SpriteKit
import AVFoundation
import GameplayKit

class GameScene: SKScene,SKPhysicsContactDelegate {
    
    //ゲームオーバーフラグ
    var gameoverFlg = false

    //ポイント
    var count:NSInteger = 0

    //ラベル
    let gameoverLabel = SKLabelNode(fontNamed: "Hiragino kaku Gothic ProN")//ゲームオーバーを表示するラベル

    let pointLabel = SKLabelNode(fontNamed: "Hiragino kaku Gothic ProN")//得点を表示するラベル

    //オブジェクト
    var ball = SKSpriteNode(imageNamed: "ball")
    var armRight = SKSpriteNode(imageNamed: "rightarm")
    var armLeft = SKSpriteNode(imageNamed: "leftarm")
    var back = SKSpriteNode(imageNamed: "back")
    var wallLeft = SKSpriteNode(imageNamed: "wallleft")
    var wallRight = SKSpriteNode(imageNamed: "wallright")
    var triangleLeft = SKSpriteNode(imageNamed: "triangleleft")
    var triangleRight = SKSpriteNode(imageNamed: "triangleright")
    var monster1 = SKSpriteNode(imageNamed: "monster1a")
    var monster2 = SKSpriteNode(imageNamed: "monster2a")
    var monster3 = SKSpriteNode(imageNamed: "monster3a")
    let playSound = SKAction.playSoundFileNamed("click.mp3", waitForCompletion: false)
    
    //衝突が発生した時に呼び出される
    func didBegin(_ contact: SKPhysicsContact) {
        if let nodeA = contact.bodyA.node {
            if let nodeB = contact.bodyB.node {
                if nodeA.name == "monster1" ||
                   nodeB.name == "monster1" ||
                   nodeA.name == "monster2" ||
                   nodeB.name == "monster2" ||
                   nodeA.name == "monster3" ||
                   nodeB.name == "monster3"{
                    let playSound = SKAction.playSoundFileNamed("click.mp3", waitForCompletion: false)
                    ball.run(playSound)
                    
                    let particle = SKEmitterNode(fileNamed: "MyParticle.sks")
                    self.addChild(particle!)
                    
                    var removeAction = SKAction.removeFromParent()
                    var durationAction = SKAction.wait(forDuration: 1)
                    var sequenceAction = SKAction.sequence([durationAction,removeAction])
                    particle?.run(sequenceAction)
                    
                    particle?.position = CGPoint(x: ball.position.x, y: ball.position.y)
                    particle?.alpha = 1
                    
                    var fadeAction = SKAction.fadeAlpha(to: 0, duration: 0.5)
                    particle?.run(fadeAction)
                    
                    count += 10
                    var pointString:String = "\(count)点"
                    pointLabel.text = pointString
                }
            }
        }
    }
    

    override func didMove(to view: SKView) {
        
        //背景
        back.position = CGPoint(x: 0, y: 0)
        back.anchorPoint = CGPoint(x: 0, y: 0)
        self.addChild(back)
        self.size = CGSize(width: 320, height: 568)
        
        //重力の設定とcontactDelegateの設定
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -3.0)
        self.physicsWorld.contactDelegate = self
        
        
        //ボールを作成
        makeBall()
        
        //壁左半分
        wallLeft.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "wallleft.png"), size: wallLeft.size)
        wallLeft.physicsBody?.restitution = 1.5
        wallLeft.physicsBody?.isDynamic = false
        wallLeft.physicsBody?.contactTestBitMask = 1
        wallLeft.position = CGPoint(x: 80, y: 284)
        self.addChild(wallLeft)
        
        //壁右半分
        wallRight.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "wallright.png"), size: wallRight.size)
        wallRight.physicsBody?.restitution = 1.5
        wallRight.physicsBody?.isDynamic = false
        wallRight.physicsBody?.contactTestBitMask = 1
        wallRight.position = CGPoint(x: 240, y: 284)
        self.addChild(wallRight)
        
        //アーム左
        armLeft.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "leftarm.png"), size: armLeft.size)
        armLeft.physicsBody?.restitution = 2.5
        armLeft.physicsBody?.isDynamic = false
        armLeft.physicsBody?.contactTestBitMask = 1
        armLeft.position = CGPoint(x: 100, y: 70)
        self.addChild(armLeft)
    
        //アーム右
        armRight.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "rightarm.png"), size: armRight.size)
        armRight.physicsBody?.restitution = 2.5
            armRight.physicsBody?.isDynamic = false
            armRight.physicsBody?.contactTestBitMask = 1
            armRight.position = CGPoint(x: 220, y: 70)
            self.addChild(armRight)
        
        //敵１（キノコ）
        monster1.name = "monster1"
        monster1.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "monster1a.png"), size: monster1.size)
        monster1.physicsBody?.restitution = 0.5
        monster1.physicsBody?.isDynamic = false
        monster1.physicsBody?.contactTestBitMask = 1
        monster1.position = CGPoint(x: 140, y: 410)
        self.addChild(monster1)
        
        //拡大・縮小アニメーション
        let scaleA = SKAction.scale(to: 0.5, duration: 0.5)
        let scaleB = SKAction.scale(to: 1.0, duration: 0.5)
        let scaleSequence = SKAction.sequence([scaleA,scaleB])
        let sacalerepeatAction = SKAction.repeatForever(scaleSequence)
        monster1.run(sacalerepeatAction)
        
        //敵１のパラパラアニメーション
        let paraparaAction1 = SKAction.animate(with: [SKTexture(imageNamed: "monster1a.png"),SKTexture(imageNamed: "monster1b.png")], timePerFrame: 0.5)
        let paraparaRepeatAction1 = SKAction.repeatForever(paraparaAction1)
        monster1.run(paraparaRepeatAction1)
        
        //敵２（ドラゴン）
        monster2.name = "monster2"
        monster2.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "monster2a.png"), size: monster2.size)
        monster2.physicsBody?.restitution = 0.5
        monster2.physicsBody?.isDynamic = false
        monster2.physicsBody?.contactTestBitMask = 1
        monster2.position = CGPoint(x: 100, y: 300)
        self.addChild(monster2)
        
        //敵２の移動アニメーション
        let moveA = SKAction.move(to: CGPoint(x: 100, y: 300), duration: 1)
        let moveB = SKAction.move(to: CGPoint(x: 200, y: 300), duration: 1)
        let moveSequence = SKAction.sequence([moveA,moveB])
        let moverepeatAction = SKAction.repeatForever(moveSequence)
        monster2.run(moverepeatAction)
        
        //敵２のパラパラアニメーション
        let paraparaAction2 = SKAction.animate(with: [SKTexture(imageNamed: "monster2a.png"),SKTexture(imageNamed: "monster2b.png")], timePerFrame: 0.5)
        let paraparaRepeatAction2 = SKAction.repeatForever(paraparaAction2)
        monster2.run(paraparaRepeatAction2)
        
        //敵３（スライム）
        monster3.name = "monster3"
        monster3.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "monster3a.png"), size: monster3.size)
        monster3.physicsBody?.restitution = 0.5
        monster3.physicsBody?.isDynamic = false
        monster3.physicsBody?.contactTestBitMask = 1
        monster3.position = CGPoint(x: 150, y: 200)
        self.addChild(monster3)
        
        //敵３の回転アニメーション
        var rotateAction = SKAction.rotate(byAngle: CGFloat(360*M_PI/180), duration: 3)
        let rotateRepeatAction = SKAction.repeatForever(rotateAction)
        SKAction.repeat(rotateRepeatAction, count: 1000)
        monster3.run(rotateRepeatAction)
        
        //敵３のパラパラアニメーション
        let paraparaAction3 = SKAction.animate(with: [SKTexture(imageNamed: "monster3a.png"),SKTexture(imageNamed: "monster3b.png")], timePerFrame: 0.5)
        let paraparaRepeatAction3 = SKAction.repeatForever(paraparaAction3)
        monster3.run(paraparaRepeatAction3)
        
        //三角の壁左
        triangleLeft.name = "lefttriangle"
        triangleLeft.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "triangleleft.png"), size: triangleLeft.size)
        triangleLeft.physicsBody?.restitution = 0.5
        triangleLeft.physicsBody?.isDynamic = false
        triangleLeft.physicsBody?.contactTestBitMask = 1
        triangleLeft.position = CGPoint(x: 70, y: 150)
        self.addChild(triangleLeft)
        
        //三角の壁右
        triangleRight.name = "righttriangle"
        triangleRight.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "triangleright.png"), size: triangleRight.size)
        triangleRight.physicsBody?.restitution = 0.5
        triangleRight.physicsBody?.isDynamic = false
        triangleRight.physicsBody?.contactTestBitMask = 1
        triangleRight.position = CGPoint(x: 240, y: 150)
        self.addChild(triangleRight)
        
        //得点ラベル
        pointLabel.text = "0点"
        pointLabel.fontSize = 25
        pointLabel.fontColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 1)
        pointLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.addChild(pointLabel)
        pointLabel.position = CGPoint(x: 160, y: 497)
}

    //ボール（勇者）を作成
    func makeBall(){
        //ボールのスプライト
        let ballSprite = SKSpriteNode(imageNamed: "ball.png")

        //ボールのphysicsBodyの設定
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 15)
        ball.physicsBody?.contactTestBitMask = 1

        //ボールを配置
        ball.position = CGPoint(x: 165, y: 500)
        self.addChild(ball)
    }
    
    //タッチ開始時
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            
            //アームをあげる
            let swingAction1 = SKAction.rotate(byAngle: CGFloat(-M_PI*0.25), duration: 0.05)
            let swingAction2 = SKAction.rotate(byAngle: CGFloat(M_PI*0.25), duration: 0.05)
            armRight.run(swingAction1)
            armLeft.run(swingAction2)
        }
        
        if(gameoverFlg == true){
            self.reset()
        }
    }
    //タッチ終了時
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
        let location = touch.location(in: self)
            
            //アームを下げる
            let swingAction1 = SKAction.rotate(byAngle: CGFloat(-M_PI*0.25), duration: 0.05)
            let swingAction2 = SKAction.rotate(byAngle: CGFloat(M_PI*0.25), duration: 0.05)
            armRight.run(swingAction1)
            armLeft.run(swingAction2)
    }
}
    override func update(_ currentTime: TimeInterval) {
        if(gameoverFlg == false){
            if(ball.position.y < 0){
                self.gameover()
            }
        }
    }
    func gameover(){
        gameoverLabel.text = "ゲームオーバー"
        gameoverLabel.fontSize = 30
        gameoverLabel.fontColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 1)
        gameoverLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.addChild(gameoverLabel)
        
        gameoverFlg = true
    }
    func reset(){
        gameoverFlg = false
        
        gameoverLabel.removeFromParent()
        
        ball.removeFromParent()
        self.makeBall()
        
        count = 0
    }
}
