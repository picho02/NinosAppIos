//
//  DetalleAdoptableViewController.swift
//  NinosApp
//
//  Created by Erendira Cruz Reyes on 13/07/22.
//

import UIKit

class DetalleAdoptableViewController: UIViewController {

    @IBOutlet weak var razaAdoptable: UILabel!
    @IBOutlet weak var sexoAdoptable: UILabel!
    @IBOutlet weak var edadAdoptable: UILabel!
    @IBOutlet weak var tallaAdoptable: UILabel!
    @IBOutlet weak var navigationBarAdoptable: UINavigationItem!
    @IBOutlet weak var esterilizadoAdoptable: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "some title"

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
