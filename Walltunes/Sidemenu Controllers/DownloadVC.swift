//
//  DownloadVC.swift
//  Walltones
//
//  Created by Ravi Dubey on 7/16/18.
//  Copyright © 2018 Ravi Dubey. All rights reserved.
//

import UIKit
import ScrollPager
import Alamofire
import SDWebImage
import AVKit
import AVFoundation
class DownloadVC: UIViewController,UICollectionViewDelegate , UICollectionViewDataSource, UITableViewDelegate , UITableViewDataSource, UICollectionViewDelegateFlowLayout ,ScrollPagerDelegate{

    var playerViewController = AVPlayerViewController()
    var CollectionWallpaper =  UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    var ringtonelist = UITableView()
    
    @IBOutlet weak var btnsidemenu: UIButton!
    
    @IBOutlet weak var pager: ScrollPager!
    
    var ringtoneary = [DownRingtone]()
    var wallpaperary = [DownWallpaper]()

    
    var isplaying = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
       // DownloadedRongtone()
        DownloadedWallpaper()
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

    
    
    func DownloadedRongtone()
    {
        if AppDelegate.hasConnectivity() == true
        {
            StartSpinner()
            
            Alamofire.request(webservices().baseurl + "downloadringtonelist", method: .post, parameters: ["user_id":UserDefaults.standard.value(forKey:"userid")!], encoding: JSONEncoding.default, headers: nil).responseJSONDecodable{(response:DataResponse<Downloadedringtone>) in
                switch response.result{
                    
                case .success(let resp):
                    print(resp)
                    StopSpinner()
                    if(resp.errorCode == 0)
                    {
                       self.ringtoneary = resp.data
                        var alreadyThere = Set<DownRingtone>()
                        let uniquePosts = self.ringtoneary.compactMap { (DownRingtone) -> DownRingtone? in
                            guard !alreadyThere.contains(DownRingtone) else { return nil }
                            alreadyThere.insert(DownRingtone)
                            return DownRingtone
                        }
                       self.ringtoneary = uniquePosts
                        self.ringtonelist.reloadData()

                        if(self.ringtoneary.count == 0)
                        {
                            let alert = webservices.sharedInstance.AlertBuilder(title:"", message:"No downloaded ringtone available")
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                        
                    }
                    
                case .failure(let err):
                    let alert = webservices.sharedInstance.AlertBuilder(title:"", message:"Could not get load Downloaded ringtone list")
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
    
    func DownloadedWallpaper()
    {
        if AppDelegate.hasConnectivity() == true
        {
            StartSpinner()
            
            Alamofire.request(webservices().baseurl + "downloadwallpaperlist", method: .post, parameters: ["user_id":UserDefaults.standard.value(forKey:"userid")!], encoding: JSONEncoding.default, headers: nil).responseJSONDecodable{(response:DataResponse<Downloadedwallpaper>) in
                switch response.result{
                    
                case .success(let resp):
                    print(resp)
                    StopSpinner()
                    if(resp.errorCode == 0)
                    {
                        
                        self.wallpaperary = resp.data
                        var alreadyThere = Set<DownWallpaper>()
                        let uniquePosts = self.wallpaperary.compactMap { (DownWallpaper) -> DownWallpaper? in
                            guard !alreadyThere.contains(DownWallpaper) else { return nil }
                            alreadyThere.insert(DownWallpaper)
                            return DownWallpaper
                        }
                        self.wallpaperary = uniquePosts
                        self.CollectionWallpaper.reloadData()

                        if(self.wallpaperary.count == 0)
                        {
                            let alert = webservices.sharedInstance.AlertBuilder(title:"", message:"No downloaded Wallapaper available")
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                        
                    }
                    
                case .failure(let err):
                    let alert = webservices.sharedInstance.AlertBuilder(title:"", message:"Could not get load Downloaded Wallapaper")
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ringtoneary.count
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 121
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var dvc: TotalringtonelistCell = tableView.dequeueReusableCell(withIdentifier:"cell", for: indexPath) as! TotalringtonelistCell
        var colorary = [UIColor(red:0.75, green:0.75, blue:0.75, alpha:1.0),]
        dvc.selectionStyle = .none
        let dic = ringtoneary[indexPath.row]
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wallpaperary.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var dvc: WallpaperListCell = collectionView.dequeueReusableCell(withReuseIdentifier:"cell", for: indexPath) as! WallpaperListCell
        let dic = wallpaperary[indexPath.row]
        
        let url = "http://innoviussoftware.com/walltones/storage/app/" + dic.icon!
        var newurl = NSURL(string: url)
        
        
        dvc.backgroundColor = UIColor.white
        dvc.imgview.sd_setImage(with: newurl as! URL, placeholderImage: UIImage(named: "default-user"))
        dvc.btnremove.tag = indexPath.row
        dvc.btnremove.isHidden = true
        
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
        let dic = wallpaperary[indexPath.row]
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
    
    @objc func playerDidFinishPlaying(note: NSNotification){
        print("Video Finished")
        isplaying = 0
        for cell in self.ringtonelist.visibleCells  as! [TotalringtonelistCell]    {
            
            cell.btnplay.setImage(#imageLiteral(resourceName: "unnamed"), for: .normal)
        }
    }
    
    @objc func playaudiomethod(sender:UIButton)
    {
        
        if(isplaying == 0)
        {
            
            print(sender.tag)
            
            let indexPath = IndexPath(row: sender.tag, section: 0)
            
            var cell: TotalringtonelistCell = ringtonelist.cellForRow(at: indexPath) as!TotalringtonelistCell
            
            let dic = ringtoneary[sender.tag]
            let url = NSURL(string:"http://innoviussoftware.com/walltones/storage/app/" + dic.file!)
            
            do {
                
                let avAsset = AVURLAsset(url: url as! URL, options: nil)
                
                let videoURL = url
                playerViewController = AVPlayerViewController()
                
                DispatchQueue.main.async() {
                    
                    for cell in self.ringtonelist.visibleCells  as! [TotalringtonelistCell]    {
                        
                        cell.btnplay.setImage(#imageLiteral(resourceName: "unnamed"), for: .normal)
                    }
                    self.playerViewController.player = AVPlayer(url: videoURL! as URL) as AVPlayer
                    self.playerViewController.player?.play()
                    cell.btnplay.setImage(#imageLiteral(resourceName: "pause-circle-solid"), for: .normal)
                      NotificationCenter.default.addObserver(self, selector:#selector(self.playerDidFinishPlaying(note:)),name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerViewController.player?.currentItem)
                 
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
    func scrollPager(scrollPager: ScrollPager, changedIndex: Int) {
     if(changedIndex == 0)
       {
        DownloadedWallpaper()
        
        }
        else
       {
        
        DownloadedRongtone()
        }
        
    }
    
    @IBAction func setasaction(_ sender: Any) {
        
        let alert = webservices.sharedInstance.AlertBuilder(title:"", message:"Coming Soon")
        self.present(alert, animated: true, completion: nil)
        
        
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
extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        
        return result
    }
}

