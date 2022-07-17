//
//  DataPerdidos.swift
//  NinosApp
//
//  Created by Erendira Cruz Reyes on 16/07/22.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

struct Perdidos{
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
    var detalles: String
    var fechaExtravio : String
    var lugarExtravio : String
    init (idMascota: String, idDuenio: String, nombre: String, nacimiento: String, sexo: Bool, raza: String, esterilizado: Bool, talla: String, extraviado: Bool, foto: String, detalles: String, fechaExtravio : String, lugarExtravio : String){
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
        self.detalles = detalles
        self.fechaExtravio = fechaExtravio
        self.lugarExtravio = lugarExtravio
    }

}
class DataPerdidos: NSObject {
    
    static let instance = DataPerdidos()
    
    override private init() {
        super.init()
        getInfo()
    }
    var info : [Perdidos] = []
    var datas = [String:Any]()
    let db = Firestore.firestore()
    public func getInfo(){
        db.collection("perdidos").addSnapshotListener({ querySnapshot, err in
            self.info.removeAll()
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {

                        for document in querySnapshot!.documents {
                            print("\(document.documentID) => \(document.data())")
                            self.datas = document.data()
                            let tmp = Perdidos(idMascota: self.datas["idMascota"]  as! String, idDuenio: self.datas["idDuenio"] as! String, nombre: self.datas["nombre"] as! String, nacimiento: self.datas["nacimiento"] as! String, sexo: self.datas["sexo"] as! Bool, raza: self.datas["raza"] as! String, esterilizado: self.datas["esterilizado"] as! Bool, talla: self.datas["talla"] as! String, extraviado: self.datas["extraviado"] as! Bool, foto: self.datas["foto"] as! String, detalles: self.datas["detalles"] as! String, fechaExtravio: self.datas["fechaExtravio"] as! String, lugarExtravio : self.datas["lugarExtravio"] as! String)
                            self.info.append(tmp)
                        }

                    }
                })
        /*}else{
            let alert = UIAlertController(title: "No hay internet", message: "Se requiere conexión a internet", preferredStyle: .alert)
            let boton = UIAlertAction(title: "ok", style: .default)
            alert.addAction(boton)
                self.present(alert,animated: true)
        }*/
    }
}
