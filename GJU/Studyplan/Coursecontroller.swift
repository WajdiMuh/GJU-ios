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
    var courseinfo:Elements? = nil
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var pre: UILabel!
    @IBOutlet weak var co: UILabel!
    @IBOutlet weak var pretest: UILabel!
    @IBOutlet weak var chours: UILabel!
    @IBOutlet weak var thours: UILabel!
    @IBOutlet weak var phours: UILabel!
    @IBOutlet var background: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            
            id.text = try courseinfo?.array()[0].text()
            name.text = try courseinfo?.array()[1].text()
            if(try courseinfo?.array()[2].text().isEmpty == false){
                pre.text = try courseinfo?.array()[2].text()
            }else{
                pre.text = "None"
            }
            if(try courseinfo?.array()[3].text().isEmpty == false){
                co.text = try courseinfo?.array()[3].text()
            }else{
                co.text = "None"
            }
            if(try courseinfo?.array()[4].text().isEmpty == false){
                pretest.text = try courseinfo?.array()[4].text()
            }else{
                pretest.text = "None"
            }
            chours.text = try courseinfo?.array()[5].text()
            thours.text = try courseinfo?.array()[6].text()
            phours.text = try courseinfo?.array()[7].text()

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
