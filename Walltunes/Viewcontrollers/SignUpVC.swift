//
//  SignUpVC.swift
//  Walltones
//
//  Created by Ravi Dubey on 6/26/18.
//  Copyright © 2018 Ravi Dubey. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire
import IQKeyboardManagerSwift
import PKHUD
class SignUpVC: UIViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate{
    
    
    @IBOutlet weak var imgview: UIImageView!
    @IBOutlet weak var txtusername: UITextField!
    
    @IBOutlet weak var txtrepeatpass: UITextField!
    @IBOutlet weak var txtpass: UITextField!
    
    @IBOutlet weak var txtemail: UITextField!
    @IBOutlet weak var btnregister: UIButton!
    var imageView1  = UIImageView()
    var imageView2  = UIImageView()

    
    var email = ""
    var username = ""
    var profilepicture = ""
    var type = 2
    var iconClick = true
    var iconClick1 = true


    
    override func viewDidLoad() {
        super.viewDidLoad()
        IQKeyboardManager.shared.enable = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showActionSheet))
        
        imgview.addGestureRecognizer(tapGesture)
        imgview.isUserInteractionEnabled = true
        imgview.layer.borderWidth=1.0
        imgview.layer.masksToBounds = false
        imgview.layer.borderColor = UIColor.white.cgColor
        imgview.layer.cornerRadius = imgview.frame.size.height/2
        imgview.clipsToBounds = true
     
      
      
     if(profilepicture != "")
     {
        let url = NSURL(string: profilepicture)
        imgview.sd_setImage(with: url as? URL, placeholderImage: UIImage(named: "download"))
        }
            
        
       
        txtusername.text = username
        txtemail.text = email
//
//        bottomborder(textfield: txtusername)
//        bottomborder(textfield: txtrepeatpass)
//
//        bottomborder(textfield: txtpass)
//
//        bottomborder(textfield: txtemail)
        
        btnregister.layer.cornerRadius = 25.0
        
        btnregister.clipsToBounds = true
        
        setLeftView(textfield: txtemail)
        setLeftView1(textfield: txtpass)
        setLeftView1(textfield: txtrepeatpass)
        setLeftView2(textfield: txtusername)
        setrightview(textfield: txtrepeatpass)
        setrightview(textfield: txtpass)
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func login(_ sender: Any) {
      self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    @IBAction func BtnregisterAction(_ sender: Any) {
        
        
     if(txtusername.text == "")
     {
        let alert = webservices.sharedInstance.AlertBuilder(title:"", message:"Please enter username")
        self.present(alert, animated: true, completion: nil)
        
        }
        
     else if(txtemail.text == "")
        {
            let alert = webservices.sharedInstance.AlertBuilder(title:"", message:"Please enter emailaddress")
            self.present(alert, animated: true, completion: nil)
            
        }
        
     else if (!isValidEmail(testStr:txtemail.text!))
     {
        let alert = webservices.sharedInstance.AlertBuilder(title:"", message:"Please enter valid email address")
        self.present(alert, animated: true, completion: nil)
        
     }
        
     else if(txtpass.text == "")
     {
        let alert = webservices.sharedInstance.AlertBuilder(title:"", message:"Please enter password")
        self.present(alert, animated: true, completion: nil)
        
        }
     else if((txtpass.text?.characters.count)! < 6)
     {
        let alert = webservices.sharedInstance.AlertBuilder(title:"", message:"Please enter valid password. password must contain atleast 6 latter")
        self.present(alert, animated: true, completion: nil)
        
     }
        
     else if(txtrepeatpass.text == "")
     {
        let alert = webservices.sharedInstance.AlertBuilder(title:"", message:"Please retype your password")
        self.present(alert, animated: true, completion: nil)
        
        }
     else if(txtrepeatpass.text != txtpass.text)
     {
        let alert = webservices.sharedInstance.AlertBuilder(title:"", message:"Password and retype password must be same")
        self.present(alert, animated: true, completion: nil)
        
        }
     else if(imgview.image == UIImage(named: "itunes"))
     {
        let alert = webservices.sharedInstance.AlertBuilder(title:"", message:"Please Upload image")
        self.present(alert, animated: true, completion: nil)
        
     }
      else
     {

        StartSpinner()
        let parameters: Parameters = [
            "username" : txtusername.text!,
            "email":txtemail.text!,
            "device_id":UserDefaults.standard.value(forKey:"device_token") as! String,
            "password": txtpass.text!,
            "reg_type" : type
            ]
        
        let imgData = UIImageJPEGRepresentation(imgview.image!,1)
        
        
        
        Alamofire.upload(
            multipartFormData: { MultipartFormData in
                //    multipartFormData.append(imageData, withName: "user", fileName: "user.jpg", mimeType: "image/jpeg")
                for (key, value) in parameters {
                    MultipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
                
                MultipartFormData.append(imgData!, withName: "profile_pic", fileName: "swift_file.jpeg", mimeType: "image/jpeg")
               
                
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
                    UserDefaults.standard.set(self.txtpass.text!, forKey: "password")
                    UserDefaults.standard.set(self.type, forKey: "type")
                    UserDefaults.standard.set(1, forKey:"is_login")
                    UserDefaults.standard.synchronize()
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                    self.navigationController?.pushViewController(nextViewController, animated: true)
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
    }
    
    
    
    
    //MARK:- imagePicker delegate methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var image = info[UIImagePickerControllerEditedImage] as! UIImage
        
        imgview.image = image
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- textfield delegate methods

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField == txtpass || textField == txtrepeatpass)
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
    
    
    //MARK:-User define functions
    
    func camera()
    {
        var myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.allowsEditing = true
        myPickerController.sourceType = UIImagePickerControllerSourceType.camera
        
        self.present(myPickerController, animated: true, completion: nil)
        
    }
    
    func photoLibrary()
    {
        
        var myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.allowsEditing = true
        myPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(myPickerController, animated: true, completion: nil)
        
    }
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
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
        
//        let imageView = UIImageView.init(image: #imageLiteral(resourceName: "eye-slash-solid"))
//        imageView.isUserInteractionEnabled = true
//        imageView.frame = CGRect(x: 10, y: 0, width: 30, height: 30)
//        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: 60, height: 30))
//
//        view.addSubview(imageView)
//        textfield.rightViewMode = UITextFieldViewMode.always
//
//        textfield.rightView = view
       if(textfield == txtpass)
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
        if(textfield == txtrepeatpass)
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

    
    

    //MARK:- User define function
    
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
            txtpass.isSecureTextEntry = false
            iconClick = false
        } else {
            imageView1.image = #imageLiteral(resourceName: "eye-slash-solid")
            txtpass.isSecureTextEntry = true
            iconClick = true
        }
        
    }
    @objc func showpass1()
    {
        if(iconClick1 == true) {
             imageView2.image = #imageLiteral(resourceName: "eye-regular")
            txtrepeatpass.isSecureTextEntry = false
            iconClick1 = false
        } else {
            imageView2.image = #imageLiteral(resourceName: "eye-slash-solid")

            txtrepeatpass.isSecureTextEntry = true
            iconClick1 = true
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
