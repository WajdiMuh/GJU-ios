//
//  StudyPlan.swift
//  GJU
//
//  Created by wajdi muhtadi on 7/2/19.
//  Copyright © 2019 wajdi muhtadi. All rights reserved.
//

import UIKit
import SwiftSoup
import Lottie

class StudyPlan: UIViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate,UIViewControllerTransitioningDelegate {
    var sections:[Section] = []
    var matches:[Section] = []
    let transition = mvcanimator()
    @IBOutlet weak var searchcv: UISearchBar!
    @IBOutlet weak var table: UICollectionView!
    @IBOutlet weak var actcont: UIView!
    @IBOutlet weak var noresults: UILabel!
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if(searchcv.text?.count == 0 || searchcv.text == nil){
                return sections[section].courses.count ;
            }else{
                return matches[section].courses.count;
            }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
            if(searchcv.text?.count == 0 || searchcv.text == nil){
                return sections.count;
            }else{
                return matches.count;
            }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "course", for: indexPath) as! course
            cell.correct.tintColor = UIColor.black
            cell.correct.image = UIImage(named: "correct")?.withRenderingMode(.alwaysTemplate)
                if(searchcv.text?.count == 0 || searchcv.text == nil){
                    cell.name.text = sections[indexPath.section].courses[indexPath.row].name
                    cell.id.text = sections[indexPath.section].courses[indexPath.row].id
                    if(sections[indexPath.section].courses[indexPath.row].remark != "No"){
                        cell.correct.isHidden = false
                    }else{
                        cell.correct.isHidden = true
                    }
                }else{
                    cell.name.text = matches[indexPath.section].courses[indexPath.row].name
                    cell.id.text = matches[indexPath.section].courses[indexPath.row].id
                    if(matches[indexPath.section].courses[indexPath.row].remark != "No"){
                        cell.correct.isHidden = false
                    }else{
                        cell.correct.isHidden = true
                    }
                }
            return cell;
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if(collectionView == table){
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }else{
            return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = view.frame.size.width
            return CGSize(width: width, height: 50)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        let sectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "title", for: indexPath) as! titleofcourses
          if(searchcv.text?.count == 0 || searchcv.text == nil){
                    if(sections[indexPath.section].courses.count != 0){
                        sectionHeaderView.nocourses.isHidden = true
                    }else{
                        sectionHeaderView.nocourses.isHidden = false
                    }
                    sectionHeaderView.titlelabel.text = sections[indexPath.section].name
                    sectionHeaderView.sectionbutton.tag = indexPath.section
            if(Int(sections[indexPath.section].sectionpassedcredithours!)! >= Int(sections[indexPath.section].sectionrequiredcredithours!)!){
                    sectionHeaderView.correct.isHidden = false
                }else{
                    sectionHeaderView.correct.isHidden = true
                }
            }else{
                sectionHeaderView.titlelabel.text = matches[indexPath.section].name
                sectionHeaderView.sectionbutton.tag = indexPath.section
                if(Int(matches[indexPath.section].sectionpassedcredithours!)! >= Int(matches[indexPath.section].sectionrequiredcredithours!)!){
                        sectionHeaderView.correct.isHidden = false
                    }else{
                        sectionHeaderView.correct.isHidden = true
                    }
            }
        return sectionHeaderView
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(collectionView == table){
            if(searchcv.isFirstResponder == false){
                //self.view.endEditing(true)
                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Coursecontrol") as? Coursecontroller
                if(searchcv.text?.count == 0 || searchcv.text == nil){
                    vc?.courseinfo = sections[indexPath.section].courses[indexPath.row]
                }else{
                    vc?.courseinfo = matches[indexPath.section].courses[indexPath.row]
                }
                vc!.transitioningDelegate = self
                vc?.modalPresentationStyle = .overCurrentContext
                present(vc!, animated: true, completion: nil)
            }else{
                self.view.endEditing(true)
            }
        }
    }
    @IBAction func headerclick(_ sender: Any) {
        if(searchcv.isFirstResponder == false){
            let sb:UIButton = (sender as! UIButton)
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Sectioncontrol") as? Sectioncontroller
            vc?.info = sections[sb.tag]
            vc!.transitioningDelegate = self
            vc?.modalPresentationStyle = .overCurrentContext
            present(vc!, animated: true, completion: nil)
        }else{
            self.view.endEditing(true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchcv.backgroundImage = UIImage()
        table.backgroundView = UIView(frame:table.bounds)
        let layout = table.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true
        self.navigationItem.title = "Study Plan"
        self.getstudyplan(finished: {
            DispatchQueue.main.async {
                self.table.reloadData()
                self.dismiss(animated: true, completion: nil)
            }
        })
        // Do any additional setup after loading the view.
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        matches.removeAll()
        for section in sections{
            let matchsection:Section = Section(name: section.name!, sectiontotalcredithours: section.sectiontotalcredithours, sectionrequiredcredithours: section.sectionrequiredcredithours, sectionpassedcredithours: section.sectionpassedcredithours)
            matchsection.courses.removeAll()
            for coursematch in section.courses{
                if(coursematch.name.contains(searchBar.text!)){
                    matchsection.courses.append(coursematch)
                }
            }
            if(matchsection.courses.count > 0){
                matches.append(matchsection)
            }
        }
        table.reloadData()
        if(matches.isEmpty == false){
            noresults.isHidden = true
        }else{
            if(searchText.isEmpty == true){
                noresults.isHidden = true
            }else{
                noresults.isHidden = false
            }
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchcv.resignFirstResponder()
    }
    func heightForLabel(text:String, font:UIFont, width:CGFloat) -> CGFloat
    {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
        
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
    func getstudyplan(finished: @escaping () -> Void){
        let url = URL(string: "https://mygju.gju.edu.jo/faces/student_view/student_plan_transcript_courses.xhtml")!
        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            if(error == nil){
                do {
                    let doc: Document = try SwiftSoup.parse(String(decoding: data!, as: UTF8.self))
                    let sectionheaders:Elements = try doc.getElementsByClass("ui-datatable-header ui-widget-header ui-corner-top")
                    for header in sectionheaders{
                        self.sections.append(Section(name: try header.text(), sectiontotalcredithours: nil, sectionrequiredcredithours: nil, sectionpassedcredithours: nil))
                    }
                    let totalhoursofsections:Elements = try doc.getElementsContainingOwnText("Section Total Credit Hours:")
                    for (index,totalhourofsection) in totalhoursofsections.enumerated(){
                        let stch:Element = try totalhourofsection.parent()!.nextElementSibling()!.child(0)
                        self.sections[index].sectiontotalcredithours = try stch.text()
                    }
                    let tablesofcourses:Slice<Elements> = try doc.getElementsByClass("ui-datatable-data ui-widget-content").dropFirst().dropLast(2)
                    for (index,tablepersection) in tablesofcourses.enumerated(){
                        for coursehtml in tablepersection.children(){
                            let course:Course
                            if(try coursehtml.text().contains("No courses found") == false){
                                course = Course(id: try coursehtml.child(0).text(), name: try coursehtml.child(1).text(), credithours: try coursehtml.child(4).text(), grade: nil, remark: try coursehtml.child(7).text(), prerequisites: try coursehtml.child(2).text(), corequisites: try coursehtml.child(3).text(), theoreticalhours: try coursehtml.child(5).text(), practicalhours: try coursehtml.child(6).text())
                                self.sections[index].courses.append(course)
                            }
                        }
                    }
                    let tableofsectionshours:Element = try doc.getElementsByClass("ui-datatable-data ui-widget-content").last()!
                    for (index,sectionhours) in tableofsectionshours.children().enumerated(){
                        self.sections[index].sectionrequiredcredithours = try sectionhours.child(1).text()
                        self.sections[index].sectionpassedcredithours = try sectionhours.child(2).text()
                    }
                } catch Exception.Error( let message) {
                    print(message)
                } catch {
                    print("error")
                }
                finished()
            }else{
                DispatchQueue.main.async {
                    self.view.makeToast("No Internet Connection", duration: 1.5, position: .bottom)
                }
                self.dismiss(animated: true, completion: {
                    self.navigationController?.popViewController(animated: true)
                })
            }
        })
        task.resume()
    }
}
