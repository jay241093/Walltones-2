
//
//  FavouriteListVC.swift
//  Walltones
//
//  Created by Ravi Dubey on 7/10/18.
//  Copyright © 2018 Ravi Dubey. All rights reserved.
//

import UIKit
import ScrollPager
import Alamofire
import SDWebImage
import AVKit
class FavouriteListVC: UIViewController ,UICollectionViewDelegate , UICollectionViewDataSource, UITableViewDelegate , UITableViewDataSource, UICollectionViewDelegateFlowLayout{
    
   var FavWallary = [FavWallList]()
    var FavRingary = [FavRinglist]()
    var playerViewController = AVPlayerViewController()

    @IBOutlet weak var scrollview: UIScrollView!
    
    @IBOutlet weak var btnsidemenu: UIButton!
    @IBOutlet weak var imguser: UIImageView!
    
    @IBOutlet weak var lblname: UILabel!
    
    @IBOutlet weak var pager: ScrollPager!
    
    var isplaying = 0
    var CollectionWallpaper =  UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    var ringtonelist = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GetFavWallpaper()
        GetFavRingtones()
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
        
        if revealViewController() != nil
        {
            btnsidemenu.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
        
        ringtonelist.delegate = self
        ringtonelist.dataSource = self
        
        ringtonelist.register(UINib(nibName: "TotalringtonelistCell", bundle: nil), forCellReuseIdentifier:"cell")
        CollectionWallpaper.backgroundColor = UIColor.white

         CollectionWallpaper.dataSource = self
        CollectionWallpaper.delegate = self
     
        
        CollectionWallpaper.register(UINib(nibName: "WallpaperListCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        pager.addSegmentsWithTitlesAndViews(segments: [("Wallpaper",CollectionWallpaper),("Ringtone",ringtonelist)])
        // Do any additional setup after loading the view.
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FavWallary.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var dvc: WallpaperListCell = collectionView.dequeueReusableCell(withReuseIdentifier:"cell", for: indexPath) as! WallpaperListCell
       let dic = FavWallary[indexPath.row]
        
        let url = "http://innoviussoftware.com/walltones/storage/app/" + dic.icon!
    var newurl = NSURL(string: url)
        
    
        dvc.backgroundColor = UIColor.white
        dvc.imgview.sd_setImage(with: newurl as! URL, placeholderImage: UIImage(named: "default-user"))
         dvc.btnremove.tag = indexPath.row
        
        dvc.btnremove.addTarget(self, action:#selector(removefavouritewallpaper), for: .touchUpInside)
        
        return dvc
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  10
                let collectionViewSize = collectionView.frame.size.width - padding
        
                return CGSize(width: collectionViewSize/2.2, height: collectionViewSize/1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dic = FavWallary[indexPath.row]
        let popOverConfirmVC = self.storyboard?.instantiateViewController(withIdentifier: "ImagepopUP") as! ImagepopUP
        let url = "http://innoviussoftware.com/walltones/storage/app/" + dic.icon!
        var newurl = NSURL(string: url)
        popOverConfirmVC.url = newurl!
        popOverConfirmVC.isformfavourite = 1
        self.addChildViewController(popOverConfirmVC)
        popOverConfirmVC.view.frame = self.view.frame
        self.view.center = popOverConfirmVC.view.center
        self.view.addSubview(popOverConfirmVC.view)
        popOverConfirmVC.didMove(toParentViewController: self)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FavRingary.count

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 121
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var dvc: TotalringtonelistCell = tableView.dequeueReusableCell(withIdentifier:"cell", for: indexPath) as! TotalringtonelistCell
        var colorary = [UIColor(red:0.75, green:0.75, blue:0.75, alpha:1.0),]
        dvc.selectionStyle = .none
         let dic = FavRingary[indexPath.row]
        dvc.lblname.text = dic.name
        dvc.lbldes.text =  dic.description
        setShadow(view: dvc.view)

       dvc.btnplay.addTarget(self, action:#selector(playaudiomethod), for: .touchUpInside)
        dvc.btnplay.tag = indexPath.row
        dvc.btnlike.isHidden = true
        return dvc
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            var refreshAlert = UIAlertController(title: nil, message: "Are you sure you want to remove?", preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                self.RemoveFavouriteRingtone(id: self.FavRingary[indexPath.row].id)
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            
            present(refreshAlert, animated: true, completion: nil)
        }
    }
    
    
    @objc func playaudiomethod(sender:UIButton)
    {
        
        if(isplaying == 0)
        {
            
            print(sender.tag)
            
            let indexPath = IndexPath(row: sender.tag, section: 0)
            
            var cell: TotalringtonelistCell = ringtonelist.cellForRow(at: indexPath) as!TotalringtonelistCell
            
            let dic = FavRingary[sender.tag]
            let url = NSURL(string:"http://innoviussoftware.com/walltones/storage/app/" + dic.file!)
            
            do {
                
                let avAsset = AVURLAsset(url: url as! URL, options: nil)
                
                let videoURL = url
                playerViewController = AVPlayerViewController()
                
                DispatchQueue.main.async() {
                    self.playerViewController.player = AVPlayer(url: videoURL! as URL) as AVPlayer
                    self.playerViewController.player?.play()
                    cell.btnplay.setImage(#imageLiteral(resourceName: "pause-circle-solid"), for: .normal)
                }
                isplaying = 1
                
            } catch let error as NSError {
                let alert = webservices.sharedInstance.AlertBuilder(title:"", message:error.localizedDescription)
                self.present(alert, animated: true, completion: nil)
                print(error.localizedDescription)
                
                
            } catch {
                print("AVAudioPlayer init failed")
            }
            
        }
        else
            
        {
            isplaying = 0
            
            print(sender.tag)
            
            let indexPath = IndexPath(row: sender.tag, section: 0)
            
            var cell: TotalringtonelistCell = ringtonelist.cellForRow(at: indexPath) as!TotalringtonelistCell
            
            cell.btnplay.setImage(#imageLiteral(resourceName: "unnamed"), for: .normal)
            
            self.playerViewController.player?.pause()
        }
        
        
    }
   
    func GetFavWallpaper()
    {
        
        print(UserDefaults.standard.value(forKey:"userid")!)
        if AppDelegate.hasConnectivity() == true
        {
            StartSpinner()
            
            Alamofire.request(webservices().baseurl + "favoritewallpaperlist", method: .post, parameters: ["user_id":UserDefaults.standard.value(forKey:"userid")!], encoding: JSONEncoding.default, headers: nil).responseJSONDecodable{(response:DataResponse<FavouriteWallpaer>) in
                switch response.result{
                    
                case .success(let resp):
                    print(resp)
                    StopSpinner()
                    if(resp.errorCode == 0)
                    {
                        
                        self.FavWallary = resp.data
                        self.CollectionWallpaper.reloadData()
                    }
                    
                case .failure(let err):
                let alert = webservices.sharedInstance.AlertBuilder(title:"", message:"Could not get load Fovourite wallpaper list")
                self.present(alert, animated: true, completion: nil)
                print(err)
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
    
    func GetFavRingtones()
    {
        print(UserDefaults.standard.value(forKey:"userid")!)
        if AppDelegate.hasConnectivity() == true
        {
            StartSpinner()
            
            Alamofire.request(webservices().baseurl + "favoriteringtonelist", method: .post, parameters: ["user_id":UserDefaults.standard.value(forKey:"userid")!], encoding: JSONEncoding.default, headers: nil).responseJSONDecodable{(response:DataResponse<FavouriteRingtone>) in
                switch response.result{
                    
                case .success(let resp):
                    print(resp)
                    StopSpinner()
                    if(resp.errorCode == 0)
                    {
                        
                        self.FavRingary = resp.data
                        self.ringtonelist.reloadData()
                        if(self.FavRingary.count == 0)
                        {
                            let alert = webservices.sharedInstance.AlertBuilder(title:"", message:"No favourite rintone avalible")
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                        
                    }
                    
                case .failure(let err):
                let alert = webservices.sharedInstance.AlertBuilder(title:"", message:"Could not get load Fovourite rintone list")
                self.present(alert, animated: true, completion: nil)
                print(err)
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
    
    
    @objc func removefavouritewallpaper(sender:UIButton)
    {
      print(sender.tag)
     
            var refreshAlert = UIAlertController(title: nil, message: "Are you sure you want to remove?", preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                self.RemoveFavouriteWallpaper(id: self.FavWallary[sender.tag].id!)
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            
            present(refreshAlert, animated: true, completion: nil)
    
        
    }
    
    
    
    func RemoveFavouriteWallpaper(id:String)
    {
        var parameters:Parameters = ["wallpaper_id":id,"user_id":UserDefaults.standard.value(forKey:"userid") as! Int]
        
        StartSpinner()
        Alamofire.request(webservices().baseurl + "removefavoritewallpaper", method: .post, parameters:parameters, encoding: JSONEncoding.default, headers:nil).responseJSON{ (response:DataResponse<Any>) in
            switch response.result{
            case .success(let resp):
                print(resp)
                self.GetFavWallpaper()
                
                StopSpinner()
            case .failure(let err):
                print(err)
                print("Failed to change ")
                let alert = webservices.sharedInstance.AlertBuilder(title:  "OOps", message: "Unable to like")
                self.present(alert, animated: true, completion: nil)
                StopSpinner()
                
                
            }
            
            
            
        }
        
    }
    
    func RemoveFavouriteRingtone(id:String)
    {
        var parameters:Parameters = ["ringtone_id":id,"user_id":UserDefaults.standard.value(forKey:"userid") as! Int]
        
        StartSpinner()
        Alamofire.request(webservices().baseurl + "removefavoriteringtone", method: .post, parameters:parameters, encoding: JSONEncoding.default, headers:nil).responseJSON{ (response:DataResponse<Any>) in
            switch response.result{
            case .success(let resp):
                print(resp)
                self.GetFavRingtones()
                
                StopSpinner()
            case .failure(let err):
                print(err)
                print("Failed to change ")
                let alert = webservices.sharedInstance.AlertBuilder(title:  "OOps", message: "Unable to like")
                self.present(alert, animated: true, completion: nil)
                StopSpinner()
                
                
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
