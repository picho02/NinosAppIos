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

    var internetStatus = false
    var internetType = ""

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
        }
        monitor.start(queue: DispatchQueue.global())
    }
    override func viewDidAppear(_ animated: Bool) {
        if internetStatus{
            if Auth.auth().currentUser != nil{
                btnUsuario.setTitle("Salir", for: .normal)
            }else{
                btnUsuario.setTitle("Iniciar sesion", for: .normal)
            }
            adoptableCollectionView.dataSource = self
            adoptableCollectionView.delegate = self
            adoptableCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        }else{
            let alert = UIAlertController(title: "No hay internet", message: "Se requiere conexión a internet", preferredStyle: .alert)
            let boton = UIAlertAction(title: "ok", style: .default)
            alert.addAction(boton)
                self.present(alert,animated: true)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdoptableCollectionViewCell", for: indexPath) as! AdoptableCollectionViewCell
        cell.setup(index: indexPath.row)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 190, height: 200)
    }
    /*func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Hola")
    }*/

}
