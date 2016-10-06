//
//  TransportationTableViewCell.swift
//  ETrip
//
//  Created by Erin Shih on 2016/10/6.
//  Copyright © 2016年 Erin Shih. All rights reserved.
//

import UIKit

// let infoView = NSBundle.mainBundle().loadNibNamed("TransportationTableViewCell", owner: UITableViewCell.self, options: nil).first as! TransportationTableViewCell

class TransportationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var typeTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
       
        //        let infoView = NSBundle.mainBundle().loadNibNamed("CustomInfoView", owner: self, options: nil).first as! CustomInfoView
        
//        infoView.frame =  self.frame
        
//        infoView.mainTitle.text = "123"
//        infoView.viewMap.addTarget(self, action: #selector(MyTableViewCell.viewMap(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
//        contentView.addSubview(infoView)
        
        
    }
    
}
