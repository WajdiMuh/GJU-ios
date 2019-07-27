//
//  loadingViewController.swift
//  GJU
//
//  Created by wajdi muhtadi on 7/27/19.
//  Copyright © 2019 wajdi muhtadi. All rights reserved.
//

import UIKit
import Lottie
class loadingViewController: UIViewController {
    @IBOutlet weak var av: AnimationView!
    @IBOutlet var background: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*let gradient = CAGradientLayer()
        gradient.opacity = 0.8
        gradient.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        gradient.colors = [UIColor(red:0.05, green:0.53, blue:0.79, alpha:1).cgColor,UIColor(red:0.97, green:0.66, blue:0.0, alpha:0.5).cgColor]
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint.zero
        gradient.endPoint = CGPoint(x: 1.15, y: 1.15)
        background.layer.addSublayer(gradient)*/
        av.animation = Animation.named("loading")
        av.loopMode = .loop
        av.backgroundBehavior = .pauseAndRestore
        av.play()
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
