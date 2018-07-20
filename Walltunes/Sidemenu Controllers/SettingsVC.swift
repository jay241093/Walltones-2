//
//  SettingsVC.swift
//  Walltones
//
//  Created by Ravi Dubey on 7/9/18.
//  Copyright © 2018 Ravi Dubey. All rights reserved.
//

import UIKit
import Alamofire

class SettingsVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var btnupdate: UIButton!
    
    @IBOutlet weak var imguser: UIImageView!
    
    @IBOutlet weak var txtname: UITextField!
    
    @IBOutlet weak var txtrepeatpassword: UITextField!
    
    @IBOutlet weak var txtpassword: UITextField!
    
    @IBOutlet weak var btnsidemenu: UIButton!
    @IBOutlet weak var txtoldpassword: UITextField!
    
    var iconClick = true
    var iconClick1 = true
    var imageView1  = UIImageView()
    var imageView2  = UIImageView()
    override func viewDidLoad() {
        
        
        txtoldpassword.isSecureTextEntry = true
        let url1 = UserDefaults.standard.value(forKey: "profilepic") as? String
        let url = "http://innoviussoftware.com/walltones/storage/app/" + url1!
        var newurl = NSURL(string: url)
        
        imguser.sd_setImage(with: newurl as! URL, placeholderImage: UIImage(named: "default-user"))
        
        
        if revealViewController() != nil
        {
            btnsidemenu.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
        
        if let key = UserDefaults.standard.value(forKey: "type")
        {
            
            let num = UserDefaults.standard.value(forKey:"type") as! Int
            if(num == 2)
            {
              imguser.isUserInteractionEnabled = true

            }
            else
            {
                txtname.isEnabled = false
                txtoldpassword.isEnabled = false
                txtpassword.isEnabled = false
                txtrepeatpassword.isEnabled = false
                btnupdate.isEnabled = false
                imguser.isUserInteractionEnabled = false
            }
            
        }
        
        btnupdate.layer.cornerRadius = 25.0
        
        btnupdate.clipsToBounds = true
        
        txtrepeatpassword.delegate = self
        txtpassword.delegate = self
        
        txtpassword.text = ""
        txtrepeatpassword.text = ""
        txtname.text = (UserDefaults.standard.value(forKey: "email") as! String)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showActionSheet))
        
        imguser.addGestureRecognizer(tapGesture)
        
        
        
        imguser.layer.borderWidth=1.0
        imguser.layer.masksToBounds = false
        imguser.layer.borderColor = UIColor.white.cgColor
        imguser.layer.cornerRadius = imguser.frame.size.height/2
        imguser.clipsToBounds = true
        
        
        super.viewDidLoad()
