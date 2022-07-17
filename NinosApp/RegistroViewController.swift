//
//  RegistroViewController.swift
//  NinosApp
//
//  Created by Erendira Cruz Reyes on 12/07/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegistroViewController: UIViewController {
    @IBOutlet weak var nombre: UITextField!
    @IBOutlet weak var apellidoPaterno: UITextField!
    @IBOutlet weak var apellidoMaterno: UITextField!
    @IBOutlet weak var eMail: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBAction func btnAceptar(_ sender: Any) {
        Auth.auth().createUser(withEmail: eMail.text!, password: password.text!) { auth, error in
            if error != nil{
                print("ocurrio un error \(error!.localizedDescription)")
            }else{

                let db = Firestore.firestore()
                let idUsuario = Auth.auth().currentUser!.uid
                db.collection("users").document("\(idUsuario)").setData([
                    "id": Auth.auth().currentUser?.uid as Any,
                    "nombre": self.nombre.text!,
                    "apellidoPaterno": self.apellidoPaterno.text!,
                    "apellidoMaterno": self.apellidoMaterno.text ?? ""], completion: {  err in
                        if let err = err {
                            print("Error adding document: \(err)")
                        } else {
                            self.navigationController?.popToRootViewController(animated: true)
                        }

                    })
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
