//
//  VentasTicketTableViewCell.swift
//  LosBarkitosIpad
//
//  Created by chus on 2/2/15.
//  Copyright (c) 2015 Jesus Valladolid Rebollar. All rights reserved.
//

import UIKit

class VentasTicketTableViewCell: UITableViewCell {

    @IBOutlet weak var vendedorVentasTicketsUILabel: UILabel!
    @IBOutlet weak var baseVentasTicketsUILabel: UILabel!
    @IBOutlet weak var horaVentasTicketsUILabel: UILabel!
    @IBOutlet weak var barcaVentasTicketsUILabel: UILabel!
    @IBOutlet weak var precioVentasTicketsIULabel: UILabel!
    //@IBOutlet weak var numeroVentasTicketsUILabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
