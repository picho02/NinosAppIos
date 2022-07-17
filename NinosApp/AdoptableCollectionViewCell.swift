//
//  AdoptableCollectionViewCell.swift
//  NinosApp
//
//  Created by Erendira Cruz Reyes on 13/07/22.
//

import UIKit

class AdoptableCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imagenMascotaAdoptable: UIImageView!
    @IBOutlet weak var imagenGeneroMascotaAdoptable: UIImageView!
    @IBOutlet weak var nombreMascotaAdoptable: UILabel!
    @IBOutlet weak var duenioMascotaAdoptable: UILabel!
    
    func setup(index: Int){
        nombreMascotaAdoptable.text = "prueba \(index)"
        duenioMascotaAdoptable.text = "dueño \(index)"

    }
    
}
