//
//  ViewController.swift
//  Walltones
//
//  Created by Ravi Dubey on 6/21/18.
//  Copyright © 2018 Ravi Dubey. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import GoogleSignIn
import PKHUD


func StartSpinner() {
    PKHUD.sharedHUD.contentView = PKHUDProgressView()
    PKHUD.sharedHUD.show()
}

func StopSpinner() {
    PKHUD.sharedHUD.hide(true)
}

enum labeledSpinnerType {
    case success
    case error
}
func StartLabeledSpinner(type:labeledSpinnerType,title:String,message:String,hide after:Double) {
    switch type {
    case .success:
        HUD.flash(.labeledSuccess(title: title, subtitle: message), onView: nil, delay: after) { (done) in
            if done{
                HUD.hide()
            }
        }
    case .error:
        HUD.flash(.labeledError(title: title, subtitle: message), onView: nil, delay: after) { (done) in
            if done{
                HUD.hide()
            }
        }
    }
    
}


class ViewController: UIViewController,GIDSignInUIDelegate,GIDSignInDelegate {
   
    @IBOutlet weak var btnLoginFB: FBSDKLoginButton!
    
    @IBOutlet weak var btnGmail: UIButton!
    
    @IBOutlet weak var btnEmail: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let key = UserDefaults.standard.object(forKey:"is_login")
        {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }
        // Do any additional setup after loading the view, typically from a nib.
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        btnLoginFB.layer.cornerRadius = 30.0
        btnGmail.layer.cornerRadius = 30.0
        btnEmail.layer.cornerRadius = 30.0

        btnLoginFB.clipsToBounds = true
        btnEmail.clipsToBounds = true
        btnGmail.clipsToBounds = true


        
        

    }
    
    
    @IBAction func LoginwithEmail(_ sender: Any) {
        
        
    }
    
   
    //MARK:- Login with Gmail action

    @IBAction func Gmaillogin(_ sender: Any) {
    
        GIDSignIn.sharedInstance().signIn()
    }
    
    //MARK:- Gmail delegate methods

    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        viewController.dismiss(animated: true, completion: nil)
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            
          
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
            self.navigationController?.pushViewController(nextViewController, animated: true)
            nextViewController.email = email!
            nextViewController.username = fullName!
            nextViewController.type = 1
            if user.profile.hasImage{
                // crash here !!!!!!!! cannot get imageUrl here, why?
                // let imageUrl = user.profile.imageURLWithDimension(120)
                let imageUrl = signIn.currentUser.profile.imageURL(withDimension: 120)
                print(" image url: ", imageUrl?.absoluteString)
                
                nextViewController.profilepicture = (imageUrl?.absoluteString)!
                
            }
            
            // ...
        }
    }
   
    //MARK:- Login with facebook action
    @IBAction func LoginFB(_ sender: Any) {
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.loginBehavior = FBSDKLoginBehavior.web
        fbLoginManager.logIn(withReadPermissions: ["email","user_photos"], from: self) { (result, error) in
            if (error == nil){
                if (result?.isCancelled)!{
                    return
                }
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                  
                     
                        self.getFBUserData()
                    
                }
            }
        }
    }
    
    
    
 //MARK:- Get user data from facebook
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email, gender, friendlists, friends"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                
                  var  dict = result as! [String : AnyObject]
                 
                    var name  = dict["name"]
                    var email  = dict["email"]

                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
                    self.navigationController?.pushViewController(nextViewController, animated: true)
                    
                    
                    if let imageURL = ((dict["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
                       nextViewController.profilepicture = imageURL
                        }
                    nextViewController.type = 0

                    nextViewController.email = email as! String
                    nextViewController.username = name as! String

                    
                  
                }
            })
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

