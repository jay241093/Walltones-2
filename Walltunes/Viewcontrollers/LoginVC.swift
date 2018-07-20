
//
//  LoginVC.swift
//  Walltones
//
//  Created by Ravi Dubey on 6/21/18.
//  Copyright © 2018 Ravi Dubey. All rights reserved.
//

import UIKit
import Alamofire
import FBSDKLoginKit
import FBSDKCoreKit
import GoogleSignIn

class LoginVC: UIViewController ,UITextFieldDelegate,GIDSignInUIDelegate,GIDSignInDelegate {

    @IBOutlet weak var txtemail: UITextField!
    
    @IBOutlet weak var txtpwd: UITextField!
    
    @IBOutlet weak var btnlogin: UIButton!
    var type = 2
    var useremail : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        txtpwd.delegate = self
        setLeftView(textfield: txtemail)
        setLeftView1(textfield: txtpwd)

     //   bottomborder(textfield: txtemail)
    //    bottomborder(textfield: txtpwd)
        btnlogin.layer.cornerRadius = 25.0
        
        btnlogin.clipsToBounds = true
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        // Do any additional setup after loading the view.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
       
        
    }

    //MARK:- User define function

    
    func setLeftView(textfield: UITextField)
    {
        textfield.contentMode = .scaleAspectFit
        
        let imageView = UIImageView.init(image: #imageLiteral(resourceName: "envelope.png"))
        imageView.frame = CGRect(x: 10, y: 0, width: 30, height: 30)
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: 60, height: 30))
        view.addSubview(imageView)
        textfield.leftViewMode = UITextFieldViewMode.always
        
        textfield.leftView = view
   }
    func setLeftView1(textfield: UITextField)
    {
        textfield.contentMode = .scaleAspectFit
        
        let imageView = UIImageView.init(image: #imageLiteral(resourceName: "unlock-alt.png"))
        imageView.frame = CGRect(x: 10, y: 0, width: 30, height: 30)
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: 60, height: 30))
        view.addSubview(imageView)
        textfield.leftViewMode = UITextFieldViewMode.always
        
        textfield.leftView = view
      
    }
    
    func bottomborder(textfield:UITextField)
    {
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor =  UIColor(red:1.00, green:0.33, blue:0.36, alpha:1.0).cgColor
        border.frame = CGRect(x: 0, y: textfield.frame.size.height - width, width:textfield.frame.size.width + 50, height: textfield.frame.size.height)
        
        border.borderWidth = width
        textfield.layer.addSublayer(border)
        textfield.layer.masksToBounds = true
        
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
    
    
    //MARK:- textfield delegate methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField == txtpwd)
        {
            let maxLength = 16
            let currentString: NSString = textField.text as! NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        else
        {
            
            return true
            
        }
        
    }
    
    
    
    @IBAction func btnloginaction(_ sender: Any) {
  
 
        if(txtemail.text == "")
        {
            let alert = webservices.sharedInstance.AlertBuilder(title:"", message:"Please enter email address")
            self.present(alert, animated: true, completion: nil)
            
        }
            
        else if (!isValidEmail(testStr:txtemail.text!))
        {
            let alert = webservices.sharedInstance.AlertBuilder(title:"", message:"Please enter valid email address")
            self.present(alert, animated: true, completion: nil)
            
        }
            
        else if(txtpwd.text == "")
        {
            let alert = webservices.sharedInstance.AlertBuilder(title:"", message:"Please enter password")
            self.present(alert, animated: true, completion: nil)
            
        }
        else if((txtpwd.text?.characters.count)! < 6)
        {
            let alert = webservices.sharedInstance.AlertBuilder(title:"", message:"Please enter valid password. password must contain atleast 6 latter")
            self.present(alert, animated: true, completion: nil)
            
        }
        else
        {
        apilogincall()
        }
    
    }
    
    
    
 
//MARK:- Api call for login user

   func apilogincall()
   {
    if AppDelegate.hasConnectivity() == true
    {
        StartSpinner()
        
        print(UserDefaults.standard.value(forKey:"device_token") as! String)
        let parameters: Parameters = [
            "email":txtemail.text!,
            "password":txtpwd.text!,
            "device_id": UserDefaults.standard.value(forKey:"device_token") as! String,
            "reg_type":self.type
        ]
        
        Alamofire.request(webservices().baseurl + "login", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSONDecodable{(response:DataResponse<LoginResponse>) in
            switch response.result{
                
            case .success(let resp):
                print(resp)
             StopSpinner()
              if(resp.errorCode == 0)
              {
                
                UserDefaults.standard.set(resp.data?.profilePic, forKey:"profilepic")
                UserDefaults.standard.set(resp.data?.username, forKey:"username")

                UserDefaults.standard.set(resp.data?.userID, forKey:"userid")
                
                UserDefaults.standard.set(self.txtemail.text, forKey: "email")
                UserDefaults.standard.set(self.txtpwd.text, forKey: "password")
                UserDefaults.standard.set(self.type, forKey: "type")

                UserDefaults.standard.set(1, forKey:"is_login")
                
                UserDefaults.standard.synchronize()
              
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                self.navigationController?.pushViewController(nextViewController, animated: true)
                
                }
                else
                
              {
                let alert = webservices.sharedInstance.AlertBuilder(title: "", message: resp.message)
                self.present(alert, animated: true, completion: nil)
                
                
                }
                
            case .failure(let err):
             print(err.localizedDescription)
                StopSpinner()
            }
        }
        
    }
    else
    {
        
        webservices.sharedInstance.nointernetconnection()
        NSLog("No Internet Connection")
    }
    
    }
    func apilogincallnew()
    {
        if AppDelegate.hasConnectivity() == true
        {
            StartSpinner()
            
            let parameters: Parameters = [
                "email":useremail,
                "device_id": UserDefaults.standard.value(forKey:"device_token") as! String,
                "reg_type":self.type
            ]
            
            Alamofire.request(webservices().baseurl + "login", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSONDecodable{(response:DataResponse<LoginResponse>) in
                switch response.result{
                    
                case .success(let resp):
                    print(resp)
                    StopSpinner()
                    if(resp.errorCode == 0)
                    {
                        
                        UserDefaults.standard.set(resp.data?.profilePic, forKey:"profilepic")
                        UserDefaults.standard.set(resp.data?.username, forKey:"username")
                        
                        UserDefaults.standard.set(resp.data?.userID, forKey:"userid")
                        
                        UserDefaults.standard.set(self.txtemail.text, forKey: "email")
                        UserDefaults.standard.set(self.txtpwd.text, forKey: "password")
                        UserDefaults.standard.set(self.type, forKey: "type")

                        UserDefaults.standard.set(1, forKey:"is_login")
                        
                    
                        
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        
                        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                        self.navigationController?.pushViewController(nextViewController, animated: true)
                        
                        UserDefaults.standard.synchronize()
                     
                        
                    }
                    else
                    {
                        let alert = webservices.sharedInstance.AlertBuilder(title: "", message: resp.message)
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    
                    
                case .failure(let err):
                    print(err.localizedDescription)
                    StopSpinner()
                }
            }
            
        }
        else
        {
            
            webservices.sharedInstance.nointernetconnection()
            NSLog("No Internet Connection")
        }
        
    }
    
    
    @IBAction func homeaction(_ sender: Any) {
        
       self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func facebookaction(_ sender: Any) {
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
        }
        
    }
   
    //MARK:- Get user data from facebook
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email, gender, friendlists, friends"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    
                     self.type = 0
                    var  dict = result as! [String : AnyObject]
                    var name  = dict["name"]
                    var email  = dict["email"]
                    self.useremail = email as! String
                    self.apilogincallnew()
                    if let imageURL = ((dict["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
                   
                    }
                }
            })
        }
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
            
            self.type = 1

            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            self.useremail = email!
            self.apilogincallnew()
            if user.profile.hasImage{
                // crash here !!!!!!!! cannot get imageUrl here, why?
                // let imageUrl = user.profile.imageURLWithDimension(120)
                let imageUrl = signIn.currentUser.profile.imageURL(withDimension: 120)
                print(" image url: ", imageUrl?.absoluteString)
                
                
            }
            GIDSignIn.sharedInstance().disconnect()

            // ...
        }
    }
    
    
    
    @IBAction func gmailaction(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
