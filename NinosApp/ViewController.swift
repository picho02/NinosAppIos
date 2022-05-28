//
//  ViewController.swift
//  NinosApp
//
//  Created by Erendira Cruz Reyes on 24/05/22.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tablaManada: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tablaManada.delegate = self
        tablaManada.dataSource = self
        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }

}

