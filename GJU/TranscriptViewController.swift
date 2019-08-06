//
//  TranscriptViewController.swift
//  GJU
//
//  Created by wajdi muhtadi on 7/30/19.
//  Copyright © 2019 wajdi muhtadi. All rights reserved.
//

import UIKit
import SwiftSoup
class TranscriptViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIViewControllerTransitioningDelegate {
    var semesters:[String] = ["Exempted Courses"]
    var courses:[[Element]] = []
    var extrainfo:[[String]] = []
    let transition = mvcanimator()
    @IBOutlet weak var average: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var cv: UICollectionView!
    @IBOutlet weak var cvheight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        cv.register(UINib.init(nibName: "Specialtransheader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "specialheader")
        cv.register(UINib.init(nibName: "Specialtransfooter", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "specialfooter")
        self.navigationItem.title = "Transcript"
        let url = URL(string: "https://mygju.gju.edu.jo/faces/admin_view/student_affairs/student_details/student_academic_progress/transcript/student_transcript.xhtml")!
        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            if(error == nil){
                do {
                    let doc: Document = try SwiftSoup.parse(String(decoding: data!, as: UTF8.self))
                    let semesterelements:Elements = try doc.getElementsByClass("ui-datatable-header ui-widget-header ui-corner-top")
                    for se in semesterelements{
                        self.semesters.append(try se.text())
                    }
                    let tablesofsemester:Elements = try doc.getElementsByClass("ui-datatable-data ui-widget-content")
                    for e in tablesofsemester{
                        let coursesfortable:Elements = e.children()
                        self.courses.append(coursesfortable.array())
                    }
                    let avg:String = try ((doc.getElementsContainingOwnText("Cumulative Average :").first()?.parent()?.nextElementSibling()?.child(0).text()))!
                    let rate:String = try (doc.getElementsContainingOwnText("Rating :").first()?.parent()?.nextElementSibling()?.child(0).text())!
                    let specialfoot:String = try (doc.getElementsContainingOwnText("Total Exempted").first()?.nextElementSibling()?.text())!
                    self.extrainfo.append([specialfoot])
                    let localextra:Elements = try doc.getElementsByClass("transcriptPanelGridClass")
                    for i in 0...(self.semesters.count - 2){
                        var semesterinfo:[String] = []
                        for j in 0...1{
                            for k in 1...4{
                                semesterinfo.append(try localextra.get(2 * i).child(0).child(j).child(k).child(0).child(1).text())
                            }
                        }
                        semesterinfo.append(try localextra.get((2 * i)+1).child(0).child(0).child(0).child(0).child(1).text())
                        self.extrainfo.append(semesterinfo)
                    }
                    DispatchQueue.main.async {
                        self.average.text = avg
                        self.rating.text = rate
                        self.cv.reloadData()
                        self.dismiss(animated: true, completion: {
                            self.cvheight.constant = self.cv.contentSize.height
                        })
                    }
    
                } catch Exception.Error( let message) {
                    print(message)
                } catch {
                    print("error")
                }
            }else{
                DispatchQueue.main.async {
                    self.view.makeToast("No Internet Connection", duration: 1.5, position: .bottom)
                }
                self.navigationController?.popViewController(animated: true)
                
            }
        })
        
        task.resume()
        // Do any additional setup after loading the view.
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return courses[section].count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if(courses.isEmpty == true){
            return 0
        }else{
            return semesters.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "transcell", for: indexPath) as! transcriptcell
        do {
            if(indexPath.section == 0){
                cell.grade.isHidden = true
                cell.name.text = try courses[indexPath.section][indexPath.row].children().array()[1].text()
                cell.remark.text = try courses[indexPath.section][indexPath.row].children().array()[3].text()
            }else{
                cell.grade.isHidden = false
                cell.name.text = try courses[indexPath.section][indexPath.row].children().array()[1].text()
                cell.grade.text = try courses[indexPath.section][indexPath.row].children().array()[3].text()
                if(cell.grade.text?.isEmpty == false){
                    cell.grade.text = cell.grade.text! + "%"
                }
                cell.remark.text = try courses[indexPath.section][indexPath.row].children().array()[4].text()
                cell.remark.numberOfLines = 1
                if((cell.remark.text?.contains("Fail"))!){
                    cell.remark.text = "Fail"
                }else if((cell.remark.text?.contains("Repeated"))!){
                    cell.remark.text = "Pass Repeat"
                    cell.remark.numberOfLines = 0
                }
            }
        } catch Exception.Error( let message) {
            print(message)
        } catch {
            print("error")
        }
        return cell;
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        if(kind == UICollectionView.elementKindSectionHeader){
            if(indexPath.section == 0){
                return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "specialheader", for: indexPath)
            }else{
                let sectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "transheader", for: indexPath) as! transcriptheader
                sectionHeaderView.sectionname.text = semesters[indexPath.section]
                return sectionHeaderView
            }
        }else{
            if(indexPath.section == 0){
                let sectionFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "specialfooter", for: indexPath) as! specialtransfootercode
                sectionFooterView.chours.text = "Total Exempted Credit Hours : " + extrainfo[0][0]
                sectionFooterView.setupshadow()
                return sectionFooterView
            }else{
                let sectionFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "transfooter", for: indexPath) as! transcriptfooter
                sectionFooterView.rhl.text = "Registered Hours : " + extrainfo[indexPath.section][0]
                sectionFooterView.phl.text = "Passed Hours : " + extrainfo[indexPath.section][1]
                sectionFooterView.al.text = "Average : " + extrainfo[indexPath.section][2]
                sectionFooterView.gpal.text = "GPA Hours : " + extrainfo[indexPath.section][3]
                sectionFooterView.rhr.text = "Registered Hours : " + extrainfo[indexPath.section][4]
                sectionFooterView.phr.text = "Passed Hours : " + extrainfo[indexPath.section][5]
                sectionFooterView.ar.text = "Average : " + extrainfo[indexPath.section][6]
                sectionFooterView.gpar.text = "GPA Hours : " + extrainfo[indexPath.section][7]
                sectionFooterView.tph.text = "Total Passed Hours : " + extrainfo[indexPath.section][8]
                sectionFooterView.setupshadow()
                return sectionFooterView
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cv.frame.width, height: 50)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if(section == 0){
            return CGSize(width: cv.frame.width, height: 100)
        }else{
            return CGSize(width: cv.frame.width, height: 204)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if(section == 0){
            return CGSize(width: cv.frame.width, height: 60)
        }else{
            return CGSize(width: cv.frame.width, height: 80)
        }
    }
    @IBAction func showchart(_ sender: Any) {
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "transcoursepop") as? TranscoursepopViewController
        vc?.courseinfo = courses[indexPath.section][indexPath.row].children()
        vc!.transitioningDelegate = self
        vc?.modalPresentationStyle = .overCurrentContext
        present(vc!, animated: true, completion: nil)
    }
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController, source: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
            transition.presenting = true
            return transition
    }
    func animationController(forDismissed dismissed: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
            transition.presenting = false
            return transition
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
