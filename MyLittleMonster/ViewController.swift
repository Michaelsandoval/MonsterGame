//
//  ViewController.swift
//  MyLittleMonster
//
//  Created by Michael Sandoval on 7/27/16.
//  Copyright © 2016 Michael Sandoval. All rights reserved.
//

import UIKit
import AVFoundation
import QuartzCore

class ViewController: UIViewController {

    @IBOutlet weak var monsterImg: MonsterImg!
    @IBOutlet weak var foodImg: DragImg!
    @IBOutlet weak var heartImg: DragImg!
    
    @IBOutlet weak var penalty1Img: UIImageView!
    @IBOutlet weak var penalty2Img: UIImageView!
    @IBOutlet weak var penalty3Img: UIImageView!
   
    @IBOutlet weak var restartButton: UIButton!
    let DIM_ALPHA: CGFloat = 0.2
    let OPAQUE: CGFloat = 1.0
    let MAX_PENALTIES = 3
    var timer: NSTimer!
    var penalties = 0
    var monsterHappy = false
    var currentItem: UInt32 = 0
    
    var musicPlayer: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!
    
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        penalty1Img.alpha = DIM_ALPHA
        penalty2Img.alpha = DIM_ALPHA
        penalty3Img.alpha = DIM_ALPHA
        
        foodImg.dropTarget = monsterImg
        heartImg.dropTarget = monsterImg
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.itemDroppedOnCharacter(_:)), name: "onTargetDropped", object: nil)
        
        startTimer()
        changeButtonGlow()
        
        do {
            try musicPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("cave-music", ofType: "mp3")!))
            try sfxBite = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bite", ofType: "wav")!))
            try sfxHeart = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("heart", ofType: "wav")!))
            try sfxDeath = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("death", ofType: "wav")!))
            try sfxSkull = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("skull", ofType: "wav")!))
            
            musicPlayer.prepareToPlay()
            musicPlayer.play()
            
            sfxBite.prepareToPlay()
            sfxHeart.prepareToPlay()
            sfxDeath.prepareToPlay()
            sfxSkull.prepareToPlay()
            

        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        restartButton.hidden = true
    }
    
    func itemDroppedOnCharacter(notif: AnyObject) {
        monsterHappy = true
        startTimer()
        
        foodImg.alpha = DIM_ALPHA
        foodImg.userInteractionEnabled = false

        heartImg.alpha = DIM_ALPHA
        heartImg.userInteractionEnabled = false
        
        if currentItem == 0 {
            sfxHeart.play()
        } else if currentItem == 1 {
            sfxBite.play()
        }
        
    }
  
    func startTimer() {
        if timer != nil {
            timer.invalidate()
        }
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(ViewController.changeGameState), userInfo: nil, repeats: true)
    }
    
    func changeButtonGlow() {
        let color: UIColor = restartButton.currentTitleColor
        restartButton.titleLabel?.layer.shadowColor = color.CGColor
        restartButton.titleLabel?.layer.shadowRadius = 4.0
        restartButton.titleLabel?.layer.shadowOpacity = 0.9
        restartButton.titleLabel?.layer.shadowOffset = CGSizeZero
        restartButton.titleLabel?.layer.masksToBounds = false
    }

    func changeGameState() {
        
        if !monsterHappy {
            
            penalties += 1
           
            sfxSkull.play()
            
            if penalties == 1 {
                penalty1Img.alpha = OPAQUE
                penalty2Img.alpha = DIM_ALPHA
            } else if penalties == 2 {
                penalty2Img.alpha = OPAQUE
                penalty3Img.alpha = DIM_ALPHA
                
            } else if penalties >= 3 {
                penalty3Img.alpha = OPAQUE
            }
            else {
                penalty1Img.alpha = DIM_ALPHA
                penalty2Img.alpha = DIM_ALPHA
                penalty3Img.alpha = DIM_ALPHA
            }
            
            if penalties >= MAX_PENALTIES {
                gameOver()
            }
            
        }
        
        let rand = arc4random_uniform(2)
        
        if rand == 0 && penalties != MAX_PENALTIES {
            foodImg.alpha = DIM_ALPHA
            foodImg.userInteractionEnabled = false
            heartImg.alpha = OPAQUE
            heartImg.userInteractionEnabled = true
        } else if rand == 1 && penalties != MAX_PENALTIES {
            heartImg.alpha = DIM_ALPHA
            heartImg.userInteractionEnabled = false
            foodImg.alpha = OPAQUE
            foodImg.userInteractionEnabled = true
        }
        
        currentItem = rand
        monsterHappy = false
        
    }
    
    func gameOver() {
        timer.invalidate()
        sfxDeath.play()
        monsterImg.playDeathAnimation()
        restartButton.hidden = false
        musicPlayer.stop()
        foodImg.userInteractionEnabled = false
        heartImg.userInteractionEnabled = false
        foodImg.alpha = DIM_ALPHA
        heartImg.alpha = DIM_ALPHA
        changeButtonGlow()
        
    }
    
    func restartGame() {
        
        monsterImg.imgArray.removeAll()
        penalty1Img.alpha = DIM_ALPHA
        penalty2Img.alpha = DIM_ALPHA
        penalty3Img.alpha = DIM_ALPHA
        monsterHappy = true
        penalties = 0
        monsterImg.stopAnimating()
        monsterImg.playIdleAnimation()
        startTimer()
        restartButton.hidden = true
        musicPlayer.play()
        changeButtonGlow()
    }

    @IBAction func onRestartButtonTapped(sender: AnyObject) {
       
       restartGame()
        
    }
    
}

