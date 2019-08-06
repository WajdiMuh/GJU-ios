//
//  TranscoursepopViewController.swift
//  GJU
//
//  Created by wajdi muhtadi on 8/6/19.
//  Copyright © 2019 wajdi muhtadi. All rights reserved.
//

import UIKit
import SwiftSoup
import QuartzCore

class TranscoursepopViewController: UIViewController {
    var courseinfo:Elements? = nil
    @IBOutlet var background: UIView!
    @IBOutlet weak var cname: UILabel!
    @IBOutlet weak var cid: UILabel!
    @IBOutlet weak var ch: UILabel!
    @IBOutlet weak var grade: UILabel!
    @IBOutlet weak var remark: UILabel!
    @IBOutlet weak var gradelabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            cid.text = try courseinfo?.array()[0].text()
            cname.text = try courseinfo?.array()[1].text()
            ch.text = try courseinfo?.array()[2].text()
            if(courseinfo!.count < 5){
                grade.isHidden = true
                gradelabel.isHidden = true
                remark.text = try courseinfo?.array()[3].text()
            }else{
                grade.text = try courseinfo?.array()[3].text()
                if(grade.text?.isEmpty == true){
                    grade.isHidden = true
                    gradelabel.isHidden = true
                }
                remark.text = try courseinfo?.array()[4].text()
            }
        } catch Exception.Error( let message) {
            print(message)
        } catch {
            print("error")
        }
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
