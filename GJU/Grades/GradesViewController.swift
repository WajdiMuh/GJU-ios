//
//  GradesViewController.swift
//  GJU
//
//  Created by wajdi muhtadi on 8/13/19.
//  Copyright © 2019 wajdi muhtadi. All rights reserved.
//

import UIKit
import SwiftSoup
class GradesViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate,UIViewControllerTransitioningDelegate{
    @IBOutlet weak var arrow: UIImageView!
    var hiddenval:String = ""
    let session = URLSession.shared
    var years:[String] = []
    var firstyear:String = ""
    let semesters:[String] = ["First","Second","Summer"]
    var header:String = ""
    var footer:[String] = []
    var gradesdata:[Element] = []
    var selected:[Int] = [0,0]
    let transition = loadingpopanimator()
    @IBOutlet weak var cv: UICollectionView!
    @IBOutlet weak var tf: nomenutextfield!
    @IBOutlet weak var noschedule: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Grades"
        let opQueue = OperationQueue()
        let operation1 = BlockOperation {
            let group = DispatchGroup()
            group.enter()
            self.getgradesget(finished: {
                group.leave()
            })
            group.enter()
            self.gettranscript(finished: {
                group.leave()
            })
            group.wait()
        }
        let input:UIInputView = UINib(nibName: "inputview", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIInputView
        let inputpicker:UIPickerView = input.viewWithTag(100) as! UIPickerView
        let inputbutton:UIButton = input.viewWithTag(99) as! UIButton
        inputbutton.addTarget(self, action: #selector(GradesViewController.toolbardone), for: .touchUpInside)
        inputpicker.dataSource = self
        inputpicker.delegate = self
        tf.inputView = input
        let operation2 = BlockOperation {
            self.years = Array(self.years.dropFirst(self.years.firstIndex(where: {$0.contains(self.firstyear)})!))
            DispatchQueue.main.async {
                var currentyear:String = self.header.components(separatedBy: "for")[1]
                currentyear.removeFirst()
                let semester:String = currentyear.components(separatedBy: " ")[0]
                let year:String = currentyear.components(separatedBy: " ")[1]
                inputpicker.selectRow(self.years.firstIndex(of: year)!, inComponent: 0, animated: false)
                inputpicker.selectRow(self.semesters.firstIndex(of: semester)!, inComponent: 1, animated: false)
                self.selected[0] = Int(year.components(separatedBy: "/")[0])!
                self.selected[1] = self.semesters.firstIndex(of: semester)! + 1
                self.tf.text = year + " " + semester
                self.cv.reloadData()
                self.dismiss(animated: true, completion: nil)
            }
        }
        operation2.addDependency(operation1)
        opQueue.addOperation(operation1)
        opQueue.addOperation(operation2)
        //input.autoresizingMask = .flexibleWidth
        //input.frame.size = CGSize.init(width: self.view.frame.width, height: 100)
    }
    func getgradesget(finished: @escaping () -> Void){
        let url = URL(string: "https://mygju.gju.edu.jo/faces/grades/student_grade.xhtml")!
        let task = session.dataTask(with: url, completionHandler: { data, response, error in
            if(error == nil){
                do {
                    let doc: Document = try SwiftSoup.parse(String(decoding: data!, as: UTF8.self))
                    let yearlist:Elements = try doc.getElementById("student_schedule_form:year_panel")!.child(0).child(0).children()
                    for e in yearlist{
                        self.years.append(try! e.text())
                    }
                    let hidden:Element = try doc.getElementsByAttributeValue("name", "javax.faces.ViewState").first()!
                    self.hiddenval = (hidden.getAttributes()?.get(key: "value"))!
                    self.header = try (doc.getElementById("student_schedule_form:schedule_tbl")?.child(0).text())!
                    if(String(decoding: data!, as: UTF8.self).contains("No schedule found for this semester") == false){
                        let coursegrades:Element = try doc.getElementById("student_schedule_form:schedule_tbl_data")!
                        for e in coursegrades.children(){
                            self.gradesdata.append(e)
                        }
                        if(try doc.getElementsByClass("transcriptPanelGridClass").isEmpty() == false){
                            let all:Element = try (doc.getElementsByClass("transcriptPanelGridClass").first()?.child(0).child(0))!
                            for e in all.children(){
                                self.footer.append(try e.child(0).child(1).text())
                            }
                        }
                    }else{
                        DispatchQueue.main.async {
                            self.cv.isHidden = true
                            self.noschedule.isHidden = false
                        }
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
    func gettranscript(finished: @escaping () -> Void){
        let url = URL(string: "https://mygju.gju.edu.jo/faces/admin_view/student_affairs/student_details/student_academic_progress/transcript/student_transcript.xhtml")!
        let task = session.dataTask(with: url, completionHandler: { data, response, error in
            if(error == nil){
                do {
                    let doc: Document = try SwiftSoup.parse(String(decoding: data!, as: UTF8.self))
                    let enrollmentyear:String = try ((doc.getElementsContainingOwnText("Enrollment Semester:").first()?.parent()?.nextElementSibling()?.child(0).text()))!
                    self.firstyear = enrollmentyear.components(separatedBy: " ")[1]
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
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(component == 0){
            return years.count
        }else{
            return semesters.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(component == 0){
            return years[row]
        }else{
            return semesters[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(component == 0){
            selected[0] = Int(self.years[row].components(separatedBy: "/")[0])!
        }else{
            selected[1] = row + 1
        }
        tf.text = self.pickerView(pickerView, titleForRow: pickerView.selectedRow(inComponent: 0), forComponent: 0)! + " " + self.pickerView(pickerView, titleForRow: pickerView.selectedRow(inComponent: 1), forComponent: 1)!
        let same:String = semesters[selected[1] - 1] + " " + String(selected[0]) + "/" + String(selected[0]+1)
        if(tf.isFirstResponder == false){
            print("dawd")
            if(header.contains(same) == false){
                getgradespost(year: selected[0], semester: selected[1])
            }
        }
    }
    @objc func toolbardone(){
        print("close")
        let same:String = semesters[selected[1] - 1] + " " + String(selected[0]) + "/" + String(selected[0]+1)
        self.view.endEditing(true)
        if(header.contains(same) == false){
            print("add")
            getgradespost(year: selected[0], semester: selected[1])
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gradesdata.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gradescell", for: indexPath) as! gradescell
            do {
                cell.name.text = try gradesdata[indexPath.row].child(1).text()
                cell.outof60.text = try gradesdata[indexPath.row].child(3).text()
                cell.mark.text = try gradesdata[indexPath.row].child(4).text()
            } catch Exception.Error( let message) {
                print(message)
            } catch {
                print("error")
            }
        if(indexPath.row == gradesdata.indices.last){
            cell.seperator.isHidden = true
        }else{
            cell.seperator.isHidden = false
        }
        return cell
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 20, height: 51)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        if(kind == UICollectionView.elementKindSectionHeader){
            let sectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "gradesheader", for: indexPath) as! gradesheader
                sectionHeaderView.title.text = header
                return sectionHeaderView
        }else{
            let sectionFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "gradesfooter", for: indexPath) as! gradesfooter
            print(footer)
            if(footer.isEmpty == false){
                for e in sectionFooterView.subviews{
                    e.isHidden = false
                }
                sectionFooterView.registeredh.text = "Registered Hours : " + footer[0]
                sectionFooterView.passh.text = "Passed Hours : " + footer[1]
                sectionFooterView.average.text = "Average : " + footer[2]
                sectionFooterView.semestergpa.text = "Semester GPA Hours : " + footer[3]
            }else{
                for e in sectionFooterView.subviews{
                    if(e.tag != 0){
                        e.isHidden = true
                    }
                }
            }
            return sectionFooterView
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("open")
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    func getgradespost(year:Int,semester:Int){
        let v = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "load") as? loadingViewController
        v?.transitioningDelegate = self
        v?.modalPresentationStyle = .overCurrentContext
        self.present(v!,animated: true){
            let url = URL(string: "https://mygju.gju.edu.jo/faces/grades/student_grade.xhtml")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.100 Safari/537.36", forHTTPHeaderField: "User-Agent")
            let bodyData = "student_schedule_form=student_schedule_form&student_schedule_form:year_input=" + String(year) + "&student_schedule_form:year_focus=&student_schedule_form:semester_input=" + String(semester) + "&student_schedule_form:semester_focus=&student_schedule_form:searchBtn=&javax.faces.ViewState=" + self.hiddenval
            request.httpBody = bodyData.data(using: String.Encoding.utf8);
            let logintask = self.session.dataTask(with: request, completionHandler: { (responseData: Data?, response: URLResponse?, error: Error?) in
                if(error == nil){
                    do {
                        self.footer.removeAll()
                        self.gradesdata.removeAll()
                        let doc: Document = try SwiftSoup.parse(String(decoding: responseData!, as: UTF8.self))
                        let semesterstring:String = self.semesters[semester - 1] + " " + String(year) + "/" + String(year+1)
                        self.header = "My Grades for " + semesterstring
                        if(String(decoding: responseData!, as: UTF8.self).contains("No schedule found for this semester") == false){
                            let coursegrades:Element = try doc.getElementById("student_schedule_form:schedule_tbl_data")!
                            for e in coursegrades.children(){
                                self.gradesdata.append(e)
                            }
                            if(try doc.getElementsByClass("transcriptPanelGridClass").isEmpty() == false){
                                let all:Element = try (doc.getElementsByClass("transcriptPanelGridClass").first()?.child(0).child(0))!
                                for e in all.children(){
                                    self.footer.append(try e.child(0).child(1).text())
                                }
                            }
                            DispatchQueue.main.async {
                                self.cv.isHidden = false
                                self.noschedule.isHidden = true
                                self.cv.reloadData()
                            }
                        }else{
                            DispatchQueue.main.async {
                                self.cv.isHidden = true
                                self.noschedule.isHidden = false
                            }
                        }
                    } catch Exception.Error( let message) {
                        print(message)
                    } catch {
                        print("error")
                    }
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                }else{
                    DispatchQueue.main.async { // Make sure you're on the main thread here
                        self.dismiss(animated: true, completion: nil)
                        self.view.makeToast("No Internet Connection", duration: 1.5, position: .bottom)
                    }
                }
            })
            logintask.resume()
        }
    }
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = true
        return transition
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
