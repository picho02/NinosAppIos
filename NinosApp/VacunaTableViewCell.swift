//
//  VacunaTableViewCell.swift
//  NinosApp
//
//  Created by Erendira Cruz Reyes on 16/07/22.
//

import UIKit

class VacunaTableViewCell: UITableViewCell {
    @IBOutlet weak var tipoVacuna: UILabel!
    @IBOutlet weak var fechaAplicacion: UILabel!
    @IBOutlet weak var fechaRefuerzo: UILabel!


    @IBAction func deleteVacunaBtn(_ sender: Any) {
    }
    @IBAction func editVacunaBtn(_ sender: Any) {
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
