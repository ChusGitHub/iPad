//
//  ControlViewController.swift
//  LosBarkitosIpad
//
//  Created by Jesus Valladolid Rebollar on 14/11/14.
//  Copyright (c) 2014 Jesus Valladolid Rebollar. All rights reserved.
//

import UIKit

class ControlViewController: UIViewController, WebServiceProtocoloControl, UITableViewDataSource, UITableViewDelegate {
    
    
    let RIO       = 1
    let ELECTRICA = 2
    let WHALY     = 3
    let GOLD      = 4

    
    var webService : webServiceCallAPI = webServiceCallAPI()
    var estado : String?
    
    var libre : [String : [String : String]]?
    
    @IBOutlet weak var lblEstadoUILabel: UILabel!
    @IBOutlet weak var lblLlegadaRioUILabel: UILabel!
    @IBOutlet weak var lblLlegadaElectricaUILabel: UILabel!
    @IBOutlet weak var lblLlegadaWhalyUILabel: UILabel!
    @IBOutlet weak var lblLlegadaGoldUILabel: UILabel!
    
    @IBOutlet weak var listaUITableView: UITableView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.libre = nil
        webService.obtenerPrimerLibre()
        self.estado = DataManager().getValueForKey("estado", inFile: "appstate") as? String
    }
    
    @IBAction func salidaUIButton(sender: AnyObject) {
        
    }

    @IBAction func llegadaUIButton(sender: AnyObject) {
    }
    
    
    @IBAction func listaTipoBarcaUIButton(sender: AnyObject) {
        webService.listaLlegadas(sender.tag)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webService.delegateControl = self
        webService.obtenerPrimerLibre()
        
        self.lblEstadoUILabel.text = DataManager().getValueForKey("estado", inFile: "appstate") as? String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didReceiveResponse_primeraLibre(respuesta: [String : [String : String]]) {
        
        self.libre = respuesta
        println("\(self.libre)")
        colocarLibresEnPantalla()
    }
    
    func didReceiveResponse_listaLlegadas(sender : AnyObject) {
        
    }

    
    func colocarLibresEnPantalla() {
        
        let RIO : [String : String]? = self.libre?["rio"]
        let ELECTRICA = self.libre?["electrica"]
        let WHALY = self.libre?["whaly"]
        let GOLD = self.libre?["gold"]
        
        let nombreRIO : String? = RIO?["nombre"]
        let libreRIO : String? = RIO?["libre"]
        let nombreELECTRICA : String? = ELECTRICA?["nombre"]
        let libreELECTRICA : String? = ELECTRICA?["libre"]
        let nombreWHALY : String? = WHALY?["nombre"]
        let libreWHALY : String? = WHALY?["libre"]
        let nombreGOLD : String? = GOLD?["nombre"]
        let libreGOLD : String? = GOLD?["libre"]

        self.lblLlegadaRioUILabel.text = nombreRIO! + " - " + libreRIO!
        self.lblLlegadaElectricaUILabel.text = nombreELECTRICA! + " - " + libreELECTRICA!
        self.lblLlegadaWhalyUILabel.text = nombreWHALY! + " - " + libreWHALY!
        self.lblLlegadaGoldUILabel.text = nombreGOLD! + " - " + libreGOLD!

    }
    
    
    
    // IMPLEMENTO LOS METODOS DELEGADOS DE listaUITableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == VENDEDOR {
            return self.vendedores.count
        } else {
            return self.ventas.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        if tableView.tag == VENDEDOR {
            var cell: VendedorUITableViewCell = self.vendedorUITableView.dequeueReusableCellWithIdentifier("cell") as VendedorUITableViewCell
            
            
            cell.nombreVendedorUILabelCell.textColor = UIColor.grayColor()
            cell.codigoVendedorUILabelCell.textColor = UIColor.grayColor()
            if indexPath.row % 2 == 0 {
                cell.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
            } else {
                cell.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
            }
            
            let vendedor = self.vendedores[indexPath.row]
            let codigo = Array(vendedor.keys)
            let nombre = Array(vendedor.values)
            cell.codigoVendedorUILabelCell.text = String(codigo[0])
            cell.nombreVendedorUILabelCell.text = nombre[0]
            
            // añado el codigo del vendedor al plist
            DataManager().setValueForKey("vendedor", value: codigo, inFile: "appstate")
            DataManager().setValueForKey("nombre_vendedor", value: nombre, inFile: "appstate")
            
            return cell
            
        } else {
            var cell: VentasTicketTableViewCell = self.ventasUITableView.dequeueReusableCellWithIdentifier("CellVentas") as  VentasTicketTableViewCell
            cell.numeroVentasTicketsUILabel.text = self.ventas[indexPath.row]["numero"]
            cell.vendedorVentasTicketsUILabel.text = self.ventas[indexPath.row]["nombre"]
            println(self.ventas[indexPath.row]["nombre"])
            cell.precioVentasTicketsIULabel.text = self.ventas[indexPath.row]["precio"]
            println(self.ventas[indexPath.row]["precio"])
            cell.baseVentasTicketsUILabel.text = self.ventas[indexPath.row]["base"]
            println(self.ventas[indexPath.row]["base"])
            cell.horaVentasTicketsUILabel.text = self.ventas[indexPath.row]["fecha"]
            println(self.ventas[indexPath.row]["fecha"])
            cell.barcaVentasTicketsUILabel.text = self.ventas[indexPath.row]["tipo"]
            println(self.ventas[indexPath.row]["tipo"])
            
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let altura = tableView.frame.height
        if tableView.tag == VENDEDOR {
            return altura/(CGFloat) (self.vendedores.count)
        } else {
            return 50.0        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if tableView.tag == VENDEDOR {
            // recupero los valores de la celda
            let dictVendedor : [String : String] = self.vendedores[indexPath.row]
            let codigo = Array(dictVendedor.keys)
            let nombre = Array(dictVendedor.values)
            
            // Guardo el vendedor en el plist
            DataManager().setValueForKey("vendedor", value: codigo[0], inFile: "appstate")
            DataManager().setValueForKey("nombre_vendedor", value: String(nombre[0]), inFile: "appstate")
            
            // Pongo el nombre del vendedor en el uitextview
            self.vendedorUITextField.text = nombre[0]
            
            // Quito el uitableview de los  vendedores
            self.vendedorUITableView.hidden = true
            self.btnViewVendedoresUIButton.enabled = true
            self.vendedores = []
            self.vendedorUITableView.clearsContextBeforeDrawing = true
            self.vendedorUITableView.reloadData()
        } else {
            
        }
    }


}

