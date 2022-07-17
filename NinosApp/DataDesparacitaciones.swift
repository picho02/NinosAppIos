//
//  DataDesparacitaciones.swift
//  NinosApp
//
//  Created by Erendira Cruz Reyes on 16/07/22.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

struct Desparacitaciones{
    var idDesparacitacion : String
    var tipo : String
    var fechaAplicacion: String
    var fechaRefuerzo: String
    init(idDesparacitacion : String, tipo: String, fechaAplicacion: String, fechaRefuerzo: String){
        self.idDesparacitacion = idDesparacitacion
        self.tipo = tipo
        self.fechaAplicacion = fechaAplicacion
        self.fechaRefuerzo = fechaRefuerzo
    }
}
class DataDesparacitaciones: NSObject {
    
    static let instance = DataDesparacitaciones()
    
    override private init() {
        super.init()
        //getInfo()
    }
    var info : [Desparacitaciones] = []
    var datas = [String:Any]()
    let db = Firestore.firestore()
    public func getInfo(idMascota: String){
        db.collection("users").document("\(Auth.auth().currentUser!.uid)").collection("mascotas").document(idMascota).collection("desparacitaciones").addSnapshotListener({ querySnapshot, err in
            self.info.removeAll()
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {

                        for document in querySnapshot!.documents {
                            print("\(document.documentID) => \(document.data())")
                            self.datas = document.data()
                            let tmp = Desparacitaciones(idDesparacitacion: self.datas["idDesparacitacion"] as! String, tipo: self.datas["tipo"] as! String, fechaAplicacion: self.datas["fechaAplicacion"] as! String, fechaRefuerzo: self.datas["fechaRefuerzo"] as! String)
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
