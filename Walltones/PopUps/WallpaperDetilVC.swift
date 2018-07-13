

//
//  WallpaperDetilVC.swift
//  Walltones
//
//  Created by Ravi Dubey on 7/5/18.
//  Copyright © 2018 Ravi Dubey. All rights reserved.
//

import UIKit
import FSPagerView
import Alamofire
class WallpaperDetilVC: UIViewController ,FSPagerViewDelegate , FSPagerViewDataSource{

    @IBOutlet weak var lblname: UILabel!
    
    @IBOutlet weak var lblnum: UILabel!
    
    var wallpaperlistnew = [Datum1]()
    
    @IBOutlet weak var btnlike: UIButton!
    
    var Allwallpaperlist = [wallpaperlist]()
var index1 = 0
 var isfromcategory = 0
var favidary = NSMutableArray()
    fileprivate let transformerTypes: [FSPagerViewTransformerType] = [.crossFading,
                                                                      .zoomOut,
                                                                      .depth,
                                                                      .linear,
                                                                      .overlap,
                                                                      .ferrisWheel,
                                                                      .invertedFerrisWheel,
                                                                      .coverFlow,
                                                                      .cubic]
    fileprivate var typeIndex = 0 {
        didSet {
            let type = self.transformerTypes[typeIndex]
            self.pagerview.transformer = FSPagerViewTransformer(type:type)
            switch type {
            case .crossFading, .zoomOut, .depth:
                self.pagerview.itemSize = .zero // 'Zero' means fill the size of parent
            case .linear, .overlap:
                let transform = CGAffineTransform(scaleX: 0.6, y: 0.75)
                self.pagerview.itemSize = self.pagerview.frame.size.applying(transform)
            case .ferrisWheel, .invertedFerrisWheel:
                self.pagerview.itemSize = CGSize(width: 180, height: 140)
            case .coverFlow:
                self.pagerview.itemSize = CGSize(width: 220, height: 170)
            case .cubic:
                let transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                self.pagerview.itemSize = self.pagerview.frame.size.applying(transform)
            }
        }
    }
    @IBOutlet weak var pagerview: FSPagerView!{
        didSet {
            self.pagerview.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.pagerview.itemSize = .zero
        }
    }
    
