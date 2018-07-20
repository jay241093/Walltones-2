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
import Alamofire
import SDWebImage


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
    
    var regtype = 2
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        if let key = UserDefaults.standard.object(forKey:"is_login")
        {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }
        // Do any additional setup after loading the view, typically from a nib.
     
        btnLoginFB.layer.cornerRadius = 30.0
        btnGmail.layer.cornerRadius = 30.0
        btnEmail.layer.cornerRadius = 30.0

        btnLoginFB.clipsToBounds = true
        btnEmail.clipsToBounds = true
        btnGmail.clipsToBounds = true


        
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
     
        
    }
    @IBAction func LoginwithEmail(_ sender: Any) {
        
        
    }
    
   
    //MARK:- Login with Gmail action

    @IBAction func Gmaillogin(_ sender: Any) {
    
        GIDSignIn.sharedInstance().signIn()
    }
    
    //MARK:- Gmail delegate methods

   
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
            
            self.regtype = 1

            if user.profile.hasImage{
                // crash here !!!!!!!! cannot get imageUrl here, why?
                // let imageUrl = user.profile.imageURLWithDimension(120)
                let imageUrl = signIn.currentUser.profile.imageURL(withDimension: 120)
                print(" image url: ", imageUrl?.absoluteString)
                signaction(username: givenName!, email: email!, imageurl: (imageUrl?.absoluteString)!)

                
            }
            GIDSignIn.sharedInstance().disconnect()

            // ...
        }
    }
   
    //MARK:- Login with facebook action
    @IBAction func LoginFB(_ sender: Any) {
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.loginBehavior = FBSDKLoginBehavior.web
       fbLoginManager.logOut()
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
            else
            {
              print(error?.localizedDescription)
                
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
                     self.regtype = 0
                    if let imageURL = ((dict["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
                        
                        self.signaction(username: name as! String, email: email as! String, imageurl: imageURL)
                       
                    }
                    
        
                }
                else
                {
                  print(error?.localizedDescription)
                    
                }
            })
        }
    }
    
 
    func signaction(username: String,email: String,imageurl:String)
   {
    
    StartSpinner()
    let parameters: Parameters = [
        "username" : username,
        "email":email,
        "device_id":UserDefaults.standard.value(forKey:"device_token") as! String,
        "reg_type" : regtype
    ]
    var imgData = Data()
    let url = NSURL(string: imageurl)
    do {
        imgData = try Data(contentsOf: url as! URL)
    } catch {
        print("Unable to load data: \(error)")
    }
    

    
    Alamofire.upload(
        multipartFormData: { MultipartFormData in
            //    multipartFormData.append(imageData, withName: "user", fileName: "user.jpg", mimeType: "image/jpeg")
            for (key, value) in parameters {
                MultipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            MultipartFormData.append(imgData, withName: "profile_pic", fileName: "swift_file.jpeg", mimeType: "image/jpeg")
            
            
    }, to: webservices().baseurl+"register") { (result) in
        
        switch result {
        case .success(let upload, _, _):
            
            
            upload.responseJSON { response in
                print(response.result.value!)
                
                let dic : NSDictionary = response.result.value! as! NSDictionary
                
                if(dic.value(forKey:"error_code") as! Int == 0)
                {
                    let newdic =  dic.value(forKey:"data") as! NSDictionary
                    
                    UserDefaults.standard.set(newdic.value(forKey: "profile_pic") as! String, forKey:"profilepic")
                    UserDefaults.standard.set(newdic.value(forKey: "username") as! String, forKey:"username")
                    
                    UserDefaults.standard.set(newdic.value(forKey: "id") as! Int, forKey:"userid")
                    
                    UserDefaults.standard.set(newdic.value(forKey: "email") as! String, forKey: "email")
                    UserDefaults.standard.set(newdic.value(forKey: "password") as! String, forKey: "password")
                    UserDefaults.standard.set(self.regtype, forKey: "type")

                    UserDefaults.standard.set(1, forKey:"is_login")
                    
                    UserDefaults.standard.synchronize()
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                    self.navigationController?.pushViewController(nextViewController, animated: true)
                    
                    let alert = webservices.sharedInstance.AlertBuilder(title:"", message:"Registration Successfully.")
                    self.present(alert, animated: true, completion: nil)
                  
                }
                else
                    
                {
                    let alert = webservices.sharedInstance.AlertBuilder(title:"", message:dic.value(forKey:"message") as! String)
                    self.present(alert, animated: true, completion: nil)
                    
                    
                }
                
                
                
                StopSpinner()
            }
            
        case .failure(let encodingError): break
        print(encodingError)
        StopSpinner()
        
        let alert = webservices.sharedInstance.AlertBuilder(title:"", message:"Unble to register please try again")
        self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    
    
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

