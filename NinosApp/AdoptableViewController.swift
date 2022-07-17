//
//  AdoptableViewController.swift
//  NinosApp
//
//  Created by Erendira Cruz Reyes on 13/07/22.
//

import UIKit
import FirebaseAuth
import Network
import WebKit

class AdoptableViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout/*, UICollectionViewDelegate */{
    var appDelegate:AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    var adoptableRow = 0
    @IBOutlet weak var adoptableCollectionView: UICollectionView!

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
        adoptableCollectionView.dataSource = self
        adoptableCollectionView.delegate = self
        adoptableCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
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
        adoptableCollectionView.reloadData()
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detalleAdoptable"{
        let vc = segue.destination as! DetalleAdoptableViewController
        // Pass the selected object to the new view controller.
            let item = DataAdoptable.instance.info[adoptableRow]
            vc.item = item
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataAdoptable.instance.info.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdoptableCollectionViewCell", for: indexPath) as! AdoptableCollectionViewCell
        adoptableRow = indexPath.row
        let tmp = DataAdoptable.instance.info[adoptableRow]
        cell.setup(index: indexPath.row)
        cell.duenioMascotaAdoptable.text = tmp.idDuenio
        cell.nombreMascotaAdoptable.text = tmp.nombre
        let url = URL(string: tmp.foto)!
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else{
                return
            }
            DispatchQueue.main.async {
            let imagen = UIImage(data: data)
                cell.imagenMascotaAdoptable.image = imagen
                
            }
        }
        task.resume()
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 180)
    }


}
