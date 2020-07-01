//
//  section.swift
//  GJU
//
//  Created by wajdi muhtadi on 7/1/20.
//  Copyright © 2020 wajdi muhtadi. All rights reserved.
//

import Foundation
class Section{
    var courses:[Course] = []
    var name:String? = nil
    var sectiontotalcredithours:String?
    var sectionrequiredcredithours:String?
    var sectionpassedcredithours:String?
    init(name:String, sectiontotalcredithours:String? , sectionrequiredcredithours:String? , sectionpassedcredithours:String? ) {
        self.name = name
        self.sectiontotalcredithours = sectiontotalcredithours
        self.sectionrequiredcredithours = sectionrequiredcredithours
        self.sectionpassedcredithours = sectionpassedcredithours
    }
}
