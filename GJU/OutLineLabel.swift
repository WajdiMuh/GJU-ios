//
//  OutLineLabel.swift
//  OutLineLabel
//
//  Created by Lurf on 2018/12/08.
//  Copyright © 2018 Lurf. All rights reserved.
//

import UIKit

class OutLineLabel: UILabel {
    
    var outlineColor: UIColor = .white
    var outlineSize: CGFloat = 5.0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func drawText(in rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        let inlineColor = textColor
        
        context.setLineWidth(outlineSize)
        context.setLineJoin(.round)
        context.setTextDrawingMode(.stroke)
        textColor = outlineColor
        
        super.drawText(in: rect)
        
        context.setTextDrawingMode(.fill)
        textColor = inlineColor
        
        super.drawText(in: rect)
    }
}
