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
    @IBOutlet weak var courseid: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var pre: UILabel!
    @IBOutlet weak var co: UILabel!
    @IBOutlet weak var pretest: UILabel!
    @IBOutlet weak var chours: UILabel!
    @IBOutlet weak var thours: UILabel!
    @IBOutlet weak var phours: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Course"
        courseid.layer.cornerRadius=8.0
        courseid.clipsToBounds=true
        name.layer.cornerRadius=8.0
        name.clipsToBounds=true
        pre.layer.cornerRadius=8.0
        pre.clipsToBounds=true
        co.layer.cornerRadius=8.0
        co.clipsToBounds=true
        pretest.layer.cornerRadius=8.0
        pretest.clipsToBounds=true
        chours.layer.cornerRadius=8.0
        chours.clipsToBounds=true
        thours.layer.cornerRadius=8.0
        thours.clipsToBounds=true
        phours.layer.cornerRadius=8.0
        phours.clipsToBounds=true
        do {
            courseid.text = try courseinfo?.array()[0].text()
            name.text = try courseinfo?.array()[1].text()
            pre.text = try courseinfo?.array()[2].text()
            co.text = try courseinfo?.array()[3].text()
            pretest.text = try courseinfo?.array()[4].text()
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
