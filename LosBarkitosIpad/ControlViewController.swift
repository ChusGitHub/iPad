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
    
    var libre = [String : [String : String]]()
    var lista = [[String : String]]()
    
    @IBOutlet weak var lblEstadoUILabel: UILabel!
    @IBOutlet weak var lblLlegadaRioUILabel: UILabel!
    @IBOutlet weak var lblLlegadaElectricaUILabel: UILabel!
    @IBOutlet weak var lblLlegadaWhalyUILabel: UILabel!
    @IBOutlet weak var lblLlegadaGoldUILabel: UILabel!
    
    @IBOutlet weak var listaUITableView: UITableView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //self.libre = nil
        webService.obtenerPrimerLibre()
        self.estado = DataManager().getValueForKey("estado", inFile: "appstate") as? String
    }
    
    @IBAction func salidaUIButton(sender: AnyObject) {
        
    }

    @IBAction func llegadaUIButton(sender: AnyObject) {
        
    }
    
    @IBAction func listaTipoBarcaUIButton(sender: AnyObject) {
        webService.listaReservas(sender.tag)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webService.obtenerPrimerLibre()

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
    
    func didReceiveResponse_listaLlegadas(respuesta: [String : AnyObject ]) {
        
        self.lista = []
        var registro : [String : String] = [:]
        
        println("lista llegadas : \(respuesta)")
        
        for (k,v) in respuesta {
            println("k = \(k)")
            println("v = \(v)")

            registro["nombre"] = v["Nombre"] as? String
            registro["libre"] = v["libre"] as? String
            registro["tipo"] = v["Tipo"] as? String
            let vueltas : Int = v["vueltas"] as! Int
            registro["vueltas"] = String(vueltas)
            
            self.lista.append(registro)
        }
        println("listaLlegadas : \(self.lista)")
        
        self.listaUITableView.clearsContextBeforeDrawing = true        // limpiar uitableview
        self.listaUITableView.reloadData()
    }

    
    func didReceiveResponse_listaReservas(respuesta: [String : AnyObject]) {
        
        self.lista = []
        var registro : [String : AnyObject] = [:]
        println("Lista reservas : \(respuesta)")
        
        for (k,v) in respuesta {
            registro["numero"] = v["numero"] as! Int
            registro["nombre"] = v["nombre"] as! String
            registro["hora_prevista"] = v["hora_prevista"] as! String
            registro["hora_reserva"]
        }
    }
    
    
    func colocarLibresEnPantalla() {
        
        let RIO : [String : String]? = self.libre["rio"]
        let ELECTRICA = self.libre["electrica"]
        let WHALY = self.libre["whaly"]
        let GOLD = self.libre["gold"]
        
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
        
        return self.lista.count
    
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell : ControlUITableViewCell = self.listaUITableView.dequeueReusableCellWithIdentifier("Cell") as! ControlUITableViewCell
      
        cell.numeroUILabelUITableViewCell.text = self.listaLlegadas[indexPath.row]["numero"]
        cell.nombreUILabelUITableViewCell.text = self.lista[indexPath.row]["nombre"]
   
        cell.tipoUILabelUITableViewCell.text = self.lista[indexPath.row]["tipo"]
        cell.libreUILabelUITableViewCell.text = self.lista[indexPath.row]["libre"]
        cell.vueltasUILabelUITableViewCell.text = String(self.lista[indexPath.row]["vueltas"]!)
        
        return cell
        
    }

    
   // func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    //}


}

