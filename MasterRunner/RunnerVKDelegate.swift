//
//  RunnerVKDelegate.swift
//  MasterRunner
//
//  Created by Igor Sinyakov on 20/12/2016.
//  Copyright © 2016 Igor Sinyakov. All rights reserved.
//

import VK_ios_sdk
import UIKit

/*
class RunnerVkSdkDelegate : VKSdkUIDelegate
{
    public func vkSdkShouldPresent(_ controller: UIViewController!)
    {
    }
    
    
    /**
     Calls when user must perform captcha-check.
     If you implementing this method by yourself, call -[VKError answerCaptcha:] method for captchaError with user entered answer.
     
     @param captchaError error returned from API. You can load captcha image from <b>captchaImg</b> property.
     */
    public func vkSdkNeedCaptchaEnter(_ captchaError: VKError!)
    {}
    
    
    /**
     * Called when a controller presented by SDK will be dismissed.
     */
    
    public func vkSdkWillDismiss(_ controller: UIViewController!)
    {
    }
    
    
    /**
     * Called when a controller presented by SDK did dismiss.
     */
    public func vkSdkDidDismiss(_ controller: UIViewController!)
    {}
    
}
 
class

class RunnerVKDelegate: VKDelegate {
    let appID = "4994842"
    let scope: Set<VK.Scope> = [.messages,.offline,.friends,.wall,.photos,.audio,.video,.docs,.market,.email]
    
    
    
    init() {
        VK.config.logToConsole = true
        VK.configure(withAppId: appID, delegate: self)
    }
    
    
    
    func vkWillAuthorize() -> Set<VK.Scope> {
        return scope
    }
    
    
    
    func vkDidAuthorizeWith(parameters: Dictionary<String, String>) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "TestVkDidAuthorize"), object: nil)
    }
    
    
    
    
    func vkAutorizationFailedWith(error: AuthError) {
        print("Autorization failed with error: \n\(error)")
        NotificationCenter.default.post(name: Notification.Name(rawValue: "TestVkDidNotAuthorize"), object: nil)
    }
    
    
    
    func vkDidUnauthorize() {}
    
    
    
    func vkShouldUseTokenPath() -> String? {
        return nil
    }
    
    
    
    #if os(OSX)
    func vkWillPresentView() -> NSWindow? {
    return NSApplication.shared().windows[0]
    }
    #endif
    
    
    
    #if os(iOS)
    func vkWillPresentView() -> UIViewController {
        return UIApplication.shared.delegate!.window!!.rootViewController!
    }
    #endif
}
*/
