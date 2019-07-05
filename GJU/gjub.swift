//
//  gjub.swift
//  GJU
//
//  Created by wajdi muhtadi on 7/5/19.
//  Copyright © 2019 wajdi muhtadi. All rights reserved.
//

import UIKit

class gjub: SimpleButton {
    override func configureButtonStyles() {
        super.configureButtonStyles()
        setBackgroundColor(UIColor(red: 247/255, green: 169/255, blue: 2/255, alpha: 1.0), for: .normal)
        setBackgroundColor(UIColor(red: 202/255, green: 139/255, blue: 2/255, alpha: 1.0), for: .highlighted)
        setCornerRadius(self.frame.width/12)
        setScale(0.98, for: .highlighted)
        setShadowOpacity(0.8)
        setShadowColor(UIColor.black)
        setShadowOffset(CGSize(width: 0.0, height: 0.0))
        setShadowRadius(8.0)
        setTitleColor(UIColor.white, for: .normal)
    }
}
