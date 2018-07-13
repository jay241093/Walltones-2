//
//  RingtoneListVC.swift
//  Walltones
//
//  Created by Ravi Dubey on 7/5/18.
//  Copyright © 2018 Ravi Dubey. All rights reserved.
//

import UIKit
import Alamofire
import ScrollPager
import AVKit
import AVFoundation
func setShadow(view: UIView)
{
    view.layer.shadowColor = UIColor.lightGray.cgColor
    view.layer.shadowOpacity = 0.5
    view.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
    view.layer.shadowRadius = 2
}


class RingtoneListVC: UIViewController,UICollectionViewDelegate , UICollectionViewDataSource , UITableViewDataSource , UITableViewDelegate , UISearchBarDelegate, ScrollPagerDelegate{
   
 var playerViewController = AVPlayerViewController()
    @IBOutlet weak var pager: ScrollPager!
    
    @IBOutlet weak var btnsidemenu: UIBarButtonItem!
    @IBOutlet var viewlist: UIView!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var collectionview: UICollectionView!
    
    @IBOutlet weak var tblview: UITableView!
    
    var Categorylist = [RingtoneCategory]()
    var newCategorylist = [RingtoneCategory]()
var favidary = NSMutableArray()
    var Ringtonelist = [Ringlist]()

    var AllRingtonelist = [allringlist]()
    var newAllRingtonelist = [allringlist]()

    var ringtonelist = UITableView()
    var isplaying = 0
    var issearch = 0
    var  searchbar = UISearchBar()
    var playbackSlider:UISlider?
var iscategory = true
    @IBOutlet weak var btnsearch: UIButton!
    
