//
//  StudyPlan.swift
//  GJU
//
//  Created by wajdi muhtadi on 7/2/19.
//  Copyright © 2019 wajdi muhtadi. All rights reserved.
//

import UIKit
import SwiftSoup

class StudyPlan: UIViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate {
    var sections:Elements? = nil
    var sectionhours:[Elements] = []
    var courses: [[Element]] = []
    var matches = [[Element]]()
    var matchsection:[Int] = []
    @IBOutlet weak var searchcv: UISearchBar!
    @IBOutlet weak var table: UICollectionView!
    @IBOutlet weak var outscroll: UIScrollView!
    @IBOutlet weak var actcont: UIView!
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(searchcv.text?.count == 0 || searchcv.text == nil){
            return courses[section].count ;
        }else{
            return matches[section].count;
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if(searchcv.text?.count == 0 || searchcv.text == nil){
            return sections?.count ?? 0;
        }else{
            return matches.count;
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.size.width
        return CGSize(width: width, height: 50)
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
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Coursecontrol") as? Coursecontroller
        if(searchcv.text?.count == 0 || searchcv.text == nil){
            vc?.courseinfo = courses[indexPath.section][indexPath.row].children()
        }else{
            vc?.courseinfo = matches[indexPath.section][indexPath.row].children()
        }
            self.navigationController?.pushViewController(vc!, animated: true)
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
        table.panGestureRecognizer.require(toFail: down)
        let layout = table.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true
        self.navigationItem.title = "Study Plan"
        let url = URL(string: "https://mygju.gju.edu.jo/faces/study_plan_gen/view_std_study_plan.xhtml")!
        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            if(error == nil){
            do {
                let doc: Document = try SwiftSoup.parse(String(decoding: data!, as: UTF8.self))
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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        outscroll.setContentOffset(searchcv.superview!.frame.origin, animated: false)
    }
    @objc func downSwipe(){
        outscroll.setContentOffset(.zero, animated: true)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if(gestureRecognizer != table.panGestureRecognizer){
            if(table.contentOffset == .zero){
                return true
            }else{
                return false
            }
        }else{
            return true
        }
    }
}
