//
//  LoginViewController.swift
//  MasterRunner
//
//  Контроллер для идентификации пользователя 
//
//  Created by Igor Sinyakov on 15/12/2016.
//  Copyright © 2016 Igor Sinyakov. All rights reserved.
//

import Foundation
import UIKit
import VK_ios_sdk

import Firebase
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController , VKSdkDelegate, VKSdkUIDelegate{
    
    
    // MARK: Model
    let password_salt = "MasterRunner"
    
    enum UserLoginMode {
        case vkloginMode
        case emailLoginMode
        case unknow
    }
    
    var userLoginMode = UserLoginMode.unknow
    
    var email       = ""
    var password    = ""
    var fir_password = ""
    
    
    // MARK: GUI
    
    @IBOutlet weak var textUserEmail: UITextField!
    //static let instanceLoginVC? : LoginViewController
    
    @IBOutlet weak var textUserPassword: UITextField!
    var db: FIRDatabaseReference!
    
    
    // return back from this MVC to Splash MVC
    func back()
    {
        // leave login page
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
    }
    
    // initilize view on load
    override func viewDidLoad() {
        super.viewDidLoad()
        FIRApp.initialize()
        
        sdkInstance!.register(self)
        sdkInstance!.uiDelegate = self
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: VK delegate actions
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        
        show(controller, sender: self)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        
    }
    
    func vkSdkUserAuthorizationFailed() {
        print("vkSdkUserAuthorizationFailed error")
        
    }
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        // try loing to FireBase with VKLogin
        guard result.token != nil else {
            return
        }
        
        userLoginMode = .vkloginMode
        email = VKSdk.accessToken().email
        fir_password = String.md5(source: email+password_salt)

        FIRAuth.auth()?.createUser(withEmail: email, password: fir_password, completion: { (user, error) in
            print(error.debugDescription)
            if (user != nil) {
                self.back()
            }
        })

    }

    // MARK:Actions
    
    // try to login wiht VK
    @IBAction func touchLoginVKUser(_ sender: UIButton) {
        // permission to VK account
        let scope = ["friends", "email"]
        VKSdk.wakeUpSession(scope, complete: {(state: VKAuthorizationState, error: Error?) -> Void in
            if state == .authorized {
                NSLog("vk authorized")
                
            } else {
                VKSdk.authorize(scope)
            }
            return
        })
    }
  
    @IBAction func touchLoginExistingUser(_ sender: UIButton) {
        let em = textUserEmail.text!
        let ps = textUserPassword.text!
        
        if em == "" {
            // warning
            messageBox(title: "Ошибка авторизации", text: "Введите корректный email")
            
            return
        }
        
        if ps == "" {
            // warning
            messageBox(title: "Ошибка авторизации", text: "Поле пароль не может быть пустым")
            return
        }
        
        password = textUserPassword.text!
        fir_password = String.md5(source: email+password_salt)
        email = textUserEmail.text!
        //
        
        FIRAuth.auth()?.signIn(withEmail: email, password: fir_password, completion: { (user, error) in
            print(error.debugDescription)
            if (user != nil) {
               self.back()
            } else {
                self.messageBox(title: "Ошибка авторизации", text: error!.localizedDescription)
            }
            
        })
        
    }
    
    @IBAction func touchCreateNewUser(_ sender: UIButton) {
        
    }
    
   
    // show queue safe message box
    func messageBox(title: String, text: String) {
        // leave login page
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: text, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil ))
            self.present(alert, animated: true, completion: nil)
        }
    }
   
}


extension String {
    static func md5(source : String) -> String {
        
        let context = UnsafeMutablePointer<CC_MD5_CTX>.allocate(capacity:1)
        var digest = Array<UInt8>(repeating: 0, count:Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5_Init(context)
        CC_MD5_Update(context, source, CC_LONG(source.lengthOfBytes(using: String.Encoding.utf8)))
        CC_MD5_Final(&digest, context)
        context.deallocate(capacity: 1)
        var hexString = ""
        for byte in digest {
            hexString += String(format: "%2x", byte)
        }
    
        return hexString
    }
}



/*  EXAMPLE hot to parse json
 func qtest(responce: VKResponse<VKApiObject>) {
 // a million hours of sex to get this string
 if let wall = responce.json as? Dictionary<String,AnyObject> {
 let test = wall["itesm"]
 if let items = wall["items"] as? NSArray {
 @IBAction func touchLoginExistingUser(_ sender: UIButton) {
 }
 print(items)
 }
 }
 }
 
 @IBAction func testGroup(_ sender: Any) {
 @IBOutlet weak var touchLoginExistingUser: UIButton!
 @IBAction func touchCreateNewUser(_ sender: UIButton) {
 }
 // try to get wall
 
 let req = VKApi.request(withMethod: "wall.get", andParameters: ["domain" : "begoman"])
 req?.addExtraParameters(["count" : 1])
 req?.execute(resultBlock: {response in
 self.qtest(responce: response!)
 }, errorBlock: { (error) in
 })
 }
 */
