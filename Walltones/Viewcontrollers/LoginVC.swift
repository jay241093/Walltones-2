
//
//  LoginVC.swift
//  Walltones
//
//  Created by Ravi Dubey on 6/21/18.
//  Copyright © 2018 Ravi Dubey. All rights reserved.
//

import UIKit
import Alamofire

class LoginVC: UIViewController ,UITextFieldDelegate{

    @IBOutlet weak var txtemail: UITextField!
    
    @IBOutlet weak var txtpwd: UITextField!
    
    @IBOutlet weak var btnlogin: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtpwd.delegate = self
        setLeftView(textfield: txtemail)
        setLeftView1(textfield: txtpwd)

        bottomborder(textfield: txtemail)
        bottomborder(textfield: txtpwd)
        btnlogin.layer.cornerRadius = 25.0
        
        btnlogin.clipsToBounds = true
        // Do any additional setup after loading the view.
        
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
            let alert = webservices.sharedInstance.AlertBuilder(title:"", message:"Please enter emailaddress")
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
            "device_id": UserDefaults.standard.value(forKey:"device_token") as! String
        ]
        
        Alamofire.request(webservices().baseurl + "login", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSONDecodable{(response:DataResponse<LoginResponse>) in
            switch response.result{
                
            case .success(let resp):
                print(resp)
             StopSpinner()
              if(resp.errorCode == 0)
              {
                
                UserDefaults.standard.set(resp.data.profilePic, forKey:"profilepic")
                UserDefaults.standard.set(resp.data.username, forKey:"username")

                UserDefaults.standard.set(resp.data.userID, forKey:"userid")
                
                UserDefaults.standard.set(self.txtemail.text, forKey: "email")
                UserDefaults.standard.set(self.txtpwd.text, forKey: "password")

                UserDefaults.standard.set(1, forKey:"is_login")
                
                UserDefaults.standard.synchronize()
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                self.navigationController?.pushViewController(nextViewController, animated: true)
                
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
