//
//  Mascotas.swift
//  NinosApp
//
//  Created by Edgar Cruz Reyes on 27/05/22.
//

import Foundation
import CoreData

@objc(Mascotas)
public class Mascotas: NSManagedObject{
    func inicializaCon(_ dict: [String:Any]){
        let id = dict["id"] ?? 0
        let name = dict["name"] ?? ""
        let age = dict["age"] ?? 0
        let gender = dict["gender"] ?? ""
        let brench = dict["brench"] ?? ""
        let esteril = dict["esteril"] ?? ""
        let owner = dict["owner"] ?? ""
        let talla = dict["talla"] ?? ""
        self.id = id
    }
}