    @IBAction func searchaction(_ sender: Any) {
    
        if(issearch == 0)
        {
            issearch = 1
            // searchbar.isHidden = false
            searchbar.placeholder = "searchbartext"
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
            label.text = "Ringtones"
            label.font = UIFont(name:"HelveticaNeue-Bold", size: 18.0)
            self.navigationItem.titleView = label

            AllRingtonelist = newAllRingtonelist
            ringtonelist.reloadData()
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblview.separatorStyle = .none
        tblview.separatorStyle = .none

        navigationController?.navigationBar.isHidden = false
        let view: UIView = viewlist
        getallringtonelist()
        GetringtoneCategory()
         GetFavRingtones()
        
        ringtonelist.delegate = self
        ringtonelist.dataSource = self
        ringtonelist.register(UINib(nibName: "TotalringtonelistCell", bundle: nil), forCellReuseIdentifier:"cell")

        pager.addSegmentsWithTitlesAndViews(segments: [("Category",view),("List",ringtonelist),])
        if revealViewController() != nil
        {
            btn.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
        // Do any additional setup after loading the view.
    }
    //MARK:- Search bar delegate methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if(iscategory == false){
            if(searchText != "")
            {
                AllRingtonelist.removeAll()
                for dic in newAllRingtonelist
                {
                    if(dic.name.lowercased().contains(searchText.lowercased()))
                    {
                        AllRingtonelist.append(dic)
                    }
                    
                }
                
                ringtonelist.reloadData()
                
            }
            else{
                AllRingtonelist = newAllRingtonelist
                ringtonelist.reloadData()
            }
        }
        else{
            if(searchText != "")
            {
                Categorylist.removeAll()
                for dic in newCategorylist
                {
                    if(dic.name.lowercased().contains(searchText.lowercased()))
                    {
                        Categorylist.append(dic)
                    }
                    
                }
                
                collectionview.reloadData()
                
            }
            else{
                Categorylist = newCategorylist
                collectionview.reloadData()
            }
            
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        if(iscategory == false){
            AllRingtonelist = newAllRingtonelist
            ringtonelist.reloadData()
        }
        else
        {
            Categorylist = newCategorylist
            collectionview.reloadData()
            
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
            ringtonelist.reloadData()

        }
        
        
    }

    
    //Mark : delegate and data source methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.Categorylist.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var dvc: WallpaperCategorycell = collectionView.dequeueReusableCell(withReuseIdentifier:"cell", for: indexPath) as! WallpaperCategorycell
        
        let dic = Categorylist[indexPath.row]
    
        
        dvc.imgview.layer.borderWidth=1.0
        dvc.imgview.layer.masksToBounds = false
        dvc.imgview.layer.borderColor = UIColor.white.cgColor
        dvc.imgview.layer.cornerRadius = 8
        dvc.imgview.clipsToBounds = true
        dvc.lblcategoryname.text = dic.name
        let url = "http://innoviussoftware.com/walltones/storage/app/" + dic.tabIcon
        var newurl = NSURL(string: url)
        dvc.imgview.sd_setImage(with: newurl as! URL, placeholderImage:#imageLiteral(resourceName: "side"))
        
        return dvc
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let dic = Categorylist[indexPath.row]

        
        Getlist(id: dic.id)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == tblview)
        {
        return Ringtonelist.count
        }
        else
        {
          return AllRingtonelist.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        
        if(tableView == tblview)
        {
        var dvc: RIngtonelistCell = tableView.dequeueReusableCell(withIdentifier:"cell", for: indexPath) as! RIngtonelistCell
        var colorary = [UIColor(red:0.75, green:0.75, blue:0.75, alpha:1.0),]
        
        let dic = Ringtonelist[indexPath.row]
        dvc.selectionStyle = .none
        dvc.lblname.text = dic.name
        dvc.lbldes.text = dic.description
       setShadow(view: dvc.view)
        dvc.view.layer.cornerRadius = 8.0
        dvc.btnplay.addTarget(self, action:#selector(playaudiomethod), for: .touchUpInside)
        dvc.btnplay.tag = indexPath.row
            dvc.btnlike.tag = indexPath.row
         if(favidary.contains(dic.id))
         {
            dvc.btnlike.setImage(#imageLiteral(resourceName: "heart-solid"), for: .normal)
            dvc.btnlike.addTarget(self, action: #selector(RemoveFavourite1), for:.touchUpInside)

         }
         else
         {
            dvc.btnlike.setImage(#imageLiteral(resourceName: "heart-regular"), for: .normal)
            dvc.btnlike.addTarget(self, action: #selector(AddtoFavourite1), for:.touchUpInside)

            }
            
            
            return dvc

        }
        else
        {
            
            var dvc: TotalringtonelistCell = tableView.dequeueReusableCell(withIdentifier:"cell", for: indexPath) as! TotalringtonelistCell
            var colorary = [UIColor(red:0.75, green:0.75, blue:0.75, alpha:1.0),]
            setShadow(view: dvc.view)
            dvc.view.layer.cornerRadius = 8.0
            let dic = AllRingtonelist[indexPath.row]
            dvc.lblname.text = dic.name
            dvc.lbldes.text = dic.description
            dvc.selectionStyle = .none
            dvc.btnlike.tag = indexPath.row
            dvc.btnplay.addTarget(self, action:#selector(playaudiomethod1), for: .touchUpInside)
            dvc.btnplay.tag = indexPath.row
            if(favidary.contains(dic.id))
            {
                dvc.btnlike.setImage(#imageLiteral(resourceName: "heart-solid"), for: .normal)
                dvc.btnlike.addTarget(self, action: #selector(RemoveFavourite), for:.touchUpInside)

            }
            else
            {
                dvc.btnlike.setImage(#imageLiteral(resourceName: "heart-regular"), for: .normal)
                dvc.btnlike.addTarget(self, action: #selector(AddtoFavourite), for:.touchUpInside)

            }
            
            return dvc

        }
        

    }
    
    @objc func AddtoFavourite1(sender:UIButton)
    {
        
        var parameters:Parameters = ["ringtone_id":self.Ringtonelist[sender.tag].id ,"user_id":UserDefaults.standard.value(forKey:"userid") as! Int]
        
        StartSpinner()
        Alamofire.request(webservices().baseurl + "favoriteringtone", method: .post, parameters:parameters, encoding: JSONEncoding.default, headers:nil).responseJSON{ (response:DataResponse<Any>) in
            switch response.result{
            case .success(let resp):
                print(resp)
                let index = NSIndexPath(row: sender.tag, section: 0)
                let cell:RIngtonelistCell = self.tblview.cellForRow(at: index as IndexPath) as! RIngtonelistCell
                cell.btnlike.setImage(#imageLiteral(resourceName: "heart-solid"), for: .normal)
                StopSpinner()
                self.GetFavRingtones()
               
                
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
    @objc func RemoveFavourite(sender:UIButton)
    {
        var parameters:Parameters = ["ringtone_id":self.AllRingtonelist[sender.tag].id ,"user_id":UserDefaults.standard.value(forKey:"userid") as! Int]
        
        StartSpinner()
        Alamofire.request(webservices().baseurl + "removefavoriteringtone", method: .post, parameters:parameters, encoding: JSONEncoding.default, headers:nil).responseJSON{ (response:DataResponse<Any>) in
            switch response.result{
            case .success(let resp):
                print(resp)
                let index = NSIndexPath(row: sender.tag, section: 0)
                let cell:TotalringtonelistCell = self.ringtonelist.cellForRow(at: index as IndexPath) as! TotalringtonelistCell
                cell.btnlike.setImage(#imageLiteral(resourceName: "heart-regular"), for: .normal)
                StopSpinner()
                self.GetFavRingtones()
                
                
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
    @objc func RemoveFavourite1(sender:UIButton)
    {
        
        var parameters:Parameters = ["ringtone_id":self.Ringtonelist[sender.tag].id ,"user_id":UserDefaults.standard.value(forKey:"userid") as! Int]
        
        StartSpinner()
        Alamofire.request(webservices().baseurl + "removefavoriteringtone", method: .post, parameters:parameters, encoding: JSONEncoding.default, headers:nil).responseJSON{ (response:DataResponse<Any>) in
            switch response.result{
            case .success(let resp):
                print(resp)
                let index = NSIndexPath(row: sender.tag, section: 0)
                let cell:RIngtonelistCell = self.tblview.cellForRow(at: index as IndexPath) as! RIngtonelistCell
                cell.btnlike.setImage(#imageLiteral(resourceName: "heart-regular"), for: .normal)
                StopSpinner()
                self.GetFavRingtones()
                
                
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
    
    
    
    @objc func AddtoFavourite(sender:UIButton)
{
    
    var parameters:Parameters = ["ringtone_id":self.AllRingtonelist[sender.tag].id ,"user_id":UserDefaults.standard.value(forKey:"userid") as! Int]
    
  StartSpinner()
 Alamofire.request(webservices().baseurl + "favoriteringtone", method: .post, parameters:parameters, encoding: JSONEncoding.default, headers:nil).responseJSON{ (response:DataResponse<Any>) in
    switch response.result{
    case .success(let resp):
        print(resp)
        let index = NSIndexPath(row: sender.tag, section: 0)
        let cell:TotalringtonelistCell = self.ringtonelist.cellForRow(at: index as IndexPath) as! TotalringtonelistCell
        cell.btnlike.setImage(#imageLiteral(resourceName: "heart-solid"), for: .normal)
        StopSpinner()
        self.GetFavRingtones()
        
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 109
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    if(tableView == tblview)
    {
        
        self.playerViewController.player?.pause()
        let popOverConfirmVC = self.storyboard?.instantiateViewController(withIdentifier: "RingtoneDetailVC") as! RingtoneDetailVC
        popOverConfirmVC.index1 = indexPath.row
        popOverConfirmVC.isfromcategory = 1
        popOverConfirmVC.favidary = self.favidary
        popOverConfirmVC.ringtonelist = Ringtonelist
        self.addChildViewController(popOverConfirmVC)
        popOverConfirmVC.index1 =  indexPath.row
        
        popOverConfirmVC.view.frame = self.view.frame
        self.view.center = popOverConfirmVC.view.center
        self.view.addSubview(popOverConfirmVC.view)
        popOverConfirmVC.didMove(toParentViewController: self)
        playerViewController.player?.pause()
        
        
        
        }
       else
        
    {
        self.playerViewController.player?.pause()
        let popOverConfirmVC = self.storyboard?.instantiateViewController(withIdentifier: "RingtoneDetailVC") as! RingtoneDetailVC
        popOverConfirmVC.isfromcategory = 1
        popOverConfirmVC.favidary = self.favidary
        popOverConfirmVC.allringtone = AllRingtonelist
        popOverConfirmVC.index1 =  indexPath.row
        self.addChildViewController(popOverConfirmVC)
        popOverConfirmVC.view.frame = self.view.frame
        self.view.center = popOverConfirmVC.view.center
        self.view.addSubview(popOverConfirmVC.view)
        popOverConfirmVC.didMove(toParentViewController: self)
        
        
        }
        
        
        
    }
    
    
    //Mark : Userdefine Function

    @objc func playaudiomethod(sender:UIButton)
    {
    
      if(isplaying == 0)
      {
        
          print(sender.tag)
        
        let indexPath = IndexPath(row: sender.tag, section: 0)

        var cell: RIngtonelistCell = tblview.cellForRow(at: indexPath) as!RIngtonelistCell
        
        let dic = Ringtonelist[sender.tag]
       let url = NSURL(string:"http://innoviussoftware.com/walltones/storage/app/" + dic.file)
        
        do {
            
            let avAsset = AVURLAsset(url: url as! URL, options: nil)
            
            let videoURL = url
            playerViewController = AVPlayerViewController()
            
            DispatchQueue.main.async() {
                self.playerViewController.player = AVPlayer(url: videoURL as! URL) as AVPlayer
                self.playerViewController.player?.play()
                cell.btnplay.setImage(#imageLiteral(resourceName: "pause-circle-solid"), for: .normal)
                let playerItem:AVPlayerItem = AVPlayerItem(url: videoURL! as URL)
                var player = AVPlayer(playerItem: playerItem)
              
                
                //playbackSlider!.addTarget(self, action: "playbackSliderValueChanged:", for: .valueChanged)
                
                
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
        
        var cell: RIngtonelistCell = tblview.cellForRow(at: indexPath) as!RIngtonelistCell
        
        cell.btnplay.setImage(#imageLiteral(resourceName: "unnamed"), for: .normal)
        
        self.playerViewController.player?.pause()
        }
        
        
    }
    @objc func playaudiomethod1(sender:UIButton)
    {
        
        if(isplaying == 0)
        {
            
            print(sender.tag)
            
            let indexPath = IndexPath(row: sender.tag, section: 0)
            
            var cell: TotalringtonelistCell = ringtonelist.cellForRow(at: indexPath) as!TotalringtonelistCell
            
            let dic = AllRingtonelist[sender.tag]
            let url = NSURL(string:"http://innoviussoftware.com/walltones/storage/app/" + dic.file)
            
            do {
                
                let avAsset = AVURLAsset(url: url as! URL, options: nil)
                
                let videoURL = url
                playerViewController = AVPlayerViewController()
                
                DispatchQueue.main.async() {
                    self.playerViewController.player = AVPlayer(url: videoURL as! URL) as AVPlayer
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
    
func  GetringtoneCategory()
{
    
    if AppDelegate.hasConnectivity() == true
    {
        StartSpinner()
        
        Alamofire.request(webservices().baseurl + "getringtonecat", method: .post, parameters: [:], encoding: JSONEncoding.default, headers: nil).responseJSONDecodable{(response:DataResponse<RingtioneCat>) in
            switch response.result{
                
            case .success(let resp):
                print(resp)
                StopSpinner()
                if(resp.errorCode == 0)
                {
                    self.newCategorylist = resp.data
                    self.Categorylist = resp.data
                 self.collectionview.reloadData()
                    if(self.Categorylist.count > 0)
                    {
                        self.Getlist(id: self.Categorylist[0].id)
                    }
                }
                
            case .failure(let err): break
            let alert = webservices.sharedInstance.AlertBuilder(title:"", message:"Could not get load ringne category")
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
    
    func  Getlist(id:Int)
    {
        
        if AppDelegate.hasConnectivity() == true
        {
            StartSpinner()
            
            Alamofire.request(webservices().baseurl + "getcatringtone", method: .post, parameters: ["category_id":id], encoding: JSONEncoding.default, headers: nil).responseJSONDecodable{(response:DataResponse<Ringtionelist>) in
                switch response.result{
                    
                case .success(let resp):
                    print(resp)
                    StopSpinner()
                    if(resp.errorCode == 0)
                    {
                        self.Ringtonelist.removeAll()
                        self.Ringtonelist = resp.data
                         self.tblview.reloadData()
                    }
                    
                case .failure(let err): break
                let alert = webservices.sharedInstance.AlertBuilder(title:"", message:"Could not get load ringtone list")
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
    func  getallringtonelist()
    {
        
        if AppDelegate.hasConnectivity() == true
        {
            StartSpinner()
            
            Alamofire.request(webservices().baseurl + "getringtone", method: .post, parameters: [:], encoding: JSONEncoding.default, headers: nil).responseJSONDecodable{(response:DataResponse<Allringtonelist>) in
                switch response.result{
                    
                case .success(let resp):
                    print(resp)
                    StopSpinner()
                    if(resp.errorCode == 0)
                    {
                    
                        self.newAllRingtonelist = resp.data
                        self.AllRingtonelist = resp.data
                        self.ringtonelist.reloadData()
                    }
                    
                case .failure(let err): break
                let alert = webservices.sharedInstance.AlertBuilder(title:"", message:"Could not get load ringne category")
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
                    self.favidary.removeAllObjects()
                    if(resp.errorCode == 0)
                    {
                        let data = resp.data
                        for dic in data
                        {
                            
                            self.favidary.add(dic.id)
                            
                        }
            
                        
                    }
                    
                case .failure(let err): break
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
