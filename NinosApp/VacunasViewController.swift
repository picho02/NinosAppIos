//
//  VacunasViewController.swift
//  NinosApp
//
//  Created by Erendira Cruz Reyes on 16/07/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class VacunasViewController: UIViewController , UITextFieldDelegate{
    
    var item:Mascota?
    var vacuna:Vacunas?
    var tipoPickerView = UIPickerView()
    let datePicker = UIDatePicker()
    let datePicker2 = UIDatePicker()
    private let db = Firestore.firestore()
   
    @IBOutlet weak var tipoTextField: UITextField!
    @IBOutlet weak var fechaAplicacionTextField: UITextField!
    @IBOutlet weak var fechaRefuerzoTextField: UITextField!
    @IBAction func aceptarBtn(_ sender: Any) {
        if tipoTextField.text != ""{
            if fechaAplicacionTextField.text != "" {
                if fechaAplicacionTextField.text != "" {
                    var idVacuna = ""
                    if vacuna != nil {
                        idVacuna = vacuna!.idVacuna
                    }else{
                        idVacuna = "\(fechaAplicacionTextField.text!)\(tipoTextField.text!)"
                    }
                    self.db.collection("users").document(item!.idDuenio).collection("mascotas").document(item!.idMascota).collection("vacunas").document(idVacuna).setData([
                        "idVacuna" : idVacuna,
                        "tipo" : tipoTextField.text ?? "",
                        "fechaAplicacion" : fechaAplicacionTextField.text ?? "",
                        "fechaRefuerzo" : fechaRefuerzoTextField.text ?? "",

                            ]) { error in
                                if error != nil {
                                    print("Error al crear la base")
                                    return
                                }
                                self.navigationController?.popViewController(animated: true)
                            }
                        

                }else{
                    let alert = UIAlertController(title: "Opción no valida", message: "Seleccione una fecha de refuerzo valida", preferredStyle: .alert)
                    let boton = UIAlertAction(title: "ok", style: .default)
                    alert.addAction(boton)
                        self.present(alert,animated: true)
                }
            }else{
                let alert = UIAlertController(title: "Opción no valida", message: "Seleccione una fecha de aplicacion valida", preferredStyle: .alert)
                let boton = UIAlertAction(title: "ok", style: .default)
                alert.addAction(boton)
                    self.present(alert,animated: true)
            }
            
        }else{
            let alert = UIAlertController(title: "Opción no valida", message: "Ingrese una vacuna", preferredStyle: .alert)
            let boton = UIAlertAction(title: "ok", style: .default)
            alert.addAction(boton)
                self.present(alert,animated: true)
            return
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
        if vacuna != nil {
            self.tipoTextField.text = vacuna?.tipo
            self.fechaRefuerzoTextField.text = vacuna?.fechaRefuerzo
            self.fechaAplicacionTextField.text = vacuna?.fechaAplicacion
        }

        // Do any additional setup after loading the view.
    }
    func createDatePicker(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        fechaAplicacionTextField.inputAccessoryView = toolbar
        fechaAplicacionTextField.inputView = datePicker
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        let toolbar2 = UIToolbar()
        toolbar2.sizeToFit()
        let doneBtn2 = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed2))
        toolbar2.setItems([doneBtn2], animated: true)
        fechaRefuerzoTextField.inputAccessoryView = toolbar2
        fechaRefuerzoTextField.inputView = datePicker2
        datePicker2.datePickerMode = .date
        datePicker2.preferredDatePickerStyle = .wheels

    }
    
    @objc func donePressed(){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.dateFormat = "dd MMM yyyy"
        fechaAplicacionTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    @objc func donePressed2(){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.dateFormat = "dd MMM yyyy"
        fechaRefuerzoTextField.text = formatter.string(from: datePicker2.date)
        self.view.endEditing(true)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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

