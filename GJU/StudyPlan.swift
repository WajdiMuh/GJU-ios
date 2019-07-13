//
//  StudyPlan.swift
//  GJU
//
//  Created by wajdi muhtadi on 7/2/19.
//  Copyright © 2019 wajdi muhtadi. All rights reserved.
//

import UIKit
import SwiftSoup

class StudyPlan: UIViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate {
    var sections:Elements? = nil
    var sectionhours:[Elements] = []
    var courses: [[Element]] = []
    var matches = [[Element]]()
    var matchsection:[Int] = []
    var infodata:[String] = ["Degree : ","Faculty : ","Department : ","Major : ","Study Plan : ","Enrollment Year : ","Student Status : ","Program : ","Study Plan Credit Hours : ","Account Status : "]
    @IBOutlet weak var searchcv: UISearchBar!
    @IBOutlet weak var table: UICollectionView!
    @IBOutlet weak var outscroll: UIScrollView!
    @IBOutlet weak var actcont: UIView!
    @IBOutlet weak var arrowimage: UIImageView!
    @IBOutlet weak var wholebutton: UIButton!
    @IBOutlet weak var outview: UIView!
    @IBOutlet weak var infocv: UICollectionView!
    @IBOutlet weak var pagecontrol: UIPageControl!
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == infocv){
            return 10
        }else{
            if(searchcv.text?.count == 0 || searchcv.text == nil){
                return courses[section].count ;
            }else{
                return matches[section].count;
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if(collectionView == infocv){
            return 1
        }else{
            if(searchcv.text?.count == 0 || searchcv.text == nil){
                return sections?.count ?? 0;
            }else{
                return matches.count;
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView == infocv){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! infocell
            cell.label.text = infodata[indexPath.row]
            if(cell.frame.origin.y + cell.frame.height >= infocv.frame.height){
                //print("end")
                cell.seperator.isHidden = true
            }else{
                if(infodata.indices.contains(indexPath.row + 1) == false){
                    cell.seperator.isHidden = true
                }else{
                    cell.seperator.isHidden = false
                }
            }
            return cell;
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "course", for: indexPath) as! course
                //cell.name.text = courses[indexPath.section][indexPath.row].
                if(searchcv.text?.count == 0 || searchcv.text == nil){
                    do {
                        cell.name.text = try courses[indexPath.section][indexPath.row].children().array()[1].text()
                        cell.id.text = try courses[indexPath.section][indexPath.row].children().array()[0].text()
                    } catch Exception.Error( let message) {
                        print(message)
                    } catch {
                        print("error")
                    }
                }else{
                    do {
                        cell.name.text = try matches[indexPath.section][indexPath.row].children().array()[1].text()
                        cell.id.text = try matches[indexPath.section][indexPath.row].children().array()[0].text()
                    } catch Exception.Error( let message) {
                        print(message)
                    } catch {
                        print("error")
                    }
                }
            return cell;
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if(collectionView == table){
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }else{
            return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(collectionView == table){
            let width = view.frame.size.width
            return CGSize(width: width, height: 50)
        }else{
            return CGSize(width: infocv.frame.width - 10, height: heightForLabel(text: infodata[indexPath.row], font: .systemFont(ofSize: 17.0), width: infocv.frame.width - 10) + 11.0)
        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        let sectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "title", for: indexPath) as! titleofcourses
          if(searchcv.text?.count == 0 || searchcv.text == nil){
                do {
                    sectionHeaderView.titlelabel.text = try sections?.array()[indexPath.section].text()
                    sectionHeaderView.sectionbutton.tag = indexPath.section
                } catch Exception.Error( let message) {
                    print(message)
                } catch {
                    print("error")
                }
            }else{
                do {
                    sectionHeaderView.titlelabel.text = try sections?.array()[matchsection[indexPath.section]].text()
                    sectionHeaderView.sectionbutton.tag = matchsection[indexPath.section]
                } catch Exception.Error( let message) {
                    print(message)
                } catch {
                    print("error")
                }
            }
        return sectionHeaderView
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(collectionView == table){
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Coursecontrol") as? Coursecontroller
            if(searchcv.text?.count == 0 || searchcv.text == nil){
                vc?.courseinfo = courses[indexPath.section][indexPath.row].children()
            }else{
                vc?.courseinfo = matches[indexPath.section][indexPath.row].children()
            }
                //self.navigationController?.pushViewController(vc!, animated: true)
            vc!.providesPresentationContextTransitionStyle = true
            vc!.definesPresentationContext = true
            vc?.modalTransitionStyle = .crossDissolve
            vc?.modalPresentationStyle = .overCurrentContext
            present(vc!, animated: true, completion: nil)
        }
        /*let modalViewController = Coursecontroller()
        modalViewController.modalPresentationStyle = .overCurrentContext
        present(modalViewController, animated: true, completion: nil)*/
    }
    @IBAction func headerclick(_ sender: Any) {
        let sb:UIButton = (sender as! UIButton)
        let titleofsection:UILabel = sb.superview?.viewWithTag(100) as! UILabel
        print(titleofsection.text)
        do {
            print(try sectionhours[sb.tag].array()[0].text())
            print(try sectionhours[sb.tag].array()[1].text())
        } catch Exception.Error( let message) {
            print(message)
        } catch {
            print("error")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchcv.backgroundImage = UIImage()
        let down = UISwipeGestureRecognizer(target : self, action : #selector(StudyPlan.downSwipe))
        down.direction = .down
        down.delegate = self
        self.actcont.addGestureRecognizer(down)
        let up = UISwipeGestureRecognizer(target : self, action : #selector(StudyPlan.upSwipe))
        up.direction = .up
        outview.addGestureRecognizer(up)
        table.panGestureRecognizer.require(toFail: down)
        let layout = table.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true
        self.navigationItem.title = "Study Plan"
        let url = URL(string: "https://mygju.gju.edu.jo/faces/study_plan_gen/view_std_study_plan.xhtml")!
        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            if(error == nil){
            do {
                let doc: Document = try SwiftSoup.parse(String(decoding: data!, as: UTF8.self))
                let degree:String = try (doc.getElementById("form:degree")?.text())!
                self.infodata[0] = self.infodata[0] + degree
                let faculty:String = try (doc.getElementById("form:faculty")?.text())!
                self.infodata[1] = self.infodata[1] + faculty
                let department:String = try (doc.getElementById("form:department")?.text())!
                self.infodata[2] = self.infodata[2] + department
                let major:String = try (doc.getElementById("form:major")?.text())!
                self.infodata[3] = self.infodata[3] + major
                let plan:String = try (doc.getElementById("form:plan")?.text())!
                self.infodata[4] = self.infodata[4] + plan
                let enroll:String = try (doc.getElementById("form:enrollment_year")?.text())!
                self.infodata[5] = self.infodata[5] + enroll
                let status:String = try (doc.getElementById("form:status")?.text())!
                self.infodata[6] = self.infodata[6] + status
                let program:String = try (doc.getElementById("form:program")?.text())!
                self.infodata[7] = self.infodata[7] + program
                let spch:String = try (doc.getElementById("form:j_idt61")?.parent()?.nextElementSibling()?.child(0).text())!
                self.infodata[8] = self.infodata[8] + spch
                let active:String = try (doc.getElementById("form:inactive")?.text())!
                self.infodata[9] = self.infodata[9] + active
                self.sections = try doc.getElementsByClass("ui-datatable-header ui-widget-header ui-corner-top")
                let hoursofsection:Elements = try doc.getElementsContainingOwnText("Section Total Credit Hours:")
                for e in hoursofsection{
                    let stch:Element = try e.parent()!.nextElementSibling()!.child(0)
                    let srch:Element = try e.parent()!.parent()!.nextElementSibling()!.child(1).child(0)
                    let sectionhourselement:Elements = Elements.init([stch,srch])
                    //sectionhourselement?.add(try e.parent()!.nextElementSibling()!.child(0))
                    //sectionhourselement?.add(try e.parent()!.parent()!.nextElementSibling()!.child(1).child(0))
                    self.sectionhours.append(sectionhourselement)
                }
                //print(try self.sectionhours?.first()?.parent()?.parent()?.child(1).child(0))
                let tablesofcourss:Elements = try doc.getElementsByClass("ui-datatable-data ui-widget-content")
                for i in 0...(self.sections!.count - 1){
                    let coursesforsectiion:Elements = tablesofcourss.array()[i].children()
                    self.courses.append(coursesforsectiion.array())
                    /*for j in 0...(coursesforsectiion.count - 1){
                        //print(coursesforsectiion.array()[1])
                        self.courses[i].append(coursesforsectiion.array()[j])
                    }*/
                }
                 DispatchQueue.main.async {
                    self.table.reloadData()
                    self.infocv.reloadData()
                    self.pagecontrol.numberOfPages = Int(self.infocv.contentSize.width) / Int(self.infocv.frame.width) + 1
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
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        matchsection.removeAll()
        matches.removeAll()
        for i in 0...(self.courses.count - 1){
            var matchesinsamesection:[Element] = []
            for j in 0...(self.courses[i].count - 1){
                do {
                    let name:String = try courses[i][j].child(1).text()
                    if(name.contains(searchBar.text!)){
                        matchesinsamesection.append(courses[i][j])
                    }
                } catch Exception.Error( let message) {
                    print(message)
                } catch {
                    print("error")
                }
                
            }
            if(matchesinsamesection.isEmpty == false){
                matches.append(matchesinsamesection)
                matchsection.append(i)
            }
        }
        table.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchcv.resignFirstResponder()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    /*override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        outscroll.setContentOffset(searchcv.superview!.frame.origin, animated: false)
    }*/
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        outscroll.layoutIfNeeded()
        outscroll.setContentOffset(searchcv.superview!.frame.origin, animated: false)
        wholebutton.isHidden = true
        self.arrowimage.transform = .identity
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    @objc func downSwipe(){
        self.view.endEditing(true)
        wholebutton.isHidden = false
        UIView.transition(with: arrowimage, duration: 0.5, options: [.allowUserInteraction,.beginFromCurrentState,.curveEaseInOut,.preferredFramesPerSecond60], animations: {
            self.arrowimage.transform = CGAffineTransform(rotationAngle: .pi)
        }, completion: nil)
        outscroll.setContentOffset(.zero, animated: true)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    @objc func upSwipe(){
        wholebutton.isHidden = true
        UIView.transition(with: arrowimage, duration: 0.5, options: [.allowUserInteraction,.beginFromCurrentState,.curveEaseInOut,.preferredFramesPerSecond60], animations: {
            self.arrowimage.transform = .identity
        }, completion: nil)
        outscroll.setContentOffset(searchcv.superview!.frame.origin, animated: true)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if(wholebutton.isHidden == true){
            if(gestureRecognizer != table.panGestureRecognizer){
                if(table.contentOffset == .zero){
                    return true
                }else{
                    return false
                }
            }else{
                return true
            }
        }else{
            return false
        }
    }
    @IBAction func arrowclick(_ sender: Any) {
        self.view.endEditing(true)
        wholebutton.isHidden = false
        UIView.transition(with: arrowimage, duration: 0.5, options: [.allowUserInteraction,.beginFromCurrentState,.curveEaseInOut,.preferredFramesPerSecond60], animations: {
            self.arrowimage.transform = CGAffineTransform(rotationAngle: .pi)
        }, completion: nil)
        outscroll.setContentOffset(.zero, animated: true)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    @IBAction func wholetap(_ sender: Any, forEvent event: UIEvent) {
        guard let touch = event.allTouches?.first else { return }
        if(touch.tapCount == 1){
            wholebutton.isHidden = true
            UIView.transition(with: arrowimage, duration: 0.5, options: [.allowUserInteraction,.beginFromCurrentState,.curveEaseInOut,.preferredFramesPerSecond60], animations: {
                self.arrowimage.transform = .identity
            }, completion: nil)
            outscroll.setContentOffset(searchcv.superview!.frame.origin, animated: true)
            navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        }
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
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if(scrollView == infocv){
            //print(Float(scrollView.contentOffset.x / scrollView.frame.width).rounded())
            pagecontrol.currentPage = Int(Float(scrollView.contentOffset.x / scrollView.frame.width).rounded())
        }
    }
}
