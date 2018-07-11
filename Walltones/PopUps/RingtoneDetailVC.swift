
//
//  RingtoneDetailVC.swift
//  Walltones
//
//  Created by Ravi Dubey on 7/9/18.
//  Copyright © 2018 Ravi Dubey. All rights reserved.
//

import UIKit
import FSPagerView
import  Alamofire
import PKHUD
import AVKit

class RingtoneDetailVC: UIViewController , FSPagerViewDelegate , FSPagerViewDataSource , URLSessionDownloadDelegate{
    @IBOutlet weak var lblname: UILabel!
    
    @IBOutlet weak var lblnum: UILabel!
    
    @IBOutlet weak var btnplay: UIButton!
    var downloadTask: URLSessionDownloadTask!
    var backgroundSession: URLSession!
    var index1 = 0
    var isplaying = 0
    var ringtonelist = [Ringlist]()
    var allringtone = [allringlist]()
    var playerViewController = AVPlayerViewController()
    
    @IBOutlet weak var progressDownloadIndicator: UIProgressView!
    
    // MARK: - IBAction Mehtods
    
    @IBAction func closeaction(_ sender: Any) {
        removeAnimate()
        
    }
    
    @IBAction func PlayAction(_ sender: Any) {
        
        
        if(ringtonelist.count > 0)
        {
            
            if(index1 >= 0)
            {
                if(isplaying == 0)
                {
                    
                    
                    let dic = ringtonelist[index1]
                    let url = NSURL(string:"http://innoviussoftware.com/walltones/storage/app/" + dic.file)
                    
                    do {
                        
                        let avAsset = AVURLAsset(url: url as! URL, options: nil)
                        
                        let videoURL = url
                        playerViewController = AVPlayerViewController()
                        
                        DispatchQueue.main.async() {
                            self.playerViewController.player = AVPlayer(url: videoURL as! URL) as AVPlayer
                            self.playerViewController.player?.play()
                            self.btnplay.setBackgroundImage(#imageLiteral(resourceName: "pause-circle-solid"), for: .normal)
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
                    
                    
                    
                    btnplay.setBackgroundImage(#imageLiteral(resourceName: "unnamed"), for: .normal)
                    
                    self.playerViewController.player?.pause()
                }
            }
        }
        else
            
        {
            if(index1 >= 0)
            {
                
                if(isplaying == 0)
                {
                    
                    
                    let dic = allringtone[index1]
                    let url = NSURL(string:"http://innoviussoftware.com/walltones/storage/app/" + dic.file)
                    
                    do {
                        
                        let avAsset = AVURLAsset(url: url as! URL, options: nil)
                        
                        let videoURL = url
                        playerViewController = AVPlayerViewController()
                        
                        DispatchQueue.main.async() {
                            self.playerViewController.player = AVPlayer(url: videoURL as! URL) as AVPlayer
                            self.playerViewController.player?.play()
                            self.btnplay.setBackgroundImage(#imageLiteral(resourceName: "pause-circle-solid"), for: .normal)
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
                    
                    
                    
                    btnplay.setBackgroundImage(#imageLiteral(resourceName: "unnamed"), for: .normal)
                    
                    self.playerViewController.player?.pause()
                }
                
            }
            
        }
        
    }
    @IBAction func likeaction(_ sender: Any) {
        
        var parameters : Parameters = [:]
        if(ringtonelist.count != 0)
        {
            parameters = ["wallpaper_id":self.ringtonelist[self.index1].id ,"user_id":UserDefaults.standard.value(forKey:"userid") as! Int]
        }
        else
        {
            parameters = ["wallpaper_id":self.allringtone[self.index1].id ,"user_id":UserDefaults.standard.value(forKey:"userid") as! Int]
            
        }
        
        StartSpinner()
        Alamofire.request(webservices().baseurl + "favoriteringtone", method: .post, parameters:parameters, encoding: JSONEncoding.default, headers:nil).responseJSON{ (response:DataResponse<Any>) in
            switch response.result{
            case .success(let resp):
                print(resp)
                let alert = webservices.sharedInstance.AlertBuilder(title:  "", message: "Addes to Favourites")
                self.present(alert, animated: true, completion: nil)
                StopSpinner()
                
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
    
    @IBOutlet weak var pagerview: FSPagerView!{
        didSet {
            self.pagerview.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.pagerview.itemSize = .zero
        }
    }
    @IBAction func shareaction(_ sender: Any) {
        
        
        if(ringtonelist.count != 0)
        {
            let dic =  self.ringtonelist[self.index1].icon
            
            let url = "http://innoviussoftware.com/walltones/storage/app/" + dic
            
            
            var shareText = "URL :\(url)"
            let vc = UIActivityViewController(activityItems: [shareText], applicationActivities: [])
            present(vc, animated: true)
            
        }
        else
        {
            let dic =  self.allringtone[self.index1].icon
            
            let url = "http://innoviussoftware.com/walltones/storage/app/" + dic
            
            
            var shareText = "URL :\(url)"
            let vc = UIActivityViewController(activityItems: [shareText], applicationActivities: [])
            present(vc, animated: true)
            
            
        }
        
    }
    @IBAction func downloadaction(_ sender: Any) {
        
        
        
        if(ringtonelist.count != 0)
        {
            let refreshAlert = UIAlertController(title: nil, message: "Are you sure you want to download this Song ?", preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                
                
                StartSpinner()
                
                print(self.ringtonelist[self.index1].id)
                Alamofire.request(webservices().baseurl + "downloadringtone", method: .post, parameters:["ringtone_id":self.ringtonelist[self.index1].id ,"user_id":UserDefaults.standard.value(forKey:"userid") as! Int], encoding: JSONEncoding.default, headers:nil).responseJSON{ (response:DataResponse<Any>) in
                    switch response.result{
                    case .success(let resp):
                        print(resp)
                        
                        let dic =  self.ringtonelist[self.index1].file
                        var imageview = UIImageView()
                        
                        
                        let url1 = "http://innoviussoftware.com/walltones/storage/app/" + dic
                        let url = URL(string: url1)!
                        self.downloadTask = self.backgroundSession.downloadTask(with: url)
                        self.downloadTask.resume()
                        
                        StopSpinner()
                        self.progressDownloadIndicator.isHidden = false
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
            let refreshAlert = UIAlertController(title: nil, message: "Are you sure you want to download this Song ?", preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                
                
                StartSpinner()
                
                Alamofire.request(webservices().baseurl + "downloadringtone", method: .post, parameters:["ringtone_id":self.allringtone[self.index1].id ,"user_id":UserDefaults.standard.value(forKey:"userid") as! Int], encoding: JSONEncoding.default, headers:nil).responseJSON{ (response:DataResponse<Any>) in
                    switch response.result{
                    case .success(let resp):
                        print(resp)
                        
                        let dic =  self.allringtone[self.index1].file
                        var imageview = UIImageView()
                        
                        
                        let url1 = "http://innoviussoftware.com/walltones/storage/app/" + dic
                        
                        let url = URL(string: url1)!
                        self.downloadTask = self.backgroundSession.downloadTask(with: url)
                        self.downloadTask.resume()
                        self.progressDownloadIndicator.isHidden = false
                        
                        
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
    
    
    func urlSession(_ session: URLSession,downloadTask: URLSessionDownloadTask,didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64)
    {
        
        progressDownloadIndicator.setProgress(Float(totalBytesWritten)/Float(totalBytesExpectedToWrite), animated: true)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if(error != nil)
        {
            
        }
        else
        {
            
            
        }
        
        
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL)
    {
        if self.downloadTask != nil {
            
            progressDownloadIndicator.isHidden = true
            progressDownloadIndicator.setProgress(0.0, animated: true)
            let alert =   webservices.sharedInstance.AlertBuilder(title:"", message: "Download successfully")
            
            self.present(alert, animated: true, completion: nil)
            
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressDownloadIndicator.layer.cornerRadius = 8
        progressDownloadIndicator.clipsToBounds = true
        progressDownloadIndicator.transform = progressDownloadIndicator.transform.scaledBy(x: 1, y: 5)
        
        let backgroundSessionConfiguration = URLSessionConfiguration.background(withIdentifier: "backgroundSession")
        backgroundSession = URLSession(configuration: backgroundSessionConfiguration,delegate: self, delegateQueue: OperationQueue.main)
        progressDownloadIndicator.setProgress(0.0, animated: false)
        showAnimate()
        
        
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        if(ringtonelist.count != 0)
        {
            //    pagerview.scrollToItem(at: index1, animated: true)
            
            if ringtonelist[index1].downloadCount != nil
            {
                lblnum.text = " " + ringtonelist[index1].downloadCount!
            }
            else{
                
                lblnum.text = " 0"
                
            }
            lblname.text = "Name :" + ringtonelist[index1].name + " \n" +  "categoryName :" + ringtonelist[index1].categoryName
            navigationController?.navigationBar.isHidden = true
        }
        if(allringtone.count != 0)
        {
            //   pagerview.scrollToItem(at: index1, animated: true)
            
            if allringtone[index1].downloadCount != nil
            {
                lblnum.text = " " + allringtone[index1].downloadCount!
            }
            else{
                
                lblnum.text = " 0"
                
            }
            lblname.text = "Name :" + allringtone[index1].name + " \n" +  "categoryName :" + allringtone[index1].categoryName
            navigationController?.navigationBar.isHidden = true
            
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
    }
    
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        
        
        if(ringtonelist.count != 0)
        {
            return ringtonelist.count
        }
        else
        {
            return allringtone.count
        }
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        
        if(ringtonelist.count != 0)
        {
            //  pagerview.scrollToItem(at: index1, animated: true)
            let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
            let dic = ringtonelist[index]
            
            let url = "http://innoviussoftware.com/walltones/storage/app/" + dic.icon
            var newurl = NSURL(string: url)
            
            cell.imageView?.sd_setImage(with: newurl as! URL, placeholderImage:#imageLiteral(resourceName: "default-song"))
            cell.imageView?.contentMode = .scaleAspectFill
            cell.imageView?.clipsToBounds = true
            return cell
            
        }
        else
        {
            //    pagerview.scrollToItem(at: index1, animated: true)
            let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
            let dic = allringtone[index]
            
            let url = "http://innoviussoftware.com/walltones/storage/app/" + dic.icon
            var newurl = NSURL(string: url)
            
            cell.imageView?.sd_setImage(with: newurl as! URL, placeholderImage: #imageLiteral(resourceName: "default-song"))
            cell.imageView?.contentMode = .scaleAspectFill
            cell.imageView?.clipsToBounds = true
            return cell
            
        }
    }
    
    // MARK:- FSPagerView Delegate
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        
        print(targetIndex)
        index1 = targetIndex
        
        btnplay.setBackgroundImage(#imageLiteral(resourceName: "unnamed"), for: .normal)
        isplaying = 0
        
        self.playerViewController.player?.pause()
        if(ringtonelist.count != 0)
        {
            if(targetIndex >= 0)
            {
                lblname.text = "Name :" + ringtonelist[targetIndex].name + " \n" +  "categoryName :" + ringtonelist[targetIndex].categoryName
                if ringtonelist[targetIndex].downloadCount != nil
                {
                    lblnum.text = " " + ringtonelist[targetIndex].downloadCount!
                }
                
            }
        }
        else{
            if(targetIndex >= 0)
            {
                lblname.text = "Name :" + allringtone[targetIndex].name + " \n" +  "categoryName :" + allringtone[targetIndex].categoryName
                if allringtone[targetIndex].downloadCount != nil
                {
                    lblnum.text = " " + allringtone[targetIndex].downloadCount!
                }
            }
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
    
    
    
    // MARK: - User Define Functions
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
