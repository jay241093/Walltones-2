//
//  sidemenuViewController.swift
//  greegotaxiapp
//
//  Created by Harshal Shah on 03/04/18.
//  Copyright © 2018 jay. All rights reserved.
//

import UIKit
import SDWebImage

class sidemenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var imguser: UIImageView!
    
    @IBOutlet weak var lblname: UILabel!
    
    
    
    @IBOutlet weak var heightview: NSLayoutConstraint!
    
    var reuseid = NSMutableArray()
    
//MARK: - Delegate Methods
    override func viewDidLoad()
    {
        super.viewDidLoad()

        
        lblname.text = UserDefaults.standard.value(forKey:"username") as? String
        
        let url1 = UserDefaults.standard.value(forKey: "profilepic") as? String
        let url = "http://innoviussoftware.com/walltones/storage/app/" + url1!
        var newurl = NSURL(string: url)
        
        imguser.sd_setImage(with: newurl as! URL, placeholderImage: UIImage(named: "default-user"))
        imguser.layer.borderWidth=1.0
        imguser.layer.masksToBounds = false
        imguser.layer.borderColor = UIColor.white.cgColor
        imguser.layer.cornerRadius = imguser.frame.size.height/2
        imguser.clipsToBounds = true
        //lblname.text = UserDefaults.standard.string(forKey: "fname") as! String + UserDefaults.standard.string(forKey: "lname")!
        
        if(UIDevice.current.screenType == .iPhoneX)
        {
            
            
          heightview.constant = 250
            
        }
        
        
        
        reuseid = ["cell","cell1","cell2","cell5","cell3","cell4"]
    
    }
    override func viewWillAppear(_ animated: Bool) {
       
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
  
    
 //MARK: - TableView Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return reuseid.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let str = reuseid.object(at: indexPath.row) as! String
        let dvc:UITableViewCell = tableView.dequeueReusableCell(withIdentifier:str, for: indexPath)
        var nameary = ["Wallpapers","Ringtones","Favourite List","Help","Settings","Logout"]
        
        var img = ["Wallpaper","Musix","Fav","Help","Setting","Logout"]
        dvc.textLabel?.text = nameary[indexPath.row]
        
        let newImage = resizeImage(image: UIImage(named: img[indexPath.row] )!, toTheSize: CGSize(width: 30, height: 30))
if(indexPath.row == 0 || indexPath.row == 4)
{
    let newImage = resizeImage(image: UIImage(named: img[indexPath.row] )!, toTheSize: CGSize(width: 35, height: 30))
    dvc.imageView?.image = newImage

    
        }
        else
       {
        dvc.imageView?.image = newImage
        }
        dvc.imageView?.contentMode = .scaleAspectFill
        return dvc
    }
    func resizeImage(image:UIImage, toTheSize size:CGSize)->UIImage{
        
        
        var scale = CGFloat(max(size.width/image.size.width,
                                size.height/image.size.height))
        var width:CGFloat  = image.size.width * scale
        var height:CGFloat = image.size.height * scale;
        
        var rr:CGRect = CGRect(x: 0, y: 0, width: width, height: height)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0);
        image.draw(in: rr)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return newImage!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath.row == 5)
        {
            
            let refreshAlert = UIAlertController(title: "Logout", message: "Are you sure you want to logout ?", preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                
                UserDefaults.standard.removeObject(forKey: "email")

                UserDefaults.standard.removeObject(forKey: "password")

                UserDefaults.standard.removeObject(forKey: "profilepic")
                UserDefaults.standard.removeObject(forKey: "is_login")
                UserDefaults.standard.removeObject(forKey: "userid")


                
           
                
                let FirstVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                self.navigationController?.pushViewController(FirstVC, animated: true)
               
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                
            }))
            
            present(refreshAlert, animated: true, completion: nil)
            
        }
        
        
        
    }
   
}



extension UIDevice {
    var iPhoneX: Bool {
        return UIScreen.main.nativeBounds.height == 2436
    }
    var iPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    enum ScreenType: String {
        case iPhone4_4S = "iPhone 4 or iPhone 4S"
        case iPhones_5_5s_5c_SE = "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE"
        case iPhones_6_6s_7_8 = "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8"
        case iPhones_6Plus_6sPlus_7Plus_8Plus = "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus"
        case iPhoneX = "iPhone X"
        case unknown
    }
    var screenType: ScreenType {
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhone4_4S
        case 1136:
            return .iPhones_5_5s_5c_SE
        case 1334:
            return .iPhones_6_6s_7_8
        case 1920, 2208:
            return .iPhones_6Plus_6sPlus_7Plus_8Plus
        case 2436:
            return .iPhoneX
        default:
            return .unknown
        }
    }
}

