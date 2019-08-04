//
//  transcriptfooter.swift
//  GJU
//
//  Created by wajdi muhtadi on 8/2/19.
//  Copyright © 2019 wajdi muhtadi. All rights reserved.
//

import UIKit

class transcriptfooter: UICollectionReusableView {
    @IBOutlet weak var shadow: UIView!
    @IBOutlet weak var tph: UILabel!
    @IBOutlet weak var rhl: UILabel!
    @IBOutlet weak var phl: UILabel!
    @IBOutlet weak var al: UILabel!
    @IBOutlet weak var gpal: UILabel!
    @IBOutlet weak var rhr: UILabel!
    @IBOutlet weak var phr: UILabel!
    @IBOutlet weak var ar: UILabel!
    @IBOutlet weak var gpar: UILabel!
    func setupshadow(){
        shadow.layer.shadowColor = UIColor.black.cgColor
        shadow.layer.shadowOpacity = 1.0
        shadow.layer.shadowOffset = CGSize.zero
        shadow.layer.shadowRadius = 6
        shadow.layer.masksToBounds = false
    }
}
