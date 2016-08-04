//
//  MonsterImg.swift
//  MyLittleMonster
//
//  Created by Michael Sandoval on 8/3/16.
//  Copyright © 2016 Michael Sandoval. All rights reserved.
//

import Foundation
import UIKit

class MonsterImg: UIImageView {
    
    var imgArray = [UIImage]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        playIdleAnimation()
    }
    
    func playIdleAnimation() {
        self.image = UIImage(named: "idle1.png")
        self.animationImages = nil
        
        for x in 1...4 {
            
            let img = UIImage(named: "idle\(x).png")
            imgArray.append(img!)
        }
        self.animationImages = imgArray
        self.animationDuration = 0.7
        self.animationRepeatCount = 0
        self.startAnimating()
    }
    
    func playDeathAnimation() {
       
        self.image = UIImage(named: "dead5.png")
        self.animationImages = nil
        
        for x in 1...4 {
            
            let img = UIImage(named: "dead\(x).png")
            imgArray.append(img!)
        }
        self.animationImages = imgArray
        self.animationDuration = 0.7
        self.animationRepeatCount = 1
        self.startAnimating()

    }
}
