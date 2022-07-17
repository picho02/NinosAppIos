//
//  DetallePerdidoViewController.swift
//  NinosApp
//
//  Created by Erendira Cruz Reyes on 16/07/22.
//

import UIKit

class DetallePerdidoViewController: UIViewController {
    var item:Perdidos?
    @IBOutlet weak var imagenPerdido: UIImageView!
    @IBOutlet weak var talla: UILabel!
    @IBOutlet weak var raza: UILabel!
    @IBOutlet weak var genero: UILabel!
    @IBOutlet weak var esterilizado: UILabel!
    @IBOutlet weak var lugarExtravio: UILabel!
    @IBOutlet weak var fechaExtravio: UILabel!
    @IBOutlet weak var detalles: UILabel!
    @IBAction func contactarBtn(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = item?.nombre

        talla.text = item?.talla
        raza.text = item?.raza
        if item!.sexo {
            genero.text = "Macho"
        }else{
            genero.text = "Hembra"
        }
        if item!.esterilizado{
            esterilizado.text = "Si"
        }else{
            esterilizado.text = "No"
        }
        lugarExtravio.text = item?.lugarExtravio
        fechaExtravio.text = item?.fechaExtravio
        detalles.text = item?.detalles
        let url = URL(string: item!.foto)!
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else{
                return
            }
            DispatchQueue.main.async {
            let imagen = UIImage(data: data)
                self.imagenPerdido.image = imagen
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
