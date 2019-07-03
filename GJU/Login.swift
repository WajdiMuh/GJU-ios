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

class Login: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var user: UITextField!
    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var autologin: UISwitch!
    let session = URLSession.shared
    var hiddenval:String = ""
    var hiddenvalid:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.user.delegate = self
        self.pass.delegate = self
        autologin.setOn(UserDefaults.standard.bool(forKey: "autologin"), animated: false)
        getHiddenval(finished: {
            DispatchQueue.main.async { // Make sure you're on the main thread here
                if(self.autologin.isOn){
                    self.user.text = UserDefaults.standard.string(forKey: "username")
                    self.pass.text = UserDefaults.standard.string(forKey: "password")
                    self.login(self)
                }
            }
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
                    let hidden:Element = try doc.getElementsByAttributeValue("name", "javax.faces.ViewState").first()!
                    self.hiddenval = (hidden.getAttributes()?.get(key: "value"))!
                    self.hiddenvalid = true
                    print("2")
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
        indicator.isHidden = false
        for v in self.view.subviews{
            if(v != self.indicator){
                v.isHidden = true
            }
        }
        if(hiddenvalid == false){
            getHiddenval(finished: {
                self.loginprocess()
            })

        }else{
            loginprocess()
        }
    }
    func loginprocess(){
        let url = URL(string: "https://mygju.gju.edu.jo/faces/index.xhtml")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.100 Safari/537.36", forHTTPHeaderField: "User-Agent")
        let bodyData = "j_idt20=j_idt20&j_idt20:login_username="+user.text!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!+"&j_idt20:login_password="+pass.text!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!+"&j_idt20:j_idt32=j_idt20:j_idt32&j_idt20:j_idt32:j_idt34=&javax.faces.ViewState="+self.hiddenval
        
        request.httpBody = bodyData.data(using: String.Encoding.utf8);
        let logintask = session.dataTask(with: request, completionHandler: { (responseData: Data?, response: URLResponse?, error: Error?) in
            if(error == nil){
                do {
                    DispatchQueue.main.async {
                        self.indicator.isHidden = true
                        for v in self.view.subviews{
                            if(v != self.indicator){
                                v.isHidden = false
                            }
                        }
                    }
                    self.hiddenvalid = true
                    if(String(decoding: responseData!, as: UTF8.self).contains("Welcome   to your account.")){
                        DispatchQueue.main.async { // Make sure you're on the main thread here
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
                            self.indicator.isHidden = true
                            for v in self.view.subviews{
                                if(v != self.indicator){
                                    v.isHidden = false
                                }
                            }
                            self.view.makeToast("Wrong Username/Password", duration: 1.5, position: .bottom)
                        }
                        let doc: Document = try SwiftSoup.parse(String(decoding: responseData!, as: UTF8.self))
                        //print(doc)
                        let hidden:Element = try doc.getElementsByAttributeValue("name", "javax.faces.ViewState").first()!
                        self.hiddenval = (hidden.getAttributes()?.get(key: "value"))!
                    }
                } catch Exception.Error( let message) {
                    print(message)
                } catch {
                    print("error")
                }
            }else{
                DispatchQueue.main.async { // Make sure you're on the main thread here
                    self.indicator.isHidden = true
                    for v in self.view.subviews{
                        if(v != self.indicator){
                            v.isHidden = false
                        }
                    }
                    self.view.makeToast("No Internet Connection", duration: 1.5, position: .bottom)
                    self.hiddenvalid = false
                }
            }
        })
        logintask.resume()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        user.becomeFirstResponder()
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
}

