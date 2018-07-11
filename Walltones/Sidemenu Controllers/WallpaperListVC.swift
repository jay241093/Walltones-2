//
//  WallpaperListVC.swift
//  Walltones
//
//  Created by Ravi Dubey on 7/4/18.
//  Copyright © 2018 Ravi Dubey. All rights reserved.
//

import UIKit
import ScrollPager
import Alamofire
import SDWebImage
class WallpaperListVC: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout , UITableViewDelegate , UITableViewDataSource,UISearchBarDelegate{
    @IBOutlet weak var pager: ScrollPager!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet var viewwallpaper: UIView!
    
    @IBOutlet weak var collectioncategory: UICollectionView!
    
    @IBOutlet weak var collectionlist: UICollectionView!
    
    var categoryary = [Datum]()
   
    var Wallpaperlist = [Datum1]()
    var Allwallpaperlist = [wallpaperlist]()
var collectionAlllist = UITableView()
    var issearch = 0

    @IBOutlet weak var btnsearch: UIButton!
    
    @IBAction func serach(_ sender: Any) {
   
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionAlllist.delegate = self
        collectionAlllist.dataSource = self

        getwallpapercat()
        getallwallpapers()
        collectionlist.register(UINib(nibName: "WallpaperListCell", bundle: nil), forCellWithReuseIdentifier: "cell")
       collectionAlllist.register(UINib(nibName: "AllwallpaperListCell", bundle: nil), forCellReuseIdentifier:"cell")
        
        let view: UIView = viewwallpaper
        
        
      
        pager.addSegmentsWithTitlesAndViews(segments: [("Category",view),
                                                        ("List",collectionAlllist),
                                                       ])
        if revealViewController() != nil
        {
       btn.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
         
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
        // Do any additional setup after loading the view.
    }

    //MARK:- Collection view delegate & data sourcr methods
   
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if(collectionView == collectioncategory)
        {
        return categoryary.count
        }
        else
        {
        return Wallpaperlist.count
        }
       
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       if(collectionView == collectionlist)
       {
        let padding: CGFloat =  10
        let collectionViewSize = collectionView.frame.size.width - padding
        
        return CGSize(width: collectionViewSize/3, height: collectionViewSize/2)
        }
       else
       {
        let padding: CGFloat =  10
 
        
        return CGSize(width: 116, height: 118)
        
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     
        if(collectionView == collectioncategory)
        {
            var dvc: WallpaperCategorycell = collectionView.dequeueReusableCell(withReuseIdentifier:"cell", for: indexPath) as! WallpaperCategorycell
            
            let dic = categoryary[indexPath.row]
            
            dvc.imgview.layer.borderWidth=1.0
             dvc.imgview.layer.masksToBounds = false
             dvc.imgview.layer.borderColor = UIColor.white.cgColor
             dvc.imgview.layer.cornerRadius =  8
             dvc.imgview.clipsToBounds = true
            dvc.lblcategoryname.text = dic.name
            let url = "http://innoviussoftware.com/walltones/storage/app/" + dic.tabIcon
            var newurl = NSURL(string: url)
            
            dvc.imgview.sd_setImage(with: newurl as! URL, placeholderImage:#imageLiteral(resourceName: "Default-wallpaper"))

            
            
            
            return dvc
            
        }
        else
        {
        var dvc: WallpaperListCell = collectionView.dequeueReusableCell(withReuseIdentifier:"cell", for: indexPath) as! WallpaperListCell
            let dic = Wallpaperlist[indexPath.row]

            let url = "http://innoviussoftware.com/walltones/storage/app/" + dic.icon!
            var newurl = NSURL(string: url)
            
            dvc.imgview.sd_setImage(with: newurl as! URL, placeholderImage: #imageLiteral(resourceName: "Default-wallpaper"))
            
            
        return dvc
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        
    if(collectionView == collectioncategory)
    {
        let dic = categoryary[indexPath.row]

        categorywallpaper(id: dic.id)
        }
        else
    {
        
        let popOverConfirmVC = self.storyboard?.instantiateViewController(withIdentifier: "WallpaperDetilVC") as! WallpaperDetilVC
        popOverConfirmVC.wallpaperlistnew = Wallpaperlist
        
        self.addChildViewController(popOverConfirmVC)
        popOverConfirmVC.view.frame = self.view.frame
        self.view.center = popOverConfirmVC.view.center
        self.view.addSubview(popOverConfirmVC.view)
        popOverConfirmVC.didMove(toParentViewController: self)
        
   }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dvc: AllwallpaperListCell = tableView.dequeueReusableCell(withIdentifier:"cell", for: indexPath) as! AllwallpaperListCell
        
        let dic = Allwallpaperlist[indexPath.row]
        
        let url = "http://innoviussoftware.com/walltones/storage/app/" + dic.icon
        var newurl = NSURL(string: url)
        
        dvc.imgview.sd_setImage(with: newurl! as URL, placeholderImage: #imageLiteral(resourceName: "Default-wallpaper"))
        return dvc

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Allwallpaperlist.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 226
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let popOverConfirmVC = self.storyboard?.instantiateViewController(withIdentifier: "WallpaperDetilVC") as! WallpaperDetilVC
        popOverConfirmVC.Allwallpaperlist = Allwallpaperlist
        
        self.addChildViewController(popOverConfirmVC)
        popOverConfirmVC.view.frame = self.view.frame
        self.view.center = popOverConfirmVC.view.center
        self.view.addSubview(popOverConfirmVC.view)
        popOverConfirmVC.didMove(toParentViewController: self)
        
    }
    
func getwallpapercat()
{
    if AppDelegate.hasConnectivity() == true
        {
            StartSpinner()
                Alamofire.request(webservices().baseurl + "getwallpapercat", method: .post, parameters: [:], encoding: JSONEncoding.default, headers: nil).responseJSONDecodable{(response:DataResponse<WallpaperCatRes>) in
                switch response.result{
                case .success(let resp):
                    print(resp)
                    StopSpinner()
                    if(resp.errorCode == 0)
                    {

                       self.categoryary = resp.data
                        self.collectioncategory.reloadData()
                        if(self.categoryary.count > 0)
                        {
                        self.categorywallpaper(id: self.categoryary[0].id)
                        }
                    }
                    
                case .failure(let err): break
                 print(err)
                let alert = webservices.sharedInstance.AlertBuilder(title:"", message:"Could not get load wallpaper category")
                self.present(alert, animated: true, completion: nil)
                
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
    func categorywallpaper(id:Int)
    {
        
        if AppDelegate.hasConnectivity() == true
        {
            StartSpinner()
            
            Alamofire.request(webservices().baseurl + "getcatwallpaper", method: .post, parameters: ["category_id":id], encoding: JSONEncoding.default, headers: nil).responseJSONDecodable{(response:DataResponse<WallpaperList>) in
                switch response.result{
                    
                case .success(let resp):
                    print(resp)
                    StopSpinner()
                    if(resp.errorCode == 0)
                    {
                         self.Wallpaperlist.removeAll()
                      self.Wallpaperlist = resp.data
                     
                        self.collectionlist.reloadData()
                    }
                    
                case .failure(let err):
                    let alert = webservices.sharedInstance.AlertBuilder(title:"", message:"Could not get load wallpaper list")
                    self.present(alert, animated: true, completion: nil)
                 print(err)
                StopSpinner()
                }
            }
            
        }
        else
        {
            StopSpinner()

            webservices.sharedInstance.nointernetconnection()
            NSLog("No Internet Connection")
        }
        
        
        
    }
    func getallwallpapers()
    {
        
        if AppDelegate.hasConnectivity() == true
        {
            StartSpinner()
            
            Alamofire.request(webservices().baseurl + "getwallpaper", method: .post, parameters: [:], encoding: JSONEncoding.default, headers: nil).responseJSONDecodable{(response:DataResponse<Allwallpaperlist>) in
                switch response.result{
                    
                case .success(let resp):
                    print(resp)
                    StopSpinner()
                    if(resp.errorCode == 0)
                    {
                        
                       self.Allwallpaperlist = resp.data
                        self.collectionAlllist.reloadData()
                    }
                    
                case .failure(let err):
                let alert = webservices.sharedInstance.AlertBuilder(title:"", message:"Could not get load wallpaper list")
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
