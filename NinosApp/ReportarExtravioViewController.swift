//
//  ReportarExtravioViewController.swift
//  NinosApp
//
//  Created by Erendira Cruz Reyes on 16/07/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ReportarExtravioViewController: UIViewController {
    var item:Mascota?
    let db = Firestore.firestore()
    @IBOutlet weak var fechaExtravio: UITextField!
    @IBOutlet weak var lugarExtravio: UITextField!
    @IBOutlet weak var detalles: UITextView!
    @IBAction func reportarBtn(_ sender: Any) {
        if lugarExtravio.hasText{
        if detalles.hasText{
            if fechaExtravio.hasText{
                var idMascota = self.item!.idMascota
                var colleccion = db.collection("perdidos")
                colleccion.document(idMascota).setData([
                    "idMascota" : self.item!.idMascota ?? "",
                    "idDuenio" : self.item!.idDuenio ?? "",
                    "nombre" : self.item!.nombre ?? "",
                    "nacimiento" : self.item!.nacimiento ?? "",
                    "sexo" : self.item!.sexo as Bool,
                    "raza" : self.item!.raza ?? "",
                    "esterilizado" : self.item!.esterilizado as Bool,
                    "talla" : self.item!.talla ,
                    "extraviado" : true,
                    "foto" : self.item!.foto ?? "",
                    "detalles": detalles!.text ?? "",
                    "fechaExtravio": fechaExtravio!.text ?? "",
                    "lugarExtravio" : lugarExtravio.text ?? ""
                    
        ]) { error in
            if error != nil {
               return
            }
            self.db.collection("users").document(self.item!.idDuenio).collection("mascotas").document(self.item!.idMascota).setData([
                "idMascota" : self.item?.idMascota ?? "",
                "idDuenio" : self.item?.idDuenio ?? "",
                "nombre" : self.item?.nombre ?? "",
                "nacimiento" : self.item?.nacimiento ?? "",
                "sexo" : self.item!.sexo as Bool,
                "raza" : self.item?.raza ?? "",
                "esterilizado" : self.item!.esterilizado as Bool,
                "talla" : self.item?.talla ?? "",
                "extraviado" : true,
                "foto" : self.item?.foto ?? "",
            ])
            
            }
                self.navigationController?.popViewController(animated: true)
        }
        }
            
            
        }
    }
    let datePicker = UIDatePicker()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Reportar extravio de \(item?.nombre ?? "")"
        createDatePicker()

        // Do any additional setup after loading the view.
    }
    func createDatePicker(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        fechaExtravio.inputAccessoryView = toolbar
        fechaExtravio.inputView = datePicker
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels

    }
    
    @objc func donePressed(){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.dateFormat = "dd MMM yyyy"
        fechaExtravio.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
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
