//
//  AgregarMascotaViewController.swift
//  NinosApp
//
//  Created by Erendira Cruz Reyes on 14/07/22.
//

import UIKit
import AVFoundation
import FirebaseAuth
import FirebaseFirestore
import Photos
import FirebaseStorage
import Firebase

class AgregarMascotaViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    

    
    var fecha = Date()
    let sexo = ["Seleccione sexo","Macho","Hembra"]
    let esterilizado = ["Seleccione si esta esterilizado","Si","No"]
    let talla = ["Seleccione talla","Mini","Chica","Mediana","Grande","Extra grande"]
    var sexoPickerView = UIPickerView()
    var esterilizacionPickerView = UIPickerView()
    var tallaPickerView = UIPickerView()
    private let db = Firestore.firestore()
    let storage = Storage.storage().reference()
    var item:Mascota?
    var idMascota = ""


    @IBOutlet weak var btnCamara: UIButton!
    @IBOutlet weak var ivFoto: UIImageView!
    @IBOutlet weak var esterilizadoTextField: UITextField!
    @IBOutlet weak var sexoTextField: UITextField!
    @IBOutlet weak var fechaNacimiento: UITextField!
    @IBOutlet weak var tallaTextField: UITextField!
    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var razaTextField: UITextField!
    
    @IBAction func guardarBtn(_ sender: Any) {
        let nombreMascota = nombreTextField.text!
        let idDuenio = Auth.auth().currentUser!.uid
        var extraviado = Bool()
        if idMascota == ""{
            idMascota = idDuenio+nombreMascota
            extraviado = false
        }else{
            extraviado = item!.extraviado
        }
        var sexoBool = false
        if sexoTextField.text == "Macho" {
            sexoBool = true
        }else if sexoTextField.text == "Hembra"{
            sexoBool = false
        } else {
            let alert = UIAlertController(title: "Opción no valida", message: "Seleccione un sexo valido", preferredStyle: .alert)
            let boton = UIAlertAction(title: "ok", style: .default)
            alert.addAction(boton)
                self.present(alert,animated: true)
            return
        }
        var esterilizadoBool = false
        if esterilizadoTextField.text == esterilizado[1] {
            esterilizadoBool = true
        }else if esterilizadoTextField.text == esterilizado[2]{
            esterilizadoBool = false
        } else {
            let alert = UIAlertController(title: "Opción no valida", message: "Seleccione sí esta esterilizado", preferredStyle: .alert)
            let boton = UIAlertAction(title: "ok", style: .default)
            alert.addAction(boton)
                self.present(alert,animated: true)
            return
        }
        if tallaTextField.text == talla[0] || tallaTextField.text == ""{
            let alert = UIAlertController(title: "Opción no valida", message: "Seleccione una talla valida", preferredStyle: .alert)
            let boton = UIAlertAction(title: "ok", style: .default)
            alert.addAction(boton)
                self.present(alert,animated: true)
            return
        }
        if nombreMascota.isEmpty || razaTextField.text == "" {
            let alert = UIAlertController(title: "Opción no valida", message: "Rellene todos los campos", preferredStyle: .alert)
            let boton = UIAlertAction(title: "ok", style: .default)
            alert.addAction(boton)
                self.present(alert,animated: true)
            return
        }
        if fechaNacimiento.text == "" {
            let alert = UIAlertController(title: "Opción no valida", message: "Rellene todos los campos", preferredStyle: .alert)
            let boton = UIAlertAction(title: "ok", style: .default)
            alert.addAction(boton)
                self.present(alert,animated: true)
            return
        }
        var urlString = ""
        guard let imageData = ivFoto.image?.pngData() else { return }
        let ref = storage.child("\(idMascota).png")
        ref.putData(imageData, metadata: nil, completion: {_, error in
            guard error == nil else {
                print("algo salio mal")
                return
            }
            
            ref.downloadURL { url, error in
                guard let url = url, error == nil else { return}
                urlString = url.absoluteString
                print(urlString)
                self.db.collection("users").document(idDuenio).collection("mascotas").document(self.idMascota).setData([
                    "idMascota" : self.idMascota,
                    "idDuenio" : idDuenio,
                    "nombre" : nombreMascota,
                    "nacimiento" : self.fechaNacimiento.text ?? "",
                    "sexo" : sexoBool,
                    "raza" : self.razaTextField.text ?? "",
                    "esterilizado" : esterilizadoBool,
                    "talla" : self.tallaTextField.text ?? "",
                    "extraviado" : extraviado,
                    "foto" : urlString
                ]) { error in
                    if error != nil {
                        print("Error al crear la base")
                        return
                    }
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }

            
        })


    }
    @IBAction func abrirGaleria(_ sender: Any) {

        let ipc = UIImagePickerController()

        ipc.sourceType = .photoLibrary
  
        ipc.delegate = self

        ipc.allowsEditing = true
        let permisos = AVCaptureDevice.authorizationStatus(for: .video)
            if permisos == .authorized{
                self.present(ipc,animated: true,completion: nil)
            }else{
                if permisos == .notDetermined {
                    AVCaptureDevice.requestAccess(for: .video) { respuesta in
                        DispatchQueue.main.async {
                        if respuesta {
                            self.present(ipc,animated: true,completion: nil)
                        }else{
                            print("Rayos")
                        }
                    }
                    }
                }else{ //.denied
                    let alert = UIAlertController(title: "", message: "Autoriza desde ajustes", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: nil))
                    let btnSi = UIAlertAction(title: "Si, porfa",style: .default){
                        action in
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!,options: [:],completionHandler: nil)
                    }
                    alert.addAction(btnSi)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        
    }
    let datePicker = UIDatePicker()
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        btnCamara.titleLabel?.text = ""
        if item != nil{
            idMascota = item!.idMascota
            nombreTextField.text = item!.nombre
            if item?.sexo == true{
                sexoTextField.text = sexo[1]
            }else{
                sexoTextField.text = sexo[2]
            }
            if item?.esterilizado == true{
                esterilizadoTextField.text = esterilizado[1]
            }else{
                esterilizadoTextField.text = esterilizado[2]
            }
            tallaTextField.text = item?.talla
            fechaNacimiento.text = item?.nacimiento
            razaTextField.text = item?.raza
            let url = URL(string: item!.foto)!
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, error == nil else{
                    return
                }
                DispatchQueue.main.async {
                let imagen = UIImage(data: data)
                    self.ivFoto.image = imagen
                }
            }
            task.resume()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        btnCamara.titleLabel?.text = ""
    }
    @IBAction func tomarFoto(_ sender: Any) {
        let ipc = UIImagePickerController()
        //Para trabajar con la libreria
        //ipc.sourceType = .photoLibrary
        //Para trabajar con la camara
        ipc.delegate = self
        // permitir edicion
        ipc.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            ipc.sourceType = .camera
            //Validar permiso del usuario
            let permisos = AVCaptureDevice.authorizationStatus(for: .video)
            if permisos == .authorized{
                self.present(ipc,animated: true,completion: nil)
            }else{
                if permisos == .notDetermined {
                    AVCaptureDevice.requestAccess(for: .video) { respuesta in
                        if respuesta {
                            DispatchQueue.main.async {
                            self.present(ipc,animated: true,completion: nil)
                            }
                        }else{
                            print("Rayos")
                        }
                    }
                }else{ //.denied
                    let alert = UIAlertController(title: "", message: "Autoriza desde ajustes", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: nil))
                    let btnSi = UIAlertAction(title: "Si, porfa",style: .default){
                        action in
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!,options: [:],completionHandler: nil)
                    }
                    alert.addAction(btnSi)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }

    }
    
    func createDatePicker(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        fechaNacimiento.inputAccessoryView = toolbar
        fechaNacimiento.inputView = datePicker
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        sexoTextField.inputView = sexoPickerView
        esterilizadoTextField.inputView = esterilizacionPickerView
        tallaTextField.inputView = tallaPickerView
        sexoPickerView.delegate = self
        sexoPickerView.dataSource = self
        esterilizacionPickerView.delegate = self
        esterilizacionPickerView.dataSource = self
        tallaPickerView.delegate = self
        tallaPickerView.dataSource = self
        sexoPickerView.tag = 1
        esterilizacionPickerView.tag = 2
        tallaPickerView.tag = 3
        nombreTextField.delegate = self
        razaTextField.delegate = self

    }
    @objc func donePressed(){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.dateFormat = "dd MMM yyyy"
        fechaNacimiento.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag{
        case 1:
            return sexo.count
        case 2:
            return esterilizado.count
        case 3:
            return talla.count
        default:
            return 1
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag{
        case 1:
            return sexo[row]
        case 2:
            return esterilizado[row]
        case 3:
            return talla[row]
        default:
            return "Error"
        }
    }



    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag{
        case 1:
            sexoTextField.text = sexo[row]
            sexoTextField.resignFirstResponder()
        case 2:
            esterilizadoTextField.text = esterilizado[row]
            esterilizadoTextField.resignFirstResponder()
        case 3:
            tallaTextField.text = talla[row]
            tallaTextField.resignFirstResponder()
        default:
            return
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("Selecciono")
        guard let imagen = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
            guard let imageData = imagen.pngData() else { return }
        ivFoto.image = imagen
        

        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Cancelo")
        picker.dismiss(animated: true, completion: nil)
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
