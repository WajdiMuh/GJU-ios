//
//  Main.swift
//  GJU
//
//  Created by wajdi muhtadi on 7/1/19.
//  Copyright © 2019 wajdi muhtadi. All rights reserved.
//

import UIKit
import SwiftSoup
class Main: UIViewController,UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,headercv,UICollectionViewDelegateFlowLayout,UIViewControllerTransitioningDelegate{
    
    @IBOutlet weak var profileimage: UIImageView!
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var studentidlabel: UILabel!
    @IBOutlet weak var majorlabel: UILabel!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var loopbacground: UIImageView!
    @IBOutlet weak var backscroll: UIScrollView!
    @IBOutlet weak var pbg: UIView!
    @IBOutlet weak var bgheight: NSLayoutConstraint!
    let tabledata:[[String]] = [["My Information"],["Study Plan","Course Sections","Schedules","Evaluations","Grades","Transcript"],["Account","Tuition Calculation","Fees"],["Registration"]]
    let sections:[String] = ["Profile","Academic Affairs","Financial Affairs","Registration"]
    var expanded:[Int] = []
    let transition = loadingpopanimator()
    @IBOutlet weak var cv: UICollectionView!
    @IBOutlet weak var cvheight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        scroll.delegate = self
        self.navigationItem.hidesBackButton = true;
        self.navigationItem.title = "Main"
        // Do any additional setup after loading the view.
        //loopbacground.backgroundColor = UIColor.init(patternImage: #imageLiteral(resourceName: "loop small"))
        //self.loopbacground.image = #imageLiteral(resourceName: "loopbg").resizableImage(withCapInsets: .zero,resizingMode: .tile)
        profileimage.contentMode = .scaleAspectFill
        profileimage.layer.cornerRadius = profileimage.frame.height / 2.0
        pbg.layer.shadowColor = UIColor.black.cgColor
        pbg.layer.shadowOpacity = 1
        pbg.layer.shadowOffset = CGSize.zero
        pbg.layer.shadowRadius = 15
        pbg.layer.shadowPath = UIBezierPath(roundedRect: profileimage.bounds, cornerRadius: profileimage.frame.height / 2.0).cgPath
        pbg.layer.masksToBounds = false
        profileimage.layer.masksToBounds = true
        load()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let foregroundScrollviewHeight = scroll.contentSize.height - scroll.bounds.height
        //print(foregroundScrollviewHeight)
        let percentageScroll = scroll.contentOffset.y / foregroundScrollviewHeight
        var backgroundScrollViewHeight:CGFloat = 5//backscroll.contentSize.height - (backscroll.bounds.height)
        switch Int(scroll.contentSize.height) {
        case 556:
            backgroundScrollViewHeight = 5
            break
        case 596:
            backgroundScrollViewHeight = 15
            break
        case 636:
            backgroundScrollViewHeight = 50
            break
        case 716:
            backgroundScrollViewHeight = 100
            break
        case 756:
            backgroundScrollViewHeight = 120
            break
        case 836:
            backgroundScrollViewHeight = 120
            break
        case 876:
            backgroundScrollViewHeight = 130
            break
        case 916:
            backgroundScrollViewHeight = 150
            break
        case 956:
            backgroundScrollViewHeight = 170
            break
        case 996:
            backgroundScrollViewHeight = 190
            break
        default:
            backgroundScrollViewHeight = 5
            break
        }
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
                        self.namelabel.text = firstname.uppercased() + " " + lastname.uppercased()
                        self.studentidlabel.text = studentid
                        self.majorlabel.text = major
                        self.dismiss(animated: true, completion: nil)
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if(expanded.contains(section)){
            return tabledata[section].count;
        }else{
            return 0;
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "subm", for: indexPath) as! subsection
        //cell.name.text = courses[indexPath.section][indexPath.row].
        cell.title.text = tabledata[indexPath.section][indexPath.row]
        if(indexPath.row == 0){
            cell.shadow.isHidden = false
        }else{
            cell.shadow.isHidden = true
        }
        if(tabledata[indexPath.section].indices.contains(indexPath.row + 1) == false){
            cell.seperator.backgroundColor = UIColor.white
        }else{
            cell.seperator.backgroundColor = UIColor(red: 0.784, green: 0.784, blue: 0.784, alpha: 1.0)
        }
        return cell;
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cv.frame.width - 20, height: 40)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        let sectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "mainm", for: indexPath) as! mainsection
        sectionHeaderView.title.text = sections[indexPath.section]
        sectionHeaderView.title.tag = indexPath.section
        sectionHeaderView.delegate = self
        if(expanded.contains(indexPath.section)){
            sectionHeaderView.arrow.transform = CGAffineTransform(rotationAngle: .pi/2)
        }else{
            sectionHeaderView.arrow.transform = CGAffineTransform(rotationAngle: 0)
        }
        switch indexPath.section {
        case 0:
            sectionHeaderView.title.backgroundColor = UIColor(red: 0.047, green: 0.431, blue: 0.662, alpha: 1.0)
            break
        case 1:
            sectionHeaderView.title.backgroundColor = UIColor(red: 0.050, green: 0.458, blue: 0.698, alpha: 1.0)
            break
        case 2:
            sectionHeaderView.title.backgroundColor = UIColor(red: 0.054, green: 0.494, blue: 0.752, alpha: 1.0)
            break
        case 3:
            sectionHeaderView.title.backgroundColor = UIColor(red: 0.050, green: 0.529, blue: 0.788, alpha: 1.0)
            break
        default:
            sectionHeaderView.title.backgroundColor = UIColor(red: 0.050, green: 0.529, blue: 0.788, alpha: 1.0)
            break
        }
        return sectionHeaderView
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(indexPath.section == 1 && indexPath.row == 0){
            let v = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "load") as? loadingViewController
            v?.transitioningDelegate = self
            v?.modalPresentationStyle = .overCurrentContext
            self.present(v!, animated: true) {
                 DispatchQueue.main.async {
                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "StudyPlan") as? StudyPlan
                    self.navigationController?.pushViewController(vc!, animated: true)
                }
            }
        }
        
    }
    func didexpand(sec: Int) {
        var height:CGFloat = 160.0
        if(expanded.contains(sec) == false){
            expanded.append(sec)
        }else{
            if let itemToRemoveIndex = expanded.firstIndex(of: sec) {
                    expanded.remove(at: itemToRemoveIndex)
            }
        }
        for e in expanded{
            height += CGFloat(tabledata[e].count) * 40.0
        }
        self.cvheight.constant = height
        //self.cv.reloadData()
        //scroll.setNeedsLayout()
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut,.allowUserInteraction,.preferredFramesPerSecond60], animations: {
            self.scroll.layoutIfNeeded()
            if(self.scroll.contentSize.height - self.scroll.bounds.height > 0){
                self.scroll.setContentOffset(CGPoint.init(x: 0, y: (self.scroll.contentSize.height - self.scroll.bounds.height)), animated: true)
            }
        }, completion: nil)
        UIView.transition(with: cv, duration: 0.5, options: [.transitionCrossDissolve,.allowUserInteraction,.beginFromCurrentState,.curveEaseInOut,.preferredFramesPerSecond60], animations: {
            //Do the data reload here
            self.cv.reloadData()
        }, completion: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        expanded.removeAll()
        cv.reloadData()
        cvheight.constant = 160.0
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = true
        return transition
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
}
