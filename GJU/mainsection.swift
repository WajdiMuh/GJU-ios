//
//  mainsection.swift
//  GJU
//
//  Created by wajdi muhtadi on 7/7/19.
//  Copyright © 2019 wajdi muhtadi. All rights reserved.
//

import UIKit
protocol headercv: class {
    func didexpand(sec:Int)
}
class mainsection: UICollectionReusableView {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var arrow: UIImageView!
    weak var delegate:headercv?
    @IBAction func headerclick(_ sender: Any) {
        delegate?.didexpand( sec: title.tag)
    }
}
