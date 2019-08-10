//
//  ViewController.swift
//  GJU
//
//  Created by wajdi muhtadi on 7/1/19.
//  Copyright © 2019 wajdi muhtadi. All rights reserved.
//

import UIKit
import SwiftSoup
import Toast_Swift
import Lottie
import TextFieldEffects
class Login: UIViewController,UITextFieldDelegate,UIViewControllerTransitioningDelegate {
    @IBOutlet weak var hspass: UIButton!
    @IBOutlet weak var user: JiroTextField!
    @IBOutlet weak var pass: JiroTextField!
    @IBOutlet weak var indicator: AnimationView!
    @IBOutlet weak var autologin: UISwitch!
    @IBOutlet weak var background: UIImageView!
    let transition = loadingpopanimator()
    let session = URLSession.shared
    var hiddenval:[String] = ["","","",""]
    var hiddenvalid:Bool = false
    var firsttime:Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        pass.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        pass.rightViewMode = .never
        let gradient = CAGradientLayer()
        gradient.opacity = 0.8
        gradient.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        gradient.colors = [UIColor(red:0.05, green:0.53, blue:0.79, alpha:1).cgColor,UIColor(red:0.97, green:0.66, blue:0.0, alpha:0.5).cgColor]
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint.zero
        gradient.endPoint = CGPoint(x: 1.15, y: 1.15)
        background.layer.addSublayer(gradient)
        autologin.setOn(UserDefaults.standard.bool(forKey: "autologin"), animated: false)
        self.user.delegate = self
        self.pass.delegate = self
        getHiddenval(finished: {
        })
        // Do any additional setup after loading the view.
    }

    func getHiddenval(finished: @escaping () -> Void){
        let url = URL(string: "https://mygju.gju.edu.jo/faces/index.xhtml")!
        let task = session.dataTask(with: url, completionHandler: { data, response, error in
            if(error == nil){
                do {
                    let doc: Document = try SwiftSoup.parse(String(decoding: data!, as: UTF8.self))
                    //print(doc)
                    let forms: Elements = try doc.select("form")
                    self.hiddenval[0] = forms.first()!.id()
                    self.hiddenval[1] = try (doc.getElementsByAttributeValue("type", "hidden").array()[1].getAttributes()?.get(key: "name"))!
                    self.hiddenval[2] = try (doc.getElementsByClass("ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only").first()?.id())!
                    let hidden:Element = try doc.getElementsByAttributeValue("name", "javax.faces.ViewState").first()!
                    self.hiddenval[3] = (hidden.getAttributes()?.get(key: "value"))!
                    self.hiddenvalid = true
                } catch Exception.Error( let message) {
                    print(message)
                } catch {
                    print("wajdi")
                }
            }else{
                //print(error)
                self.hiddenvalid = false
            }
            finished()
        })
        task.resume()
    }
    @IBAction func login(_ sender: Any) {
        let v = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "load") as? loadingViewController
        v?.transitioningDelegate = self
        v?.modalPresentationStyle = .overCurrentContext
        self.present(v!, animated: true) {
            if(self.hiddenvalid == false){
                self.getHiddenval(finished: {
                    self.loginprocess()
                })
                
            }else{
                self.loginprocess()
            }
        }
        
    }
    func loginprocess(){
        let url = URL(string: "https://mygju.gju.edu.jo/faces/index.xhtml")!
        var request = URLRequest(url: url)
        DispatchQueue.main.async { // Make sure you're on the main thread here
            self.hspass.isHidden = true
            self.view.endEditing(true)
        }
        request.httpMethod = "POST"
        request.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.100 Safari/537.36", forHTTPHeaderField: "User-Agent")
        let bodyData = self.hiddenval[0]+"="+self.hiddenval[0]+"&"+self.hiddenval[0]+":login_username="+user.text!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!+"&"+self.hiddenval[0]+":login_password="+pass.text!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!+"&"+self.hiddenval[1]+"="+self.hiddenval[1]+"&"+self.hiddenval[2]+"=&javax.faces.ViewState="+self.hiddenval[3]
        
        request.httpBody = bodyData.data(using: String.Encoding.utf8);
        let logintask = session.dataTask(with: request, completionHandler: { (responseData: Data?, response: URLResponse?, error: Error?) in
            if(error == nil){
                do {
                    self.hiddenvalid = true
                    if(String(decoding: responseData!, as: UTF8.self).contains("Welcome   to your account.")){
                        DispatchQueue.main.async { // Make sure you're on the main thread here
                            self.pass.isSecureTextEntry = true
                            if(self.autologin.isOn){
                                UserDefaults.standard.set(self.user.text!,forKey: "username")
                                UserDefaults.standard.set(self.pass.text!,forKey: "password")
                                UserDefaults.standard.set(true, forKey: "autologin")
                            }else{
                                UserDefaults.standard.set(false, forKey: "autologin")
                            }
                            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Main") as? Main
                            self.navigationController?.pushViewController(vc!, animated: true)
                        }
                    }else{
                        DispatchQueue.main.async { // Make sure you're on the main thread here
                            self.dismiss(animated: true, completion: nil)
                            self.view.makeToast("Wrong Username/Password", duration: 1.5, position: .bottom)
                        }
                        let doc: Document = try SwiftSoup.parse(String(decoding: responseData!, as: UTF8.self))
                        //print(doc)
                        let hidden:Element = try doc.getElementsByAttributeValue("name", "javax.faces.ViewState").first()!
                        self.hiddenval[3] = (hidden.getAttributes()?.get(key: "value"))!
                    }
                } catch Exception.Error( let message) {
                    print(message)
                } catch {
                    print("error")
                }
            }else{
                DispatchQueue.main.async { // Make sure you're on the main thread here
                    self.dismiss(animated: true, completion: nil)
                    self.view.makeToast("No Internet Connection", duration: 1.5, position: .bottom)
                    self.hiddenvalid = false
                }
            }
        })
        logintask.resume()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.navigationBar.barStyle = .black
        self.hspass.isHidden = true
        autologin.setOn(UserDefaults.standard.bool(forKey: "autologin"), animated: false)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == user {
            textField.resignFirstResponder()
            pass.becomeFirstResponder()
        } else if textField == pass {
            textField.resignFirstResponder()
            login(self)
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField == pass){
            hspass.isHidden = false
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if(textField == pass){
            hspass.isHidden = true
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func hspassclick(_ sender: Any) {
        pass.isSecureTextEntry.toggle()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if(firsttime == true){
            indicator.play(fromProgress: 0.0, toProgress: 1.0, loopMode: .playOnce) { _ in
                if(self.autologin.isOn){
                    self.user.text = UserDefaults.standard.string(forKey: "username")
                    self.pass.text = UserDefaults.standard.string(forKey: "password")
                    self.login(self)
                }
                for v in self.view.subviews{
                    if(v != self.indicator){
                        v.isHidden = false
                        UIView.transition(with: v, duration: 0.5, options: [.curveEaseInOut], animations: {
                            v.alpha = 1.0
                        }, completion: nil)
                    }else{
                        v.isHidden = true
                        UIView.transition(with: v, duration: 0.5, options: [.curveEaseInOut], animations: {
                            v.alpha = 0.0
                        }, completion: nil)
                    }
                }
                self.hspass.isHidden = true
            }
            firsttime = false
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
}

