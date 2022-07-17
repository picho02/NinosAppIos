//
//  ViewController.swift
//  NinosApp
//
//  Created by Erendira Cruz Reyes on 24/05/22.
//

import UIKit
import FirebaseAuth
import Network
import WebKit
import FirebaseStorage
import FirebaseFirestore
import SwiftUI

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    var rowExtravio = 0
    let db = Firestore.firestore()
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let mascotaActual = DataManager.instance.info[indexPath.row]
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { _, indexPath in
            //poner codigo para eliminar de db
            self.tablaManada.deleteRows(at: [indexPath], with: .automatic)
        }
        let tituloExtravio = mascotaActual.extraviado ? "Volvio a casa" : "Reportar extravio"
        let reportarExtravio = UITableViewRowAction(style: .normal, title: tituloExtravio) { _, indexPath in
            //piner codigo a hacer
            if !mascotaActual.extraviado{
                self.rowExtravio = indexPath.row
                self.performSegue(withIdentifier: "reportarPerdido", sender: nil)
                
            }else{
                let alert = UIAlertController(title: "Volvio a casa", message: "Quitar reporte", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: nil))
                let btnNo = UIAlertAction(title: "si", style: .destructive){
                    action in
                    let tmp = DataPerdidos.instance.info[self.rowExtravio]
                    self.db.collection("perdidos").document(tmp.idMascota).delete()
                    self.db.collection("users").document(tmp.idDuenio).collection("mascotas").document(tmp.idMascota).setData([
                        "idMascota" : tmp.idMascota,
                        "idDuenio" : tmp.idDuenio,
                        "nombre" : tmp.nombre,
                        "nacimiento" : tmp.nacimiento,
                        "sexo" : tmp.sexo,
                        "raza" : tmp.raza,
                        "esterilizado" : tmp.esterilizado,
                        "talla" : tmp.talla,
                        "extraviado" : false,
                        "foto" : tmp.foto
                    ])

                }
                alert.addAction(btnNo)
                self.present(alert, animated: true, completion: nil)
                
            }
        }
        reportarExtravio.backgroundColor = .blue
        return[reportarExtravio, deleteAction]
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return DataManager.instance.info.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tablaManada.dequeueReusableCell(withIdentifier: "manadaCell", for: indexPath) as! ManadaTableViewCell
        let tmp: Mascota = DataManager.instance.info[indexPath.row]
        cell.nombreMascota.text =  tmp.nombre
        cell.edadMascota.text = tmp.nacimiento
        let url = URL(string: tmp.foto)!
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else{
                return
            }
            DispatchQueue.main.async {
            let imagen = UIImage(data: data)
                cell.imagenManada.image = imagen
                
            }
        }
        task.resume()
        cell.imagenManada.layer.cornerRadius = cell.imagenManada.frame.height/2
        return cell
    }
    
    var internetStatus = false
    var internetType = ""
    let image = LoaderView()
 
    var idMascotas = [String]()

    @IBOutlet weak var tablaManada: UITableView!
    @IBOutlet weak var btnUsuario: UIButton!
    @IBAction func btnLogIn(_ sender: Any) {
        if Auth.auth().currentUser != nil{
            let alert = UIAlertController(title: "", message: "Desea salir de la app", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: nil))
            let btnNo = UIAlertAction(title: "si", style: .destructive){
                action in
                do{
                try Auth.auth().signOut()
                    self.btnUsuario.setTitle("Iniciar sesion", for: .normal)
                }catch{
                    
                }
            }
            alert.addAction(btnNo)
            self.present(alert, animated: true, completion: nil)
            
            
        }else{
            btnUsuario.setTitle("Iniciar sesion", for: .normal)
            self.performSegue(withIdentifier: "logIn", sender: nil)
        }
        
        //
    }
    @IBAction func addMascota(_ sender: Any) {
        if Auth.auth().currentUser != nil{
            self.performSegue(withIdentifier: "agregarMascota", sender: nil)

        }else{
            self.performSegue(withIdentifier: "logIn", sender: nil)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataManager.instance.info.count
        
        
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = {
            path in
            if path.status != .satisfied{
                self.internetStatus = false
            }else{
                self.internetStatus = true
                if path.usesInterfaceType(.wifi){
                    self.internetType = "wifi"
                }
                else if path.usesInterfaceType(.cellular){
                    self.internetType = "Cellular"
                }
            }
        } // Espera un closure?(funcion anonima) se ejecuta de manera asincrona
        monitor.start(queue: DispatchQueue.global())
        if let unView = self.view.viewWithTag(666) {
                    unView.removeFromSuperview()
                }



        /**/
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {

        if Auth.auth().currentUser != nil{
            btnUsuario.setTitle("Salir", for: .normal)
        }else{
            btnUsuario.setTitle("Iniciar sesion", for: .normal)
        }
        

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        if DataManager.instance.info.count == 0{
        image.frame.size = CGSize(width: 400, height: 400)
        image.center = self.view.center
        image.tag = 666
        self.view.addSubview(image)}
        if DataManager.instance.info.count != 0{
            image.removeFromSuperview()
        }
        tablaManada.separatorStyle = .none
        tablaManada.showsVerticalScrollIndicator = false
        self.tablaManada.dataSource = self
        self.tablaManada.delegate = self
        self.tablaManada.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        if segue.identifier == "detalleMascota" {
        let vc = segue.destination as! DetalleMascotaViewController
        // Pass the selected object to the new view controller.
        let item = DataManager.instance.info[tablaManada.indexPathForSelectedRow!.row]
            vc.item = item
        }else if segue.identifier == "reportarPerdido"{
            let vc = segue.destination as! ReportarExtravioViewController
            let item = DataManager.instance.info[rowExtravio]
                vc.item = item
        }
    }

    
}

