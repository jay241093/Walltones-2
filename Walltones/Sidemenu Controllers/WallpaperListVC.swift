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



class WallpaperListVC: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout , UITableViewDelegate , UITableViewDataSource,UISearchBarDelegate,ScrollPagerDelegate{
    @IBOutlet weak var pager: ScrollPager!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet var viewwallpaper: UIView!
    
    @IBOutlet weak var collectioncategory: UICollectionView!
    
    @IBOutlet weak var collectionlist: UICollectionView!
    
    var categoryary = [Datum]()
    var Wallcategoryary = [Datum]()

    var Wallpaperlist = [Datum1]()
    var Allwallpaperlist = [wallpaperlist]()
    var newAllwallpaperlist = [wallpaperlist]()
    var favidary = NSMutableArray()
    var collectionAlllist = UITableView()
    var issearch = 0
    var searchbar = UISearchBar()
    var iscategory =  true
    @IBOutlet weak var btnsearch: UIButton!
    
    @IBAction func serach(_ sender: Any) {
        
        if(issearch == 0)
        {
            issearch = 1
            // searchbar.isHidden = false
            searchbar.placeholder = "Search Wallpaper"
            searchbar.delegate = self
            searchbar.searchBarStyle = .minimal
            self.navigationItem.titleView = searchbar
            btnsearch.setImage(#imageLiteral(resourceName: "cancel"), for: .normal)
        }
        else
        {
            // searchbar.isHidden = true
            issearch = 0
            btnsearch.setImage(#imageLiteral(resourceName: "search-solid (2)"), for: .normal)
            let label = UILabel()
            label.text = "Wallpapers"
            label.font = UIFont(name:"HelveticaNeue-Bold", size: 18.0)
            self.navigationItem.titleView = label
            Allwallpaperlist = newAllwallpaperlist
            collectionAlllist.reloadData()
            categoryary = Wallcategoryary
            collectioncategory.reloadData()
            
        }
        
    }
    
    //MARK:- Search bar delegate methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if(iscategory == false){
            if(searchText != "")
            {
                    Allwallpaperlist.removeAll()
                    for dic in newAllwallpaperlist
                    {
                        if(dic.name.lowercased().contains(searchText.lowercased()))
                        {
                            Allwallpaperlist.append(dic)
                        }
                        
                    }
                    
                    collectionAlllist.reloadData()
                
            }
            else{
                Allwallpaperlist = newAllwallpaperlist
                collectionAlllist.reloadData()
            }
        }
        else{
            if(searchText != "")
            {
                categoryary.removeAll()
                for dic in Wallcategoryary
                {
                    if(dic.name.lowercased().contains(searchText.lowercased()))
                    {
                        categoryary.append(dic)
                    }
                    
                }
                
                collectioncategory.reloadData()
                
            }
            else{
                categoryary = Wallcategoryary
                collectioncategory.reloadData()
            }
            
        }
  
}
 
func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
   
      if(iscategory == false){
    Allwallpaperlist = newAllwallpaperlist
    collectionAlllist.reloadData()
    }
    else
      {
        categoryary = Wallcategoryary
        collectioncategory.reloadData()
        
    }
}



//MARK:- Scrollpager bar delegate methods
func scrollPager(scrollPager: ScrollPager, changedIndex: Int) {
    
    if(changedIndex == 0)
    {
        iscategory = true
        
    }
    else
    {
        
        iscategory = false
collectionAlllist.reloadData()
    }
    
    
}

override func viewDidLoad() {
    super.viewDidLoad()
    collectionAlllist.delegate = self
    collectionAlllist.dataSource = self
    searchbar.delegate = self
   GetFavWallpaper()
    getwallpapercat()
    getallwallpapers()
    collectionlist.register(UINib(nibName: "WallpaperListCell", bundle: nil), forCellWithReuseIdentifier: "cell")
    collectionAlllist.register(UINib(nibName: "AllwallpaperListCell", bundle: nil), forCellReuseIdentifier:"cell")
    
    let view: UIView = viewwallpaper
    
    pager.delegate = self
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

//MARK:- Collection view delegate & data source methods
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
        dvc.btnremove.isHidden = true
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
        popOverConfirmVC.isfromcategory = 1
        popOverConfirmVC.index1 = indexPath.row
        popOverConfirmVC.favidary = self.favidary

        self.addChildViewController(popOverConfirmVC)
        popOverConfirmVC.view.frame = self.view.frame
        self.view.center = popOverConfirmVC.view.center
        self.view.addSubview(popOverConfirmVC.view)
        popOverConfirmVC.didMove(toParentViewController: self)
        
    }
    
}

