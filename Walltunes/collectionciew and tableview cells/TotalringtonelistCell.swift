//
//  TotalringtonelistCell.swift
//  Walltones
//
//  Created by Ravi Dubey on 7/6/18.
//  Copyright © 2018 Ravi Dubey. All rights reserved.
//

import UIKit

class TotalringtonelistCell: UITableViewCell {
    @IBOutlet weak var btnplay: UIButton!
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var lbldes: UILabel!
    @IBOutlet weak var btnlike: UIButton!
    @IBOutlet weak var view: RoundCornerProgressView!
    
    
   var isliked = 0
    @IBAction func btnlikeaction(_ sender: Any) {
        
      
        
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
