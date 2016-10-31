//
//  ViewController.swift
//  imess
//
//  Created by Nhon Nguyen on 10/30/16.
//  Copyright © 2016 Nhon Nguyen. All rights reserved.
//

import UIKit
import Google
import GoogleSignIn

class ViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {

    @IBOutlet weak var signOutButton: UIButton!
    var signInButton : GIDSignInButton!
    
    @IBAction func signOutGoogleAccount(_ sender: Any) {
        GIDSignIn.sharedInstance().signOut()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        googleInit()
    }
    
    func googleInit() {
        var configError: NSError?
        GGLContext.sharedInstance().configureWithError(&configError)
        if configError != nil {
            print(configError!)
            return
        }
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        signInButton = GIDSignInButton(frame: CGRect(x: 10, y: 10, width: 50, height: 30))
        signInButton.center = view.center
        view.addSubview(signInButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            print(error)
            return
        }
        let storyboard = self.storyboard?.instantiateViewController(withIdentifier: "homeView")
        self.navigationController?.pushViewController(storyboard!, animated: true)
    }
}

