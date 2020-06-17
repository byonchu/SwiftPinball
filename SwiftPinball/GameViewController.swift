//
//  GameViewController.swift
//  SwiftPinball
//
//  Created by 飯久保大成 on 2020/04/28.
//  Copyright © 2020 飯久保大成. All rights reserved.
//

import UIKit
import AVFoundation
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //シーンの作成
        let scene = GameScene()
        
        //View ControllerのViewをSKView型として取り出す
        let view = self.view as! SKView
        
        //FPSの表示
        view.showsFPS = true
        
        //ノードの表示
        view.showsNodeCount = true
        
        //シーンのサイズをビューに合わせる
        scene.size =  view.frame.size
        
        //ビュー上にシーンを表示
        view.presentScene(scene)
        
        //マルチタップを無効にする
        view.isMultipleTouchEnabled = false
    }
   

}
