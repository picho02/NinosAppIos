//
//  ManadaTableViewCell.swift
//  NinosApp
//
//  Created by Erendira Cruz Reyes on 14/07/22.
//

import UIKit

class ManadaTableViewCell: UITableViewCell {

    @IBOutlet weak var edadMascota: UILabel!
    @IBOutlet weak var nombreMascota: UILabel!
    @IBOutlet weak var imagenManada: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
