//
//  Course.swift
//  GJU
//
//  Created by wajdi muhtadi on 7/1/20.
//  Copyright © 2020 wajdi muhtadi. All rights reserved.
//

import Foundation
class Course{
    var name:String
    var grade:String? = nil
    var remark:String? = nil
    var credithours:String? = nil
    var id:String? = nil
    var prerequisites:String? = nil
    var corequisites:String? = nil
    var theoreticalhours:String? = nil
    var practicalhours:String? = nil
    init(id: String, name:String, credithours:String, grade:String? = nil, remark:String? = nil, prerequisites:String? = nil, corequisites:String? = nil, theoreticalhours:String? = nil, practicalhours:String? = nil) {
        self.name = name
        self.grade = grade
        self.remark = remark
        self.credithours = credithours
        self.id = id
        self.prerequisites = prerequisites
        self.corequisites = corequisites
        self.theoreticalhours = theoreticalhours
        self.practicalhours = practicalhours
    }
}
