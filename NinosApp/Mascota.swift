//
//  Mascota.swift
//  NinosApp
//
//  Created by Edgar Cruz Reyes on 27/05/22.
//

import Foundation

public struct Mascota{
    var idMascota: String
    var idDuenio: String
    var nombre: String
    var nacimiento: String
    var sexo: Bool
    var raza: String
    var esterilizado: Bool
    var talla: String
    var extraviado: Bool
    var foto: String
    init(idMascota:String, idDuenio: String, nombre: String,nacimiento: String, sexo: Bool, raza: String, esterilizado: Bool, talla: String, extraviado: Bool, foto : String){
        self.idMascota = idMascota
        self.idDuenio = idDuenio
        self.nombre = nombre
        self.nacimiento = nacimiento
        self.sexo = sexo
        self.raza = raza
        self.esterilizado = esterilizado
        self.talla = talla
        self.extraviado = extraviado
        self.foto = foto
    }
    
}
