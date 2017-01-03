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
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {

    var signInButton : GIDSignInButton!
    
    static var UserCurrent : FIRUser! = nil
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    @IBAction func signOutGoogleAccount(_ sender: Any) {
        if self.activityIndicatorView.isAnimating {
            //return
        }
        GIDSignIn.sharedInstance().signOut()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        UIGraphicsBeginImageContext(self.view.frame.size);
        let temp = UIImage(named: "background_login.jpg")
        temp?.draw(in: self.view.bounds);
        let imageCurrent = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: imageCurrent!)
        googleInit()
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicatorView.center = view.center
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
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
        let btnSignIn = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        btnSignIn.center = view.center
        btnSignIn.imageEdgeInsets = UIEdgeInsetsMake(2.0, 2.0, 2.0, 15.0)
        btnSignIn.titleEdgeInsets = UIEdgeInsetsMake(2.0, 15.0, 2.0, 2.0)
        btnSignIn.setImage(UIImage(named: "ic_google.png"), for: .normal)
        btnSignIn.setTitle("Sign In With Google", for: .normal)
        btnSignIn.tintColor = UIColor.white
        btnSignIn.layer.borderWidth = 1.0
        btnSignIn.addTarget(self, action: #selector(btnSignInPress), for: .touchUpInside)
        view.addSubview(btnSignIn)
    }
    
    func btnSignInPress() {
        GIDSignIn.sharedInstance().signIn()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if self.activityIndicatorView.isAnimating {
            return
        }
        self.activityIndicatorView.startAnimating()
        if error != nil {
            print(error)
            self.activityIndicatorView.stopAnimating()
            return
        }
        
        let authentication = user.authentication
        let credential = FIRGoogleAuthProvider.credential(withIDToken: (authentication?.idToken)!, accessToken:(authentication?.accessToken)!)
        
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil{
                self.activityIndicatorView.stopAnimating()
                return;
            }
            if user != nil {
                ViewController.UserCurrent = user
                let uid = user?.uid as String!
                let ref : FIRDatabaseReference = FIRDatabase.database().reference().child("users/\(uid!)")
                ref.observeSingleEvent(of: FIRDataEventType.value
                    , with: { snapshot in
                        if ( snapshot.value is NSNull ) {
                            ref.setValue(["name" : (user?.displayName)!, "email" : (user?.email)!, "photoUrl" : (user?.photoURL?.absoluteString)!, "id" : uid!])
                        }
                })
                self.activityIndicatorView.stopAnimating()
                let homeView = self.storyboard?.instantiateViewController(withIdentifier: "homeView") as! UITabBarController
                self.navigationController?.pushViewController(homeView, animated: true)
            }
        })
//        FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
//            
//            if user != nil {
//                ViewController.UserCurrent = user
//                let uid = user?.uid as String!
//                let ref : FIRDatabaseReference = FIRDatabase.database().reference().child("users/\(uid!)")
//                ref.observeSingleEvent(of: FIRDataEventType.value
//                    , with: { snapshot in
//                        if ( snapshot.value is NSNull ) {
//                            ref.setValue(["name" : user?.displayName!, "email" : user?.email!, "photoUrl" : user?.photoURL?.path, "id" : uid!])
//                        }
//                })
//                let storyboard = self.storyboard?.instantiateViewController(withIdentifier: "homeView")
//                self.navigationController?.pushViewController(storyboard!, animated: true)
//            }
//        })
    }
}

