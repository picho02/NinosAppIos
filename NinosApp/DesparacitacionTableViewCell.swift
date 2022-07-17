//
//  DesparacitacionTableViewCell.swift
//  NinosApp
//
//  Created by Erendira Cruz Reyes on 16/07/22.
//

import UIKit

class DesparacitacionTableViewCell: UITableViewCell {

    @IBOutlet weak var tipoDesparacitacion: UILabel!
    @IBOutlet weak var fechaAplicacion: UILabel!
    @IBOutlet weak var fechaRefuerzo: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
