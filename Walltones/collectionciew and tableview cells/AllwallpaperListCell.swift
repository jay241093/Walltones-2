//
//  AllwallpaperListCell.swift
//  Walltones
//
//  Created by Ravi Dubey on 7/5/18.
//  Copyright © 2018 Ravi Dubey. All rights reserved.
//

import UIKit

class AllwallpaperListCell: UITableViewCell {

    @IBOutlet weak var view: UIView!
    
    @IBOutlet weak var imgview: UIImageView!
    
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var lbldes: UILabel!
    
    @IBOutlet weak var lbldowncount: UILabel!
    @IBOutlet weak var imgfav: UIImageView!
    
    @IBOutlet weak var lblkeyword: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
