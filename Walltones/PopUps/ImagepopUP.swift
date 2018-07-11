//
//  ImagepopUP.swift
//  Walltones
//
//  Created by Ravi Dubey on 7/9/18.
//  Copyright © 2018 Ravi Dubey. All rights reserved.
//

import UIKit
import SDWebImage
class ImagepopUP: UIViewController {

    @IBOutlet weak var imgview: UIImageView!
    
    var url = NSURL()
    
    var isformfavourite = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true

        imgview.isUserInteractionEnabled = true
        imgview?.sd_setImage(with: url as! URL, placeholderImage: UIImage(named: "default-user"))
        
        let T1 = UITapGestureRecognizer()
        
        T1.addTarget(self, action: #selector(showpass1))
        imgview.addGestureRecognizer(T1)
        // Do any additional setup after loading the view.
    }

 @objc  func showpass1()
   {
    
    removeAnimate()
    }
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                if(self.isformfavourite == 1)
                {
                    self.view.removeFromSuperview()

                   self.navigationController?.navigationBar.isHidden = false
                }
                else{
                self.view.removeFromSuperview()
                }
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
