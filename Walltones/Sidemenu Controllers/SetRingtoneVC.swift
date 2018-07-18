
//
//  SetRingtoneVC.swift
//  Walltones
//
//  Created by Ravi Dubey on 7/16/18.
//  Copyright © 2018 Ravi Dubey. All rights reserved.
//

import UIKit
import FSPagerView
class SetRingtoneVC: UIViewController ,FSPagerViewDelegate , FSPagerViewDataSource{

    
    @IBOutlet weak var pagerview: FSPagerView!{
    didSet {
    self.pagerview.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
    self.pagerview.itemSize = .zero
     }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        
     return 7
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        
      
            //  pagerview.scrollToItem(at: index1, animated: true)
            let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        var imgary = ["IMG_0451","IMG_0452","IMG_0453","IMG_0454","IMG_0455","IMG_0456","IMG_0457"]
            cell.imageView?.image = UIImage(named: imgary[index] as! String)
            return cell
            
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
