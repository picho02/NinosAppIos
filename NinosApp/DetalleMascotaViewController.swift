//
//  DetalleMascotaViewController.swift
//  NinosApp
//
//  Created by Erendira Cruz Reyes on 16/07/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class DetalleMascotaViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    var item:Mascota?
    var rowDesparacitada = 0
    var rowVacuna = 0
    private let db = Firestore.firestore()
    @IBOutlet weak var tablaVacunas: UITableView!
    @IBOutlet weak var tablaDesparacitaciones: UITableView!
    @IBOutlet weak var imagenMascota: UIImageView!
    @IBOutlet weak var raza: UILabel!
    @IBOutlet weak var genero: UILabel!
    @IBOutlet weak var edad: UILabel!
    @IBOutlet weak var nacimiento: UILabel!
    @IBOutlet weak var talla: UILabel!
    @IBOutlet weak var esterilizado: UILabel!
    @IBAction func editarMascota(_ sender: Any) {
        self.performSegue(withIdentifier: "editarMascota", sender: nil)
        
    }
    
    @IBAction func addDesparacitacion(_ sender: Any) {
        self.performSegue(withIdentifier: "addDesparacitacion", sender: nil)
    }
    
    @IBAction func addVacuna(_ sender: Any) {
        self.performSegue(withIdentifier: "addVacuna", sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        DataDesparacitaciones.instance.getInfo(idMascota: self.item!.idMascota)
        DataVacunas.instance.getInfo(idMascota: self.item!.idMascota)
        let url = URL(string: item!.foto)!
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else{
                return
            }
            DispatchQueue.main.async {
            let imagen = UIImage(data: data)
                self.imagenMascota.image = imagen
            }
        }
        
        task.resume()
        self.title = item?.nombre
        raza.text = item?.raza
        if item?.sexo == true{
            genero.text = "Macho"
        }else{
            genero.text = "Hembra"
        }
        nacimiento.text = item?.nacimiento
        talla.text = item?.talla
        if item?.esterilizado == true{
            esterilizado.text = "Si"
            
        }else{
            esterilizado.text = "No"
        }
        tablaDesparacitaciones.tag = 1
        tablaVacunas.tag = 2
        tablaVacunas.delegate = self
        tablaDesparacitaciones.delegate = self
        tablaVacunas.dataSource = self
        tablaDesparacitaciones.dataSource = self

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        tablaDesparacitaciones.reloadData()
        tablaVacunas.reloadData()
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
        case "editarMascota":
            let vc = segue.destination as! AgregarMascotaViewController
            let item = self.item
            vc.item = item
        case "addDesparacitacion":
            let vc = segue.destination as! DesparacitacionesViewController
            let item = self.item
            vc.item = item
        case "editDesparacitacion":
            let vc = segue.destination as! DesparacitacionesViewController
            let item = self.item
            vc.item = item
            let desparacitada = DataDesparacitaciones.instance.info[rowDesparacitada]
                vc.desparacitada = desparacitada
        case "addVacuna":
            let vc = segue.destination as! VacunasViewController
            let item = self.item
            vc.item = item
        case "editVacuna":
            let vc = segue.destination as! VacunasViewController
            let item = self.item
            vc.item = item
            let vacuna = DataVacunas.instance.info[rowVacuna]
                vc.vacuna = vacuna
        default:
            return
        }

    }
    //Metodos tabla
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView.tag{
        case 1 :
            return DataDesparacitaciones.instance.info.count
        case 2:
            return DataVacunas.instance.info.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView.tag{
        case 1:
            let cell = tablaDesparacitaciones.dequeueReusableCell(withIdentifier: "DesparacitacionTableViewCell", for: indexPath) as! DesparacitacionTableViewCell
            let tmp: Desparacitaciones = DataDesparacitaciones.instance.info[indexPath.row]
            cell.tipoDesparacitacion.text = tmp.tipo
            cell.fechaRefuerzo.text = tmp.fechaRefuerzo
            cell.fechaAplicacion.text = tmp.fechaAplicacion
            return cell
        case 2:
            let cell = tablaVacunas.dequeueReusableCell(withIdentifier: "VacunaTableViewCell", for: indexPath) as! VacunaTableViewCell
            let tmp: Vacunas = DataVacunas.instance.info[indexPath.row]
            cell.tipoVacuna.text = tmp.tipo
            cell.fechaRefuerzo.text = tmp.fechaRefuerzo
            cell.fechaAplicacion.text = tmp.fechaAplicacion
            return cell
        default:
            let cell = tablaVacunas.dequeueReusableCell(withIdentifier: "VacunaTableViewCell", for: indexPath) as! VacunaTableViewCell
            return cell
        }

    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if tableView.tag == 1{
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { _, indexPath in
            if tableView.tag == 1 {
                let alert = UIAlertController(title: "Eliminar desparacitada", message: "¿Esta seguro que desea eliminar?", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: nil))
                let btnNo = UIAlertAction(title: "si", style: .destructive){
                    action in
                        let desparacitada = DataDesparacitaciones.instance.info[indexPath.row]
                    print(desparacitada.idDesparacitacion)
                        self.db.collection("users").document(self.item!.idDuenio).collection("mascotas").document(self.item!.idMascota).collection("desparacitaciones").document(desparacitada.idDesparacitacion).delete()
                    self.tablaDesparacitaciones.reloadData()
                    DataDesparacitaciones.instance.info.remove(at: indexPath.row)
                    self.tablaDesparacitaciones.deleteRows(at: [indexPath], with: .automatic)
                }
                alert.addAction(btnNo)
                self.present(alert, animated: true, completion: nil)
            }

        }
        let editarDesparacitada = UITableViewRowAction(style: .normal, title: "Editar") { _, indexPath in
            self.rowDesparacitada = indexPath.row
            self.performSegue(withIdentifier: "editDesparacitacion", sender: nil)

        }
        editarDesparacitada.backgroundColor = .orange
            return[editarDesparacitada, deleteAction]
            
        }else{
            let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { _, indexPath in
                if tableView.tag == 2 {
                    let alert = UIAlertController(title: "Eliminar Vacuna", message: "¿Esta seguro que desea eliminar?", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: nil))
                    let btnNo = UIAlertAction(title: "si", style: .destructive){
                        action in
                            let vacuna = DataVacunas.instance.info[indexPath.row]
                        print(vacuna.idVacuna)
                            self.db.collection("users").document(self.item!.idDuenio).collection("mascotas").document(self.item!.idMascota).collection("vacunas").document(vacuna.idVacuna).delete()
                        self.tablaVacunas.reloadData()
                        DataVacunas.instance.info.remove(at: indexPath.row)
                        self.tablaVacunas.deleteRows(at: [indexPath], with: .automatic)
                    }
                    alert.addAction(btnNo)
                    self.present(alert, animated: true, completion: nil)
                }

            }
            let editarVacuna = UITableViewRowAction(style: .normal, title: "Editar") { _, indexPath in
                self.rowVacuna = indexPath.row
                self.performSegue(withIdentifier: "editVacuna", sender: nil)

            }
            editarVacuna.backgroundColor = .orange
                return[editarVacuna, deleteAction]
                
            }
        
    }

}