 // MARK: - IBaction methods

    
    @IBAction func shareaction(_ sender: Any) {
        
        if(wallpaperlistnew.count > 0)
        {
        let dic =  self.wallpaperlistnew[self.index1].icon
        
        let url = "http://innoviussoftware.com/walltones/storage/app/" + dic!

        
       var shareText = "URL :\(url)"
        let vc = UIActivityViewController(activityItems: [shareText], applicationActivities: [])
        present(vc, animated: true)
        }
        else
        {
        let dic =  self.Allwallpaperlist[self.index1].icon
            
            let url = "http://innoviussoftware.com/walltones/storage/app/" + dic
            
            
            var shareText = "URL :\(url)"
            let vc = UIActivityViewController(activityItems: [shareText], applicationActivities: [])
            present(vc, animated: true)
        }
    }
    
    
    @IBAction func downloadaction(_ sender: Any) {
        
       
        
     if(wallpaperlistnew.count != 0)
     {
        let refreshAlert = UIAlertController(title: nil, message: "Are you sure you want to download this image ?", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            
          
           StartSpinner()
            
            Alamofire.request(webservices().baseurl + "downloadwallpaper", method: .post, parameters:["wallpaper_id":self.wallpaperlistnew[self.index1].id ,"user_id":UserDefaults.standard.value(forKey:"userid") as! Int], encoding: JSONEncoding.default, headers:nil).responseJSON{ (response:DataResponse<Any>) in
                switch response.result{
                case .success(let resp):
                    print(resp)
                    
                    let dic =  self.wallpaperlistnew[self.index1].icon
                    var imageview = UIImageView()
                    
                    
                    let url = "http://innoviussoftware.com/walltones/storage/app/" + dic!
                    var newurl = NSURL(string: url)
                    
                     imageview.sd_setImage(with: newurl as! URL, placeholderImage: UIImage(named: "default-user"))
                    
                    UIImageWriteToSavedPhotosAlbum(imageview.image!, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)

                    StopSpinner()
                case .failure(let err):
                    print(err)
                    print("Failed to change ")
                    let alert = webservices.sharedInstance.AlertBuilder(title:  "OOps", message: "Unable to Change Driver Status \n Try Again")
                    self.present(alert, animated: true, completion: nil)
                    StopSpinner()
                    
                    
                }
                
                

            }
           
            //
            //            appDel.window?.rootViewController = FirstVC
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        
        present(refreshAlert, animated: true, completion: nil)
        }
       else
     {
        let refreshAlert = UIAlertController(title: nil, message: "Are you sure you want to download this image ?", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            
            
              StartSpinner()
            
            Alamofire.request(webservices().baseurl + "downloadwallpaper", method: .post, parameters:["wallpaper_id":self.Allwallpaperlist[self.index1].id ,"user_id":UserDefaults.standard.value(forKey:"userid") as! Int], encoding: JSONEncoding.default, headers:nil).responseJSON{ (response:DataResponse<Any>) in
                switch response.result{
                case .success(let resp):
                    print(resp)
                    
                    let dic =  self.Allwallpaperlist[self.index1].icon
                    var imageview = UIImageView()
                    
                    
                    let url = "http://innoviussoftware.com/walltones/storage/app/" + dic
                    var newurl = NSURL(string: url)
                    
                    imageview.sd_setImage(with: newurl as! URL, placeholderImage:#imageLiteral(resourceName: "Default-wallpaper"))
                    
                    UIImageWriteToSavedPhotosAlbum(imageview.image!, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
                    
                    StopSpinner()
                case .failure(let err):
                    print(err)
                    print("Failed to change ")
                    let alert = webservices.sharedInstance.AlertBuilder(title:  "OOps", message: "Unable to Change Driver Status \n Try Again")
                    self.present(alert, animated: true, completion: nil)
                    StopSpinner()
                    
                    
                }
                
                
                
            }
            
            //
            //            appDel.window?.rootViewController = FirstVC
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        
        present(refreshAlert, animated: true, completion: nil)
        
        }
        
        
    }
    
    
    @IBAction func likeaction(_ sender: UIButton) {
        var parameters : Parameters = [:]
if(self.wallpaperlistnew.count > 0)
{
 if(favidary.contains(self.wallpaperlistnew[index1].id))
 {
    
    if(wallpaperlistnew.count != 0)
    {
        parameters = ["wallpaper_id":self.wallpaperlistnew[self.index1].id ,"user_id":UserDefaults.standard.value(forKey:"userid") as! Int]
    }
    else
    {
        
        parameters = ["wallpaper_id":self.wallpaperlistnew[self.index1].id ,"user_id":UserDefaults.standard.value(forKey:"userid") as! Int]
        
        
    }
    
    StartSpinner()
    Alamofire.request(webservices().baseurl + "removefavoritewallpaper", method: .post, parameters:parameters, encoding: JSONEncoding.default, headers:nil).responseJSON{ (response:DataResponse<Any>) in
        switch response.result{
        case .success(let resp):
            print(resp)
           
            self.GetFavWallpaper()
            sender.setBackgroundImage(#imageLiteral(resourceName: "love"), for:.normal)

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
    else{
    
    if(wallpaperlistnew.count != 0)
    {
        parameters = ["wallpaper_id":self.wallpaperlistnew[self.index1].id ,"user_id":UserDefaults.standard.value(forKey:"userid") as! Int]
    }
    else
    {
        
        parameters = ["wallpaper_id":self.Allwallpaperlist[self.index1].id ,"user_id":UserDefaults.standard.value(forKey:"userid") as! Int]
        
        
    }
    
    StartSpinner()
    Alamofire.request(webservices().baseurl + "favoritewallpaper", method: .post, parameters:parameters, encoding: JSONEncoding.default, headers:nil).responseJSON{ (response:DataResponse<Any>) in
        switch response.result{
        case .success(let resp):
            print(resp)
            sender.setBackgroundImage(#imageLiteral(resourceName: "heart-solid"), for:.normal)

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
    
        }
        
    else
{
    if(favidary.contains(self.Allwallpaperlist[index1].id))
    {
        if(Allwallpaperlist.count != 0)
        {
            parameters = ["wallpaper_id":self.Allwallpaperlist[self.index1].id ,"user_id":UserDefaults.standard.value(forKey:"userid") as! Int]
        }
        else
        {
            
            parameters = ["wallpaper_id":self.Allwallpaperlist[self.index1].id ,"user_id":UserDefaults.standard.value(forKey:"userid") as! Int]
            
            
        }
        
        StartSpinner()
        Alamofire.request(webservices().baseurl + "removefavoritewallpaper", method: .post, parameters:parameters, encoding: JSONEncoding.default, headers:nil).responseJSON{ (response:DataResponse<Any>) in
            switch response.result{
            case .success(let resp):
                print(resp)
                sender.setBackgroundImage(#imageLiteral(resourceName: "love"), for:.normal)

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
    else{
        
        if(Allwallpaperlist.count != 0)
        {
            parameters = ["wallpaper_id":self.Allwallpaperlist[self.index1].id ,"user_id":UserDefaults.standard.value(forKey:"userid") as! Int]
        }
        else
        {
            
            parameters = ["wallpaper_id":self.Allwallpaperlist[self.index1].id ,"user_id":UserDefaults.standard.value(forKey:"userid") as! Int]
            
            
        }
        
        StartSpinner()
        Alamofire.request(webservices().baseurl + "favoritewallpaper", method: .post, parameters:parameters, encoding: JSONEncoding.default, headers:nil).responseJSON{ (response:DataResponse<Any>) in
            switch response.result{
            case .success(let resp):
                print(resp)
                sender.setBackgroundImage(#imageLiteral(resourceName: "heart-solid"), for:.normal)

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
    
        }
        
    }
    
    @IBAction func closeaction(_ sender: Any) {
        removeAnimate()
    
    }
    
    
    // MARK: - Pager view delegate methods

    
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
       
        
        if(wallpaperlistnew.count != 0)
        {
        return wallpaperlistnew.count
        }
        else
        {
            
           return Allwallpaperlist.count
        }
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        
    if(wallpaperlistnew.count != 0)
    {
        if(isfromcategory == 1)
        {
            isfromcategory = 0
        pagerview.scrollToItem(at: index1, animated: false)
        }
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        let dic = wallpaperlistnew[index]
        
        let url = "http://innoviussoftware.com/walltones/storage/app/" + dic.icon!
        var newurl = NSURL(string: url)
        
        cell.imageView?.sd_setImage(with: newurl as! URL, placeholderImage:#imageLiteral(resourceName: "Default-wallpaper"))
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        return cell

        }
        else
    {
        if(isfromcategory == 1)
        {
            isfromcategory = 0
            pagerview.scrollToItem(at: index1, animated: false)
        }
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        let dic = Allwallpaperlist[index]
        
        let url = "http://innoviussoftware.com/walltones/storage/app/" + dic.icon
        var newurl = NSURL(string: url)
        
        cell.imageView?.sd_setImage(with: newurl as! URL, placeholderImage:#imageLiteral(resourceName: "Default-wallpaper"))
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        return cell

        }
    }
    
    // MARK:- FSPagerView Delegate
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
        
        if(wallpaperlistnew.count != 0)
        {
            let dic = wallpaperlistnew[index]
        let popOverConfirmVC = self.storyboard?.instantiateViewController(withIdentifier: "ImagepopUP") as! ImagepopUP
            let url = "http://innoviussoftware.com/walltones/storage/app/" + dic.icon!
            var newurl = NSURL(string: url)
            popOverConfirmVC.url = newurl!
        self.addChildViewController(popOverConfirmVC)
        popOverConfirmVC.view.frame = self.view.frame
        self.view.center = popOverConfirmVC.view.center
        self.view.addSubview(popOverConfirmVC.view)
        popOverConfirmVC.didMove(toParentViewController: self)
        }
        else
        {
            let dic = Allwallpaperlist[index]
            let popOverConfirmVC = self.storyboard?.instantiateViewController(withIdentifier: "ImagepopUP") as! ImagepopUP
            let url = "http://innoviussoftware.com/walltones/storage/app/" + dic.icon
            var newurl = NSURL(string: url)
            self.addChildViewController(popOverConfirmVC)
            popOverConfirmVC.url = newurl!

            popOverConfirmVC.view.frame = self.view.frame
            self.view.center = popOverConfirmVC.view.center
            self.view.addSubview(popOverConfirmVC.view)
            popOverConfirmVC.didMove(toParentViewController: self)
            
        }
        
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        
        print(targetIndex)
        index1 = targetIndex
        lblnum.text = " "
        if(wallpaperlistnew.count != 0)
        {
        if(targetIndex >= 0)
        {
        lblname.text = "Name :" + wallpaperlistnew[targetIndex].name + " \n" +  "categoryName :" + wallpaperlistnew[targetIndex].categoryName!
        if wallpaperlistnew[targetIndex].downloadCount != nil
        {
            lblnum.text = " " + wallpaperlistnew[targetIndex].downloadCount!
        }
        else
        {
            lblnum.text = "0"
        }
         if(favidary.contains( wallpaperlistnew[targetIndex].id))
         {
            btnlike.setBackgroundImage(#imageLiteral(resourceName: "heart-solid"), for: .normal)
            }
           else
         {
            btnlike.setBackgroundImage(#imageLiteral(resourceName: "love"), for: .normal)

            
            }
        }
        }
        else{
            if(targetIndex >= 0)
            {
            lblname.text = "Name :" + Allwallpaperlist[targetIndex].name + " \n" +  "categoryName :" + Allwallpaperlist[targetIndex].categoryName
            if Allwallpaperlist[targetIndex].downloadCount != nil
            {
                lblnum.text = " " + Allwallpaperlist[targetIndex].downloadCount!
            }
            else
            {
               lblnum.text = "0"
                }
                if(favidary.contains( Allwallpaperlist[targetIndex].id))
                {
                    btnlike.setBackgroundImage(#imageLiteral(resourceName: "heart-solid"), for: .normal)
                }
                else
                {
                    btnlike.setBackgroundImage(#imageLiteral(resourceName: "love"), for: .normal)
                    
                    
                }
                
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showAnimate()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
GetFavWallpaper()
//      if(wallpaperlistnew.count != 0)
//      {
//        if(favidary.contains( wallpaperlistnew[index1].id))
//        {
//            btnlike.setBackgroundImage(#imageLiteral(resourceName: "heart-solid"), for: .normal)
//        }
//        else
//        {
//            btnlike.setBackgroundImage(#imageLiteral(resourceName: "love"), for: .normal)
//        }
//
//        if wallpaperlistnew[index1].downloadCount != nil
//        {
//            lblnum.text = " " + wallpaperlistnew[index1].downloadCount!
//        }
//        else{
//
//            lblnum.text = " 0"
//
//        }
//        lblname.text = "Name :" + wallpaperlistnew[index1].name + " \n" +  "categoryName :" + wallpaperlistnew[index1].categoryName!
//        }
//        if(Allwallpaperlist.count != 0)
//        {
//            if(favidary.contains(Allwallpaperlist[index1].id))
//            {
//                btnlike.setBackgroundImage(#imageLiteral(resourceName: "heart-solid"), for: .normal)
//            }
//            else
//            {
//                btnlike.setBackgroundImage(#imageLiteral(resourceName: "love"), for: .normal)
//            }
//
//
//
//            if Allwallpaperlist[index1].downloadCount != nil
//            {
//                lblnum.text = " " + Allwallpaperlist[index1].downloadCount!
//            }
//            else{
//
//                lblnum.text = " 0"
//
//            }
//            lblname.text = "Name :" + Allwallpaperlist[index1].name + " \n" +  "categoryName :" + Allwallpaperlist[index1].categoryName
//            navigationController?.navigationBar.isHidden = true
//
//        }
        
        // Do any additional setup after loading the view.
    }

    
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        if(wallpaperlistnew.count != 0)
        {
            if(favidary.contains( wallpaperlistnew[index1].id))
            {
                btnlike.setBackgroundImage(#imageLiteral(resourceName: "heart-solid"), for: .normal)
            }
            else
            {
                btnlike.setBackgroundImage(#imageLiteral(resourceName: "love"), for: .normal)
            }
            
            if wallpaperlistnew[index1].downloadCount != nil
            {
                lblnum.text = " " + wallpaperlistnew[index1].downloadCount!
            }
            else{
                
                lblnum.text = " 0"
                
            }
            lblname.text = "Name :" + wallpaperlistnew[index1].name + " \n" +  "categoryName :" + wallpaperlistnew[index1].categoryName!
        }
        if(Allwallpaperlist.count != 0)
        {
            if(favidary.contains(Allwallpaperlist[index1].id))
            {
                btnlike.setBackgroundImage(#imageLiteral(resourceName: "heart-solid"), for: .normal)
            }
            else
            {
                btnlike.setBackgroundImage(#imageLiteral(resourceName: "love"), for: .normal)
            }
            
            
            
            if Allwallpaperlist[index1].downloadCount != nil
            {
                lblnum.text = " " + Allwallpaperlist[index1].downloadCount!
            }
            else{
                
                lblnum.text = " 0"
                
            }
            lblname.text = "Name :" + Allwallpaperlist[index1].name + " \n" +  "categoryName :" + Allwallpaperlist[index1].categoryName
            navigationController?.navigationBar.isHidden = true
            
        }
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    
    
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.navigationController?.navigationBar.isHidden = false

                self.view.removeFromSuperview()
                
            }
        });
    }
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
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
                            self.favidary.add(dic.id!)
                            
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
