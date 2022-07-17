//
//  PerdidosViewController.swift
//  NinosApp
//
//  Created by Erendira Cruz Reyes on 13/07/22.
//

import UIKit
import FirebaseAuth
import Network
import WebKit

class PerdidosViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {

    var appDelegate:AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    @IBOutlet weak var perdidosTableView: UITableView!
    
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

    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
        perdidosTableView.separatorStyle = .none
        perdidosTableView.showsVerticalScrollIndicator = false
        

        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        perdidosTableView.delegate = self
        perdidosTableView.dataSource = self

    }
    override func viewDidAppear(_ animated: Bool) {
        if appDelegate.internetStatus{
            if Auth.auth().currentUser != nil{
                btnUsuario.setTitle("Salir", for: .normal)
            }else{
                btnUsuario.setTitle("Iniciar sesion", for: .normal)
            }

            
        }else{
            let alert = UIAlertController(title: "No hay internet", message: "Se requiere conexión a internet", preferredStyle: .alert)
            let boton = UIAlertAction(title: "ok", style: .default)
            alert.addAction(boton)
                self.present(alert,animated: true)
        }
        perdidosTableView.reloadData()
    }

   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detallePerdido"{
        let vc = segue.destination as! DetallePerdidoViewController
        // Pass the selected object to the new view controller.
        let item = DataPerdidos.instance.info[perdidosTableView.indexPathForSelectedRow!.row]
            vc.item = item
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataPerdidos.instance.info.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = perdidosTableView.dequeueReusableCell(withIdentifier: "PerdidoTableViewCell", for: indexPath) as! PerdidoTableViewCell
        let tmp: Perdidos = DataPerdidos.instance.info[indexPath.row]
        cell.nombePerdido.text =  tmp.nombre
        cell.lugarExtravio.text = tmp.lugarExtravio
        cell.fechaExtravio.text = tmp.fechaExtravio
        let url = URL(string: tmp.foto)!
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else{
                return
            }
            DispatchQueue.main.async {
            let imagen = UIImage(data: data)
                cell.imagenMascotaPerdida.image = imagen
                
            }
        }
        task.resume()
        return cell
    }


}
