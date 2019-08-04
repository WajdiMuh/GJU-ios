//
//  specialtransfootercode.swift
//  GJU
//
//  Created by wajdi muhtadi on 8/3/19.
//  Copyright © 2019 wajdi muhtadi. All rights reserved.
//

import UIKit

class specialtransfootercode: UICollectionReusableView {
    @IBOutlet weak var chours: UILabel!
    @IBOutlet weak var shadow: UIView!
    func setupshadow(){
        shadow.layer.shadowColor = UIColor.black.cgColor
        shadow.layer.shadowOpacity = 1.0
        shadow.layer.shadowOffset = CGSize.zero
        shadow.layer.shadowRadius = 6
        shadow.layer.masksToBounds = false
    }
}
