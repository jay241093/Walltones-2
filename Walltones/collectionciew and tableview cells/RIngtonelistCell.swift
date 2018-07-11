//
//  RIngtonelistCell.swift
//  Walltones
//
//  Created by Ravi Dubey on 7/5/18.
//  Copyright © 2018 Ravi Dubey. All rights reserved.
//

import UIKit

class RIngtonelistCell: UITableViewCell {

    @IBOutlet weak var btnplay: UIButton!
    
    @IBOutlet weak var lblname: UILabel!
    
    @IBOutlet weak var lbldes: UILabel!
    
    @IBOutlet weak var btnlike: UIButton!
    
    @IBOutlet weak var view: UIView!
    var isliked = 0
    @IBAction func btnlikeaction(_ sender: Any) {
        if(isliked == 0)
        {
            isliked = 1
            btnlike.setImage(#imageLiteral(resourceName: "heart-solid"), for: .normal)
        }
        else
        {
            btnlike.setImage(#imageLiteral(resourceName: "heart-regular"), for: .normal)
            isliked = 0
        }
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
