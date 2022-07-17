//
//  PerdidoTableViewCell.swift
//  NinosApp
//
//  Created by Erendira Cruz Reyes on 14/07/22.
//

import UIKit

class PerdidoTableViewCell: UITableViewCell {

    @IBOutlet weak var perdidosView: UIView!
    @IBOutlet weak var sexoPerdido: UIImageView!
    @IBOutlet weak var imagenMascotaPerdida: UIImageView!
    @IBOutlet weak var nombePerdido: UILabel!
    @IBOutlet weak var lugarExtravio: UILabel!
    @IBOutlet weak var fechaExtravio: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
