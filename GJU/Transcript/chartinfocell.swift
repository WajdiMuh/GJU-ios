//
//  chartinfocell.swift
//  GJU
//
//  Created by wajdi muhtadi on 8/10/19.
//  Copyright © 2019 wajdi muhtadi. All rights reserved.
//

import UIKit

class chartinfocell: UICollectionViewCell {
    @IBOutlet weak var count: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var circle: UIView!
    func blue(){
        background.backgroundColor = UIColor.init(red: 16.0/255.0, green: 134.0/255.0, blue: 204.0/255.0, alpha: 1.0)
        circle.backgroundColor = UIColor.init(red: 0.0, green: 98.0/255.0, blue: 147.0/255.0, alpha: 1.0)
    }
    func orange(){
        background.backgroundColor = UIColor.init(red: 234.0/255.0, green: 128.0/255.0, blue: 19.0/255.0, alpha: 1.0)
        circle.backgroundColor = UIColor.init(red: 214.0/255.0, green: 97.0/255.0, blue: 0.0, alpha: 1.0)
    }
}