//        bottomborder(textfield: txtname)
//        bottomborder(textfield: txtname)
//        bottomborder(textfield: txtpassword)
//        bottomborder(textfield: txtoldpassword)
    //    bottomborder(textfield: txtrepeatpassword)
        
        setLeftView1(textfield: txtoldpassword)
        
        setLeftView(textfield: txtname)
        setLeftView1(textfield: txtpassword)
        setLeftView1(textfield: txtrepeatpassword)
        setrightview(textfield: txtpassword)
        setrightview(textfield: txtrepeatpassword)
        // Do any additional setup after loading the view.
    }
    
    
    
    //MARK:- imagePicker delegate methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var image = info[UIImagePickerControllerEditedImage] as! UIImage
        
        imguser.image = image
        let imgData = UIImageJPEGRepresentation(image,1)
        
        let parameters: Parameters = [
            
            "user_id":UserDefaults.standard.value(forKey:"userid") as! Int
        ]
        
        StartSpinner()
        Alamofire.upload(
            multipartFormData: { MultipartFormData in
           
                for (key, value) in parameters {
                    MultipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
                
                MultipartFormData.append(imgData!, withName: "profile_pic", fileName: "swift_file.jpeg", mimeType: "image/jpeg")
                
                
        }, to: webservices().baseurl+"userprofile") { (result) in
            
            switch result {
            case .success(let upload, _, _):
                
                
                upload.responseJSON { response in
                    print(response.result.value!)
                    
                    StopSpinner()
                    let dic : NSDictionary = response.result.value! as! NSDictionary
                    
                    if(dic.value(forKey:"error_code") as! Int == 0)
                    {
                        let newdic = dic.value(forKey:"data") as! NSDictionary
                        if let key = newdic.value(forKey: "profile_pic")
                        {
                            UserDefaults.standard.set(newdic.value(forKey: "profile_pic") as! String, forKey: "profilepic")
                            UserDefaults.standard.synchronize()
                            
                        }
                        
                        let alert = webservices.sharedInstance.AlertBuilder(title:"", message:dic.value(forKey:"message") as! String)
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
            
            let alert = webservices.sharedInstance.AlertBuilder(title:"", message:"Unble to update please try again ")
            self.present(alert, animated: true, completion: nil)
            }
            
            
        }
        
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- textfield delegate methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField == txtpassword || textField == txtrepeatpassword)
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
    func setLeftView2(textfield: UITextField)
    {
        textfield.contentMode = .scaleAspectFit
        
        let imageView = UIImageView.init(image: #imageLiteral(resourceName: "user-tie.png"))
        imageView.frame = CGRect(x: 10, y: 0, width: 30, height: 30)
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: 60, height: 30))
        view.addSubview(imageView)
        textfield.leftViewMode = UITextFieldViewMode.always
        
        textfield.leftView = view
        
    }
    func setrightview(textfield: UITextField)
    {
        textfield.contentMode = .scaleAspectFit
        
        
        if(textfield == txtpassword)
        {
            imageView1 = UIImageView.init(image: #imageLiteral(resourceName: "eye-slash-solid"))
            imageView1.isUserInteractionEnabled = true
            imageView1.frame = CGRect(x: 10, y: 0, width: 30, height: 30)
            let view = UIView.init(frame: CGRect(x: 0, y: 0, width: 60, height: 30))
            
            view.addSubview(imageView1)
            textfield.rightViewMode = UITextFieldViewMode.always
            
            textfield.rightView = view
            let T1 = UITapGestureRecognizer()
            
            T1.addTarget(self, action: #selector(showpass))
            imageView1.addGestureRecognizer(T1)
        }
        if(textfield == txtrepeatpassword)
            
        {
            imageView2 = UIImageView.init(image: #imageLiteral(resourceName: "eye-slash-solid"))
            imageView2.isUserInteractionEnabled = true
            imageView2.frame = CGRect(x: 10, y: 0, width: 30, height: 30)
            let view = UIView.init(frame: CGRect(x: 0, y: 0, width: 60, height: 30))
            
            view.addSubview(imageView2)
            textfield.rightViewMode = UITextFieldViewMode.always
            
            textfield.rightView = view
            
            let T1 = UITapGestureRecognizer()
            
            T1.addTarget(self, action: #selector(showpass1))
            imageView2.addGestureRecognizer(T1)
            
        }
        
    }
    
    
    
    @objc func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    
    // MARK: - Open camera
    func camera()
    {
        var myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.allowsEditing = true
        myPickerController.sourceType = UIImagePickerControllerSourceType.camera
        
        self.present(myPickerController, animated: true, completion: nil)
        
    }
    // MARK: - Open Photo Gallary
    
    func photoLibrary()
    {
        
        var myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.allowsEditing = true
        myPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(myPickerController, animated: true, completion: nil)
        
    }
    
    func bottomborder(textfield:UITextField)
    {
        
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor =  UIColor(red:1.00, green:0.33, blue:0.36, alpha:1.0).cgColor
        border.frame = CGRect(x: 0, y: textfield.frame.size.height - width, width:  textfield.frame.size.width + 50, height: textfield.frame.size.height)
        
        border.borderWidth = width
        textfield.layer.addSublayer(border)
        textfield.layer.masksToBounds = true
        
    }
    
    @objc func showpass()
    {
        if(iconClick == true) {
            imageView1.image = #imageLiteral(resourceName: "eye-regular")
            
            txtpassword.isSecureTextEntry = false
            iconClick = false
        } else {
            imageView1.image = #imageLiteral(resourceName: "eye-slash-solid")
            
            txtpassword.isSecureTextEntry = true
            iconClick = true
        }
        
    }
    @objc func showpass1()
    {
        if(iconClick1 == true) {
            imageView2.image = #imageLiteral(resourceName: "eye-regular")
            
            txtrepeatpassword.isSecureTextEntry = false
            iconClick1 = false
        } else {
            imageView2.image = #imageLiteral(resourceName: "eye-slash-solid")
            
            txtrepeatpassword.isSecureTextEntry = true
            iconClick1 = true
        }
        
    }
    
    
    
    
    @IBAction func updateaction(_ sender: Any) {
        print(UserDefaults.standard.value(forKey:"password") as! String)
        var str = UserDefaults.standard.value(forKey:"password") as! String
        let messageData = str.data(using: .utf8)!

        if(txtname.text == "")
        {
            let alert = webservices.sharedInstance.AlertBuilder(title:"", message:"Please enter username")
            self.present(alert, animated: true, completion: nil)
            
        }
        else if(txtoldpassword.text == "")
        {
            let alert = webservices.sharedInstance.AlertBuilder(title:"", message:"Please enter old password")
            self.present(alert, animated: true, completion: nil)
            
        }
        else if(txtoldpassword.text != UserDefaults.standard.value(forKey:"password") as! String)
        {
            let alert = webservices.sharedInstance.AlertBuilder(title:"", message:"Please enter correct old password")
            self.present(alert, animated: true, completion: nil)
            
        }
            
        else if(txtpassword.text == "")
        {
            let alert = webservices.sharedInstance.AlertBuilder(title:"", message:"Please enter password")
            self.present(alert, animated: true, completion: nil)
            
        }
        else if((txtpassword.text?.characters.count)! < 6)
        {
            let alert = webservices.sharedInstance.AlertBuilder(title:"", message:"Please enter valid password. password must contain atleast 6 latter")
            self.present(alert, animated: true, completion: nil)
            
        }
            
        else if(txtrepeatpassword.text == "")
        {
            let alert = webservices.sharedInstance.AlertBuilder(title:"", message:"Please retype your password")
            self.present(alert, animated: true, completion: nil)
            
        }
        else if(txtrepeatpassword.text != txtpassword.text)
        {
            let alert = webservices.sharedInstance.AlertBuilder(title:"", message:"Password and retype password must be same")
            self.present(alert, animated: true, completion: nil)
            
        }
            
        else{
            StartSpinner()
            let parameters: Parameters = [
                "username" : UserDefaults.standard.value(forKey:"username") as! String,
                "user_id":UserDefaults.standard.value(forKey:"userid") as! Int,
                "password": txtpassword.text!
            ]
            
            let imgData = UIImageJPEGRepresentation(imguser.image!,1)
            
            
            
            Alamofire.upload(
                multipartFormData: { MultipartFormData in
                    //    multipartFormData.append(imageData, withName: "user", fileName: "user.jpg", mimeType: "image/jpeg")
                    for (key, value) in parameters {
                        MultipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                    }
                    
                    MultipartFormData.append(imgData!, withName: "profile_pic", fileName: "swift_file.jpeg", mimeType: "image/jpeg")
                    
                    
            }, to: webservices().baseurl+"userprofile") { (result) in
                
                switch result {
                case .success(let upload, _, _):
                    
                    
                    upload.responseJSON { response in
                        print(response.result.value!)

                        let dic : NSDictionary = response.result.value! as! NSDictionary
                        
                        if(dic.value(forKey:"error_code") as! Int == 0)
                        {
                            let newdic = dic.value(forKey:"data") as! NSDictionary
                            if let key = newdic.value(forKey: "profile_pic")
                            {
                                UserDefaults.standard.set(newdic.value(forKey: "profile_pic") as! String, forKey: "profilepic")
                                UserDefaults.standard.synchronize()
                                
                            }
                            
                            let alert = webservices.sharedInstance.AlertBuilder(title:"", message:dic.value(forKey:"message") as! String)
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
                
                let alert = webservices.sharedInstance.AlertBuilder(title:"", message:"Unble to update please try again ")
                self.present(alert, animated: true, completion: nil)
                }
                
                
            }
            
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
