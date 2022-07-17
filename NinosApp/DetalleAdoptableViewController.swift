//
//  DetalleAdoptableViewController.swift
//  NinosApp
//
//  Created by Erendira Cruz Reyes on 13/07/22.
//

import UIKit

class DetalleAdoptableViewController: UIViewController {
    var item:Adoptable?
    @IBOutlet weak var razaAdoptable: UILabel!
    @IBOutlet weak var sexoAdoptable: UILabel!
    @IBOutlet weak var edadAdoptable: UILabel!
    @IBOutlet weak var detalles: UILabel!
    @IBOutlet weak var imagenAdoptable: UIImageView!
    @IBOutlet weak var tallaAdoptable: UILabel!
    @IBOutlet weak var duenio: UILabel!
    @IBAction func adoptarBtn(_ sender: Any) {
        let alert = UIAlertController(title: "Casi tienes un nuevo integrante", message: "El dueño se pondra en contacto", preferredStyle: .alert)
        let boton = UIAlertAction(title: "ok", style: .default)
        alert.addAction(boton)
        self.present(alert,animated: true)
    }
    @IBOutlet weak var energia: UILabel!
    @IBOutlet weak var sociable: UILabel!
    @IBOutlet weak var ejercicio: UILabel!
    @IBOutlet weak var navigationBarAdoptable: UINavigationItem!
    @IBOutlet weak var esterilizadoAdoptable: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = item?.nombre
        razaAdoptable.text = item?.raza
        if item!.sexo{
            sexoAdoptable.text = "Macho"
        }else{
            sexoAdoptable.text = "Hembra"
        }
        edadAdoptable.text = item?.nacimiento
        tallaAdoptable.text = item?.talla
        if item!.esterilizado{
            esterilizadoAdoptable.text = "Si"
        }else{
            esterilizadoAdoptable.text = "No"
        }
        energia.text = item?.energia
        ejercicio.text = item?.necesitaEjercicio
        sociable.text = item?.sociable
        detalles.text = item?.detalles
        let url = URL(string: item!.foto)!
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else{
                return
            }
            DispatchQueue.main.async {
            let imagen = UIImage(data: data)
                self.imagenAdoptable.image = imagen
            }
        }
        
        task.resume()
        
        // Do any additional setup after loading the view.
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
