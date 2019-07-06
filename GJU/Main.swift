//
//  Main.swift
//  GJU
//
//  Created by wajdi muhtadi on 7/1/19.
//  Copyright © 2019 wajdi muhtadi. All rights reserved.
//

import UIKit
import SwiftSoup
class Main: UIViewController,UIScrollViewDelegate {
    @IBOutlet weak var profileimage: UIImageView!
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var studentidlabel: UILabel!
    @IBOutlet weak var majorlabel: UILabel!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var loopbacground: UIImageView!
    @IBOutlet weak var backscroll: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        scroll.delegate = self
        self.navigationItem.hidesBackButton = true;
        self.navigationItem.title = "Main"
        // Do any additional setup after loading the view.
        //loopbacground.backgroundColor = UIColor.init(patternImage: #imageLiteral(resourceName: "loop small"))
        //self.loopbacground.image = #imageLiteral(resourceName: "loopbg").resizableImage(withCapInsets: .zero,resizingMode: .tile)
        profileimage.contentMode = .scaleAspectFill
        load()

    }
    
    @IBAction func openstudyplan(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "StudyPlan") as? StudyPlan
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let foregroundScrollviewHeight = scroll.contentSize.height - scroll.bounds.height
        let percentageScroll = scroll.contentOffset.y / foregroundScrollviewHeight
        let backgroundScrollViewHeight = backscroll.contentSize.height - (backscroll.bounds.height)
        print(backscroll.contentSize.height)
        print(backscroll.bounds.height)
        print(backgroundScrollViewHeight)
        backscroll.contentOffset = CGPoint(x: 0, y: backgroundScrollViewHeight * percentageScroll)
    }
    func load(){
        let url = URL(string: "https://mygju.gju.edu.jo/faces/student_view/profile/student_profile.xhtml")!
        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            if(error == nil){
                do {
                    let doc: Document = try SwiftSoup.parse(String(decoding: data!, as: UTF8.self))
                    let image:Element = try doc.getElementById("form:j_idt51")!
                    let firstname:String = try doc.getElementById("form:j_idt57")!.text()
                    let lastname:String = try doc.getElementById("form:j_idt63")!.text()
                    let studentid:String = try doc.getElementById("form:student_id")!.text()
                    let major:String = try doc.getElementById("form:major")!.text()
                    let url = URL(string: ("https://mygju.gju.edu.jo" + (image.getAttributes()?.get(key: "src"))!))
                    let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap
                    DispatchQueue.main.async {
                        self.profileimage.image = UIImage(data: data!)
                        self.namelabel.text = "Name : "+firstname + " " + lastname
                        self.studentidlabel.text = "Student ID : "+studentid
                        self.majorlabel.text = "Major : "+major
                        for v in self.scroll.subviews[0].subviews{
                            v.isHidden = false
                        }
                        self.indicator.isHidden = true
                    }
                } catch Exception.Error( let message) {
                    print(message)
                } catch {
                    print("error")
                }
            }else{
                self.load()
            }
        })
        
        task.resume()
    }
    @IBAction func signouttap(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
        UserDefaults.standard.set(false, forKey: "autologin")
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
