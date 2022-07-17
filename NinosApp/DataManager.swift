//
//  DataManager.swift
//  NinosApp
//
//  Created by Erendira Cruz Reyes on 15/07/22.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
class DataManager: NSObject {
    
    static let instance = DataManager()
    
    override private init() {
        super.init()
        getInfo()
    }
    var info : [Mascota] = []
    var datas = [String:Any]()
    let db = Firestore.firestore()
    public func getInfo(){
        db.collection("users").document("\(Auth.auth().currentUser!.uid)").collection("mascotas").addSnapshotListener({ querySnapshot, err in
            self.info.removeAll()
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {

                        for document in querySnapshot!.documents {
                            print("\(document.documentID) => \(document.data())")
                            self.datas = document.data()
                            let tmp = Mascota(idMascota: self.datas["idMascota"]  as! String, idDuenio: self.datas["idDuenio"] as! String, nombre: self.datas["nombre"] as! String, nacimiento: self.datas["nacimiento"] as! String, sexo: self.datas["sexo"] as! Bool, raza: self.datas["raza"] as! String, esterilizado: self.datas["esterilizado"] as! Bool, talla: self.datas["talla"] as! String, extraviado: self.datas["extraviado"] as! Bool, foto: self.datas["foto"] as! String)
                            self.info.append(tmp)

                        }
                        let viewController = ViewController()
                        viewController.tablaManada?.reloadData()
                        

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
