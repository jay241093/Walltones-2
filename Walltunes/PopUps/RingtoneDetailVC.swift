
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

protocol Ringdetail
{
    func closeaction()
    
}

class RingtoneDetailVC: UIViewController , FSPagerViewDelegate , FSPagerViewDataSource , URLSessionDownloadDelegate{
    @IBOutlet weak var lblname: UILabel!
    
    @IBOutlet weak var lblnum: UILabel!
    @IBOutlet weak var btnlike: UIButton!
    var delegate: Ringdetail?
    var  ringid : String?
    var catid : Int = 0
    @IBOutlet weak var btnplay: UIButton!
    var downloadTask: URLSessionDownloadTask!
    var backgroundSession: URLSession!
    var index1 = 0
    var isplaying = 0
    var ringtonelist = [Ringlist]()
    var allringtone = [allringlist]()
    var playerViewController = AVPlayerViewController()
    var isfromcategory = 0
    var favidary = NSMutableArray()

    @IBOutlet weak var progressDownloadIndicator: UIProgressView!
    
    // MARK: - IBAction Mehtods
    
    @IBAction func closeaction(_ sender: Any) {
        removeAnimate()
        self.playerViewController.player?.pause()
        delegate?.closeaction()
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification){
        isplaying = 0
        
        self.btnplay.setBackgroundImage(#imageLiteral(resourceName: "unnamed"), for: .normal)

        
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
                    
                    
                    
                    btnplay.setBackgroundImage(#imageLiteral(resourceName: "unnamed"), for: .normal)
                    
                    self.playerViewController.player?.pause()
                }
                
            }
            
        }
        
    }
    @IBAction func likeaction(_ sender: UIButton) {
        print(favidary)
        if(ringtonelist.count > 0)
        {
        
     if(index1 >= 0)
     {
        if(favidary.contains(self.ringtonelist[self.index1].id))
        {
            var parameters : Parameters = [:]
            if(ringtonelist.count != 0)
            {
                parameters = ["ringtone_id":self.ringtonelist[self.index1].id ,"user_id":UserDefaults.standard.value(forKey:"userid") as! Int]
            }
            else
            {
                parameters = ["ringtone_id":self.allringtone[self.index1].id ,"user_id":UserDefaults.standard.value(forKey:"userid") as! Int]
                
            }
            
            StartSpinner()
            Alamofire.request(webservices().baseurl + "removefavoriteringtone", method: .post, parameters:parameters, encoding: JSONEncoding.default, headers:nil).responseJSON{ (response:DataResponse<Any>) in
                switch response.result{
                case .success(let resp):
                    print(resp)
                    self.GetFavRingtones()
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
        else
        {
        var parameters : Parameters = [:]
        if(ringtonelist.count != 0)
        {
            parameters = ["ringtone_id":self.ringtonelist[self.index1].id ,"user_id":UserDefaults.standard.value(forKey:"userid") as! Int]
        }
        else
        {
            parameters = ["ringtone_id":self.allringtone[self.index1].id ,"user_id":UserDefaults.standard.value(forKey:"userid") as! Int]
            
        }
        
        StartSpinner()
        Alamofire.request(webservices().baseurl + "favoriteringtone", method: .post, parameters:parameters, encoding: JSONEncoding.default, headers:nil).responseJSON{ (response:DataResponse<Any>) in
            switch response.result{
            case .success(let resp):
                print(resp)
                sender.setBackgroundImage(#imageLiteral(resourceName: "heart-solid"), for:.normal)

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
        }
        }
        else
        {
            if(index1 >= 0)
                {
                    if(favidary.contains(self.allringtone[self.index1].id))
                    {
                        var parameters : Parameters = [:]
                        if(allringtone.count != 0)
                        {
                            parameters = ["ringtone_id":self.allringtone[self.index1].id ,"user_id":UserDefaults.standard.value(forKey:"userid") as! Int]
                        }
                        else
                        {
                            parameters = ["ringtone_id":self.allringtone[self.index1].id ,"user_id":UserDefaults.standard.value(forKey:"userid") as! Int]
                            
                        }
                        
                        StartSpinner()
                        Alamofire.request(webservices().baseurl + "removefavoriteringtone", method: .post, parameters:parameters, encoding: JSONEncoding.default, headers:nil).responseJSON{ (response:DataResponse<Any>) in
                            switch response.result{
                            case .success(let resp):
                                print(resp)
                                self.GetFavRingtones()
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
                    else
                    {
                        var parameters : Parameters = [:]
                        if(ringtonelist.count != 0)
                        {
                            parameters = ["ringtone_id":self.allringtone[self.index1].id ,"user_id":UserDefaults.standard.value(forKey:"userid") as! Int]
                        }
                        else
                        {
                            parameters = ["ringtone_id":self.allringtone[self.index1].id ,"user_id":UserDefaults.standard.value(forKey:"userid") as! Int]
                            
                        }
                        
                        StartSpinner()
                        Alamofire.request(webservices().baseurl + "favoriteringtone", method: .post, parameters:parameters, encoding: JSONEncoding.default, headers:nil).responseJSON{ (response:DataResponse<Any>) in
                            switch response.result{
                            case .success(let resp):
                                print(resp)
                                sender.setBackgroundImage(#imageLiteral(resourceName: "heart-solid"), for:.normal)
                                
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
            let dic =  self.ringtonelist[self.index1].file
            
            let url = "http://innoviussoftware.com/walltones/storage/app/" + dic
            
            
            var shareText = "URL :\(url)"
            let vc = UIActivityViewController(activityItems: [shareText], applicationActivities: [])
            present(vc, animated: true)
            
        }
        else
        {
            let dic =  self.allringtone[self.index1].file
            
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
                        self.ringid = self.ringtonelist[self.index1].id
                        self.Getlist(id: self.catid)
                        let dic =  self.ringtonelist[self.index1].file
                        var imageview = UIImageView()
                        
                        
                        let url1 = "http://innoviussoftware.com/walltones/storage/app/" + dic
                        let url = URL(string: url1)!
                     
                        StopSpinner()
                        
                        if let audioUrl =  NSURL(string: url1) {
                            
                            // then lets create your document folder url
                            let documentsDirectoryURL =  FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
                            
                            // lets create your destination file url
                            let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent ?? "audio.mp3")
                            
                            print(destinationUrl)
                            
                            // to check if it exists before downloading it
                            if FileManager().fileExists(atPath: destinationUrl.path) {
                                print("The file already exists at path")
                                let alert =  webservices.sharedInstance.AlertBuilder(title:"", message: "The file already exists at path")
                                self.present(alert, animated: true, completion: nil)

                                // if the file doesn't exist
                            } else {
                                self.downloadTask = self.backgroundSession.downloadTask(with: url)
                                self.downloadTask.resume()
                                
                                // you can use NSURLSession.sharedSession to download the data asynchronously
                                URLSession.shared.downloadTask(with: audioUrl as URL, completionHandler: { (location, response, error) -> Void in
                                    guard let location = location, error == nil else { return }
                                    do {
                                        // after downloading your file you need to move it to your destination url
                                        try FileManager().moveItem(at: location, to: destinationUrl)
                                        print("File moved to documents folder")
                                    } catch let error as NSError {
                                        print(error.localizedDescription)
                                    }
                                }).resume()
                            }
                        
                        
                        }
                        
                        
                        
                       // self.progressDownloadIndicator.isHidden = false
                    case .failure(let err):
                        print(err)
                        print("Failed to change ")
                        let alert = webservices.sharedInstance.AlertBuilder(title:  "OOps", message: "Unable to download \n Try Again")
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
                        self.ringid = self.allringtone[self.index1].id
                        self.getallringtonelist()
                        let dic =  self.allringtone[self.index1].file
                        var imageview = UIImageView()
                        let url1 = "http://innoviussoftware.com/walltones/storage/app/" + dic
                        
                        let url = URL(string: url1)!
                      
                       // self.progressDownloadIndicator.isHidden = false
                        if let audioUrl =  NSURL(string: url1) {
                            
                            // then lets create your document folder url
                            let documentsDirectoryURL =  FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
                            
                            // lets create your destination file url
                            let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent ?? "audio.mp3")
                            print(destinationUrl)
                            
                            // to check if it exists before downloading it
                            if FileManager().fileExists(atPath: destinationUrl.path) {
                                print("The file already exists at path")
                              let alert =  webservices.sharedInstance.AlertBuilder(title:"", message: "The file already exists at path")
                                self.present(alert, animated: true, completion: nil)
                                // if the file doesn't exist
                            } else {
                                self.downloadTask = self.backgroundSession.downloadTask(with: url)
                                self.downloadTask.resume()
                                // you can use NSURLSession.sharedSession to download the data asynchronously
                                URLSession.shared.downloadTask(with: audioUrl as URL, completionHandler: { (location, response, error) -> Void in
                                    guard let location = location, error == nil else { return }
                                    do {
                                        // after downloading your file you need to move it to your destination url
                                        try FileManager().moveItem(at: location, to: destinationUrl)
                                        print("File moved to documents folder")
                                    } catch let error as NSError {
                                        print(error.localizedDescription)
                                    }
                                }).resume()
                            }
                            
                            
                        }
                        
                        StopSpinner()
                    case .failure(let err):
                        print(err)
                        print("Failed to change ")
                        let alert = webservices.sharedInstance.AlertBuilder(title:  "OOps", message: "Unable to download \n Try Again")
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
        
     //   progressDownloadIndicator.setProgress(Float(totalBytesWritten)/Float(totalBytesExpectedToWrite), animated: true)
        var str = String(Float(totalBytesWritten)/Float(totalBytesExpectedToWrite)*100)
        
        HUD.flash(.label(str + "% completed"), delay:100.0) { _ in
            print("License Obtained.")
        }
        
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
      
        if(error != nil)
        {
            
           // progressDownloadIndicator.isHidden = true
            
            StartLabeledSpinner(type: .error, title:"Failur", message:(error?.localizedDescription)!, hide:100.0)


        }
        
   
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL)
    {
        if self.downloadTask != nil {
            StartLabeledSpinner(type:.success, title:"Success", message:"Downloaded successfully", hide:4.0)

         }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         GetFavRingtones()
        pagerview.isInfinite = false

        progressDownloadIndicator.layer.cornerRadius = 8
        progressDownloadIndicator.clipsToBounds = true
        progressDownloadIndicator.transform = progressDownloadIndicator.transform.scaledBy(x: 1, y: 5)
        
        let backgroundSessionConfiguration = URLSessionConfiguration.background(withIdentifier: "backgroundSession")
        backgroundSession = URLSession(configuration: backgroundSessionConfiguration,delegate: self, delegateQueue: OperationQueue.main)
        progressDownloadIndicator.setProgress(0.0, animated: false)
        showAnimate()
        btnlike.tag = index1
        
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        if(ringtonelist.count != 0)
        {
            //    pagerview.scrollToItem(at: index1, animated: true)
            if(favidary.contains(ringtonelist[index1].id))
            {
                btnlike.setBackgroundImage(#imageLiteral(resourceName: "heart-solid"), for: .normal)
            }
            else
            {
                btnlike.setBackgroundImage(#imageLiteral(resourceName: "love"), for: .normal)
            }
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
            
            if(favidary.contains(allringtone[index1].id))
            {
                btnlike.setBackgroundImage(#imageLiteral(resourceName: "heart-solid"), for: .normal)
            }
            else
            {
                btnlike.setBackgroundImage(#imageLiteral(resourceName: "love"), for: .normal)
            }
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
            if(isfromcategory == 1)
            {
                isfromcategory = 0
                pagerview.scrollToItem(at: index1, animated: false)
            }
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
            if(isfromcategory == 1)
            {
                isfromcategory = 0
                pagerview.scrollToItem(at: index1, animated: false)
            }
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
                 btnlike.tag = targetIndex
                lblname.text = "Name : " + ringtonelist[targetIndex].name + " \n" +  "Category name : " + ringtonelist[targetIndex].categoryName
                if ringtonelist[targetIndex].downloadCount != nil
                {
                    lblnum.text = " " + ringtonelist[targetIndex].downloadCount!
                }
                
                if(favidary.contains( ringtonelist[targetIndex].id))
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
                
                 btnlike.tag = targetIndex
                lblname.text = "Name : " + allringtone[targetIndex].name + " \n" +  "Category name : " + allringtone[targetIndex].categoryName
                if allringtone[targetIndex].downloadCount != nil
                {
                    lblnum.text = " " + allringtone[targetIndex].downloadCount!
                }
                if(favidary.contains( allringtone[targetIndex].id))
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
                        self.favidary.removeAllObjects()
                        let data = resp.data
                        for dic in data
                        {
                           self.favidary.add(dic.id)
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
                        self.ringtonelist = resp.data
                        for data in resp.data{
                            
                            if(self.ringid == data.id)
                            {
                                self.lblnum.text = data.downloadCount
                            }
                            
                        }
                 
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
                        self.allringtone = resp.data
                        for data in resp.data{
                            
                            if(self.ringid == data.id)
                            {
                                self.lblnum.text = data.downloadCount
                            }
                            
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
