//
//  StudyPlan.swift
//  GJU
//
//  Created by wajdi muhtadi on 7/2/19.
//  Copyright © 2019 wajdi muhtadi. All rights reserved.
//

import UIKit
import SwiftSoup

class StudyPlan: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    var sections:Elements? = nil
    var courses: [[Element]] = []
    @IBOutlet weak var table: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return courses[section].count ;
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections?.count ?? 0;
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "course", for: indexPath) as! course
            //cell.name.text = courses[indexPath.section][indexPath.row].
            do {
                cell.name.text = try courses[indexPath.section][indexPath.row].children().array()[1].text()
                cell.id.text = try courses[indexPath.section][indexPath.row].children().array()[0].text()
            } catch Exception.Error( let message) {
                print(message)
            } catch {
                print("error")
            }
        return cell;
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        let sectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "title", for: indexPath) as! titleofcourses
        do {
            sectionHeaderView.titlelabel.text = try sections?.array()[indexPath.section].text()

        } catch Exception.Error( let message) {
            print(message)
        } catch {
            print("error")
        }
        return sectionHeaderView
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Coursecontrol") as? Coursecontroller
            vc?.courseinfo =  courses[indexPath.section][indexPath.row].children()
            self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func headerclick(_ sender: Any) {
        let titleofsection:UILabel = (sender as! UIButton).superview?.viewWithTag(100) as! UILabel
        print(titleofsection.text)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Study Plan"
        let url = URL(string: "https://mygju.gju.edu.jo/faces/study_plan_gen/view_std_study_plan.xhtml")!
        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            if(error == nil){
            do {
                let doc: Document = try SwiftSoup.parse(String(decoding: data!, as: UTF8.self))
                self.sections = try doc.getElementsByClass("ui-datatable-header ui-widget-header ui-corner-top")
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
