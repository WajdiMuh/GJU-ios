//
//  TranscriptViewController.swift
//  GJU
//
//  Created by wajdi muhtadi on 7/30/19.
//  Copyright © 2019 wajdi muhtadi. All rights reserved.
//

import UIKit
import SwiftSoup
class TranscriptViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    var semesters:[String] = ["Exempted Courses"]
    var courses:[[Element]] = []
    @IBOutlet weak var average: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var cv: UICollectionView!
    @IBOutlet weak var cvheight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        cv.register(UINib.init(nibName: "Specialtransheader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "specialheader")
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
                    let avg:String = try (doc.getElementById("student_transcript_form:j_idt77")?.text())!
                    let rate:String = try (doc.getElementById("student_transcript_form:j_idt79")?.text())!
                    print(rate)
                    for i in 0...(self.semesters.count - 1){
                        print(self.semesters[i])
                        for co in self.courses[i]{
                            print(try co.child(1).text())
                        }
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
            let sectionFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "transfooter", for: indexPath) as! transcriptfooter
            return sectionFooterView
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cv.frame.width, height: 50)
    }
    /*func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
     
    }*/
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
        print(indexPath)
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
