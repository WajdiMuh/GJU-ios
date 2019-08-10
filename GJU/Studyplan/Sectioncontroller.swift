//
//  Sectioncontroller.swift
//  GJU
//
//  Created by wajdi muhtadi on 7/19/19.
//  Copyright © 2019 wajdi muhtadi. All rights reserved.
//

import UIKit

class Sectioncontroller: UIViewController {
    var info:[String]? = nil
    @IBOutlet weak var sectionname: UILabel!
    @IBOutlet weak var stch: UILabel!
    @IBOutlet weak var srch: UILabel!
    @IBOutlet weak var sph: UILabel!
    @IBOutlet var background: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        sectionname.text = info![0]
        stch.text = info![1]
        srch.text = info![2]
        sph.text = info![3]
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
