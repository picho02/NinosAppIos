//
//  DesparacitacionesViewController.swift
//  NinosApp
//
//  Created by Erendira Cruz Reyes on 16/07/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class DesparacitacionesViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    var item:Mascota?
    var desparacitada:Desparacitaciones?
    let tipo = ["Seleccione tipo de desparacitación","Externa","Interna"]
    var tipoPickerView = UIPickerView()
    let datePicker = UIDatePicker()
    let datePicker2 = UIDatePicker()
    private let db = Firestore.firestore()
   
    @IBOutlet weak var tipoTextField: UITextField!
    @IBOutlet weak var fechaAplicacionTextField: UITextField!
    @IBOutlet weak var fechaRefuerzoTextField: UITextField!
    @IBAction func aceptarBtn(_ sender: Any) {
        if tipoTextField.text != "" || tipoTextField.text != tipo[0]{
            if fechaAplicacionTextField.text != "" {
                if fechaAplicacionTextField.text != "" {
                    var idDesparacitada = ""
                    if desparacitada != nil {
                        idDesparacitada = desparacitada!.idDesparacitacion
                    }else{
                        idDesparacitada = "\(fechaAplicacionTextField.text!)\(tipoTextField.text!)"
                    }
                    self.db.collection("users").document(item!.idDuenio).collection("mascotas").document(item!.idMascota).collection("desparacitaciones").document(idDesparacitada).setData([
                        "idDesparacitacion" : idDesparacitada,
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
            let alert = UIAlertController(title: "Opción no valida", message: "Seleccione un tipo valido", preferredStyle: .alert)
            let boton = UIAlertAction(title: "ok", style: .default)
            alert.addAction(boton)
                self.present(alert,animated: true)
            return
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
        if desparacitada != nil {
            self.tipoTextField.text = desparacitada?.tipo
            self.fechaRefuerzoTextField.text = desparacitada?.fechaRefuerzo
            self.fechaAplicacionTextField.text = desparacitada?.fechaAplicacion
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
        tipoTextField.inputView = tipoPickerView
        tipoPickerView.delegate = self
        tipoPickerView.dataSource = self
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
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        tipo.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return tipo[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tipoTextField.text = tipo[row]
        tipoTextField.resignFirstResponder()
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