func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    
    cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
    UIView.animate(withDuration: 0.25, animations: {
        cell.layer.transform = CATransform3DMakeScale(1,1,1)
    })
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let dvc: AllwallpaperListCell = tableView.dequeueReusableCell(withIdentifier:"cell", for: indexPath) as! AllwallpaperListCell
    
    let dic = Allwallpaperlist[indexPath.row]
    
    let url = "http://innoviussoftware.com/walltones/storage/app/" + dic.icon
    var newurl = NSURL(string: url)
    dvc.imgview.sd_setImage(with: newurl! as URL, placeholderImage: #imageLiteral(resourceName: "Default-wallpaper"))
    dvc.lbldes.text = dic.description
    dvc.lblname.text = dic.name + " ," + dic.categoryName
    dvc.lbldes.sizeToFit()
    dvc.view.layer.cornerRadius = 8
   dvc.imgfav.isUserInteractionEnabled = true
    dvc.imgfav.tag = indexPath.row
   
    if(favidary.contains(dic.id))
    {
        let tap = UITapGestureRecognizer()
      
       tap.addTarget(self, action: #selector(RemoveFavourite1))
      dvc.imgfav.addGestureRecognizer(tap)
        dvc.imgfav.image = #imageLiteral(resourceName: "heart-solid")
    }
    else
    {
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(AddtoFavourite1))
        dvc.imgfav.addGestureRecognizer(tap)
      dvc.imgfav.image = #imageLiteral(resourceName: "heart-regular")
    }
    
    
    
    if(dic.description != nil)
    {
        
        dvc.height.constant = 24
    }
    else
    {
        dvc.height.constant = 0
    }
    
    if(dic.downloadCount == nil)
    {
        dvc.lbldowncount.text = "0"
    }
    else
    {
        dvc.lbldowncount.text = dic.downloadCount
    }
    return dvc
    
}
    @objc func AddtoFavourite1(sender:UITapGestureRecognizer)
    {
        var parameters:Parameters = ["wallpaper_id":self.Allwallpaperlist[sender.view!.tag].id ,"user_id":UserDefaults.standard.value(forKey:"userid") as! Int]
        
        StartSpinner()
        Alamofire.request(webservices().baseurl + "favoritewallpaper", method: .post, parameters:parameters, encoding: JSONEncoding.default, headers:nil).responseJSON{ (response:DataResponse<Any>) in
            switch response.result{
            case .success(let resp):
                print(resp)
                let index = NSIndexPath(row: (sender.view?.tag)!, section: 0)
                let cell:AllwallpaperListCell = self.collectionAlllist.cellForRow(at: index as IndexPath) as! AllwallpaperListCell
                cell.imgfav.image = #imageLiteral(resourceName: "heart-solid")
                StopSpinner()
                self.GetFavWallpaper()

                
                StopSpinner()
            case .failure(let err):
                print(err)
                print("Failed to change ")
                let alert = webservices.sharedInstance.AlertBuilder(title:  "OOps", message: "Unable to add")
                self.present(alert, animated: true, completion: nil)
                StopSpinner()
                
                
            }
            
            
            
        }
    }
    @objc func RemoveFavourite1(sender:UITapGestureRecognizer)
    {
        
        var parameters:Parameters = ["wallpaper_id":self.Allwallpaperlist[sender.view!.tag].id ,"user_id":UserDefaults.standard.value(forKey:"userid") as! Int]
        
        StartSpinner()
        Alamofire.request(webservices().baseurl + "removefavoritewallpaper", method: .post, parameters:parameters, encoding: JSONEncoding.default, headers:nil).responseJSON{ (response:DataResponse<Any>) in
            switch response.result{
            case .success(let resp):
                print(resp)
                let index = NSIndexPath(row: (sender.view?.tag)!, section: 0)
                let cell:AllwallpaperListCell = self.collectionAlllist.cellForRow(at: index as IndexPath) as! AllwallpaperListCell
                cell.imgfav.image = #imageLiteral(resourceName: "heart-regular")

                StopSpinner()
                self.GetFavWallpaper()
                
                
                StopSpinner()
            case .failure(let err):
                print(err)
                print("Failed to change ")
                let alert = webservices.sharedInstance.AlertBuilder(title:  "OOps", message: "Unable to remove")
                self.present(alert, animated: true, completion: nil)
                StopSpinner()
                
                
            }
            
            
            
        }
    }
    
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return Allwallpaperlist.count
}

func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      if #available(iOS 10.0, *) {
    return UITableViewAutomaticDimension
    }
    else
      {
      return 363
        
    }
}
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let popOverConfirmVC = self.storyboard?.instantiateViewController(withIdentifier: "WallpaperDetilVC") as! WallpaperDetilVC
    popOverConfirmVC.Allwallpaperlist = Allwallpaperlist
    popOverConfirmVC.index1 = indexPath.row
    popOverConfirmVC.isfromcategory = 1
    popOverConfirmVC.favidary = self.favidary
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
                    self.Wallcategoryary = resp.data
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
                    self.newAllwallpaperlist = resp.data
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
                     let data = resp.data
                        self.favidary.removeAllObjects()
                        for dic in data
                        {
                          self.favidary.add(dic.id)
                            
                        }
                        
                        
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
