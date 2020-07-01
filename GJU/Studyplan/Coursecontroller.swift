//
//  Coursecontroller.swift
//  GJU
//
//  Created by wajdi muhtadi on 7/3/19.
//  Copyright © 2019 wajdi muhtadi. All rights reserved.
//

import UIKit
import SwiftSoup
import QuartzCore
class Coursecontroller: UIViewController {
    var courseinfo:Course?
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var pre: UILabel!
    @IBOutlet weak var co: UILabel!
    @IBOutlet weak var chours: UILabel!
    @IBOutlet weak var thours: UILabel!
    @IBOutlet weak var phours: UILabel!
    @IBOutlet var background: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        id.text = courseinfo?.id
        name.text = courseinfo?.name
        if(courseinfo?.prerequisites?.isEmpty == false){
            pre.text = courseinfo?.prerequisites
            }else{
                pre.text = "None"
            }
        if(courseinfo?.corequisites?.isEmpty == false){
            co.text = courseinfo?.corequisites
            }else{
                co.text = "None"
            }
        chours.text = courseinfo?.credithours
        thours.text = courseinfo?.theoreticalhours
        phours.text = courseinfo?.practicalhours
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func outtap(_ sender: Any) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.preferredFramesPerSecond60,.allowUserInteraction], animations: {
            self.background.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        }) { _ in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func closetap(_ sender: Any) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.preferredFramesPerSecond60,.allowUserInteraction], animations: {
            self.background.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        }) { _ in
            self.dismiss(animated: true, completion: nil)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.preferredFramesPerSecond60,.allowUserInteraction], animations: {
            self.background.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.55)
        }, completion: nil)
    }

}
