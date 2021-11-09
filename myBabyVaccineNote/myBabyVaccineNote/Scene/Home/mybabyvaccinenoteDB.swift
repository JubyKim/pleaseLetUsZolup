//
//  mybabyvaccinenoteDB.swift
//  myBabyVaccineNote
//
//  Created by JUEUN KIM on 2021/11/09.
//

import Foundation

struct vaccineAndHospital{
    var id: Double
    var HOSPITAL_NAME: String?
    var DISEASE: String?
    var VACCINE: String?
    var PRICE: Double?
    var LOCATION: String?
    var LATITUDE: Double?
    var LONGITUDE: Double?
    var SIDE_EFFECT: String?
    
    init(id: Double, HOSPITAL_NAME: String?, DISEASE: String?, VACCINE: String?, PRICE: Double?, LOCATION: String?, LATITUDE: Double?, LONGITUDE: Double?, SIDE_EFFECT: String?){
        self.id = id
        self.HOSPITAL_NAME = HOSPITAL_NAME
        self.DISEASE = DISEASE
        self.VACCINE = VACCINE
        self.PRICE = PRICE
        self.LOCATION = LOCATION
        self.LATITUDE = LATITUDE
        self.LONGITUDE = LONGITUDE
        self.SIDE_EFFECT = SIDE_EFFECT
    }
}
