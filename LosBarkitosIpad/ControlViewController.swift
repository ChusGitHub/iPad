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
    let BARCA     = 2
    let GOLD      = 3

    var webServiceControl : webServiceCallAPI = webServiceCallAPI()
    var webService : webServiceCallAPI = webServiceCallAPI()
    var estado : String?
    
    var libre = [String : [String : String]]()
    var lista = [[String : AnyObject]]()
    
    
    @IBOutlet weak var listaUITableView: UITableView!
    
    @IBOutlet weak var btnRio: UIButton!
    @IBOutlet weak var btnBarca: UIButton!
    @IBOutlet weak var btnGold: UIButton!
    
    
    @IBOutlet weak var numeroRiosFueraUILAbel: UILabel!
    
    @IBOutlet weak var numeroElectricasFueraUILabel: UILabel!
    @IBOutlet weak var numeroWhalysFueraUILabel: UILabel!
    @IBOutlet weak var numeroGoldsFueraUILabel: UILabel!
    
    @IBOutlet weak var siguienteBarcaRioUiLabel: UILabel!
    @IBOutlet weak var siguienteBarcaElectricaUILabel: UILabel!
    @IBOutlet weak var siguienteBarcaWhalyUiLabel: UILabel!
    @IBOutlet weak var siguienteBarcaGoldUILabel: UILabel!
    
    @IBOutlet weak var numeroReservasRioUILabel: UILabel!
    @IBOutlet weak var numeroReservasElectricaUILabel: UILabel!
    @IBOutlet weak var numeroReservasWhalyUILabel: UILabel!
    @IBOutlet weak var numeroReservasGoldUILabel: UILabel!
    @IBOutlet weak var tiempoEsperaUILabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //self.libre = nil
        //webService.obtenerPrimerLibre()
        self.estado = DataManager().getValueForKey("estado", inFile: "appstate") as? String
    }
    
    @IBAction func salidaUIButton(sender: AnyObject) {
        
        webService.salidaBarca(sender.tag)
        switch sender.tag {
        case 1:
            if siguienteBarcaRioUiLabel.text == "---" || siguienteBarcaRioUiLabel.text == "" {
                webService.siguienteBarcaLlegar()
            }
        case 2:
            if siguienteBarcaElectricaUILabel.text == "---" || siguienteBarcaElectricaUILabel.text == "" {
                webService.siguienteBarcaLlegar()
            }
        case 3:
            if siguienteBarcaWhalyUiLabel.text == "---" || siguienteBarcaWhalyUiLabel.text == "" {
                webService.siguienteBarcaLlegar()
            }
        case 4:
            if siguienteBarcaGoldUILabel.text == "---" || siguienteBarcaGoldUILabel.text == "" {
                webService.siguienteBarcaLlegar()
            }
        default:
            print("Esta opcion no se puede dar")
        }
        
    }

    @IBAction func llegadaUIButton(sender: AnyObject) {
        
        webService.llegadaBarca(sender.tag)
        webService.siguienteBarcaLlegar()
    }
    
    @IBAction func listaTipoBarcaUIButton(sender: UIButton) {
        // Pongo los colores del fondo de los botones
        if sender.tag == 1 { // btnRio
            btnRio.backgroundColor = UIColor(red: 100, green: 0.0, blue: 0.0, alpha: 0.80)
            btnGold.backgroundColor =  UIColor(red: 100, green: 0.0, blue: 0.0, alpha: 0.35)
            btnBarca.backgroundColor =  UIColor(red: 100, green: 0.0, blue: 0.0, alpha: 0.35)
        } else if sender.tag == 2 { // btnBarca
            btnRio.backgroundColor = UIColor(red: 100, green: 0.0, blue: 0.0, alpha: 0.35)
            btnGold.backgroundColor =  UIColor(red: 100, green: 0.0, blue: 0.0, alpha: 0.35)
            btnBarca.backgroundColor =  UIColor(red: 100, green: 0.0, blue: 0.0, alpha: 0.80)
        } else if sender.tag == 3 { // btnGold
            btnRio.backgroundColor = UIColor(red: 100, green: 0.0, blue: 0.0, alpha: 0.35)
            btnGold.backgroundColor =  UIColor(red: 100, green: 0.0, blue: 0.0, alpha: 0.80)
            btnBarca.backgroundColor =  UIColor(red: 100, green: 0.0, blue: 0.0, alpha: 0.35)
        }

        webService.listaReservas(sender.tag)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webServiceControl.delegateControl = self
        webService.delegateControl = self
        //WebServiceProtocoloControl.delegate = self
       // webService.delegateControl = self
     //   webService.obtenerPrimerLibre()
        webService.siguienteBarcaLlegar()
        webServiceControl.numeroReservasPorDar()
        
    }
    
    func actualizarContadorBarcasFuera() {
        webService.barcasFuera()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didReceiveResponse_primeraLibre(respuesta: [String : [String : String]]) {
        
        self.libre = respuesta
        //println("\(self.libre)")
        colocarLibresEnPantalla()
    }
    
    func didReceiveResponse_listaLlegadas(respuesta: [String : AnyObject ]) {
        
        self.lista = []
        var registro : [String : String] = [:]
        
        //println("lista llegadas : \(respuesta)")
        
        for (_,v) in respuesta {
            //println("k = \(k)")
            //println("v = \(v)")

            registro["nombre"] = v["Nombre"] as? String
            registro["libre"] = v["libre"] as? String
            registro["tipo"] = v["Tipo"] as? String
            let vueltas : Int = v["vueltas"] as! Int
            registro["vueltas"] = String(vueltas)
            
            self.lista.append(registro)
        }
        //println("listaLlegadas : \(self.lista)")
        
        self.listaUITableView.clearsContextBeforeDrawing = true        // limpiar uitableview
        self.listaUITableView.reloadData()
    }

    
    func didReceiveResponse_listaReservas(respuesta: [String : AnyObject]) {
        
        self.lista = []
        var registro : [String : AnyObject] = [:]
        //println("Lista reservas : \(respuesta)")
        
        for (k,v) in respuesta {
            registro["numero"] = v["numero"] as! Int
            registro["nombre"] = v["base"] as! String
            registro["hora_prevista"] = v["hora_prevista"] as! String
            registro["hora_reserva"] = v["hora_reserva"] as! String
            registro["fuera"] = v["fuera"] as! Bool
            registro["tipo"] = v["tipo"]
            self.lista.append(registro)
        }
    
        // ordenacion de las reservas por el numero
    
        self.lista.sortInPlace({(primero : [String:AnyObject], segundo : [String:AnyObject]) -> Bool in
                return   segundo["numero"] as! Int > primero["numero"] as! Int
            })
        //println(" ORDENADO : \(self.lista)")
        
        self.listaUITableView.clearsContextBeforeDrawing = true
        self.listaUITableView.reloadData()
    }
    
    func didReceiveResponse_salida(respuesta: [String : String]) {
        
        
        if respuesta["error"] == "no es posible" {
            let alerta = UIAlertController(title: "EEEEPPPPPP", message: "No puede salir una barca si no hay disponibles", preferredStyle: UIAlertControllerStyle.Alert)
            
            let OkAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
            
            alerta.addAction(OkAction)
            
            self.presentViewController(alerta, animated: true, completion: nil)
 
        } else {
            let nombre = respuesta["nombre"]!
            let alerta = UIAlertController(title: "SALIDA", message: "Salida de una \(nombre)", preferredStyle: UIAlertControllerStyle.Alert)
            
            let OkAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
            
            alerta.addAction(OkAction)
            
            self.presentViewController(alerta, animated: true, completion: nil)

            self.actualizarContadorBarcasFuera()
        }
        
    }

    func didReceiveResponse_llegada(respuesta: [String : String]) {
        //println(respuesta)
        if respuesta["error"] == "1" {
            let alerta = UIAlertController(title: "EEEEPPPPPP", message: "Error en la contabilización de la llegada de la barca", preferredStyle: UIAlertControllerStyle.Alert)
            
            let OkAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
            
            alerta.addAction(OkAction)
            
            self.presentViewController(alerta, animated: true, completion: nil)
            
        } else {
            let nombre = respuesta["nombre"]!
            let alerta = UIAlertController(title: "LLEGADA", message: "Llegada de una \(nombre)", preferredStyle: UIAlertControllerStyle.Alert)
            
            let OkAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
            
            alerta.addAction(OkAction)
            
            self.presentViewController(alerta, animated: true, completion: nil)
            
            self.actualizarContadorBarcasFuera()
        }
        
    }
    
    func didReceiveResponse_barcasFuera(responseObject : [String : [Int]]) {
        
        let fuera : [Int] = responseObject["fuera"]!
        self.numeroRiosFueraUILAbel.text = String(fuera[0])
        self.numeroElectricasFueraUILabel.text = String(fuera[1])
        self.numeroWhalysFueraUILabel.text = String(fuera[2])
        self.numeroGoldsFueraUILabel.text = String(fuera[3])
    }
    
    func didReceiveResponse_siguienteBarcaLlegar(respuesta: [String : String]) {
        //println("respuesta: \(respuesta)")
        self.siguienteBarcaRioUiLabel.text = respuesta["rio"]
        self.siguienteBarcaElectricaUILabel.text = respuesta["electrica"]
        self.siguienteBarcaWhalyUiLabel.text = respuesta["whaly"]
        self.siguienteBarcaGoldUILabel.text = respuesta["gold"]
    }
    
    func didReceiveResponse_salidaReserva(mensaje: String, tipo: Int) {
        if mensaje == "OK" {
            //var alerta = UIAlertController(title: "FUERAAAA", message: "La reserva se ha eliminado de la lista", preferredStyle: UIAlertControllerStyle.Alert)
            
            //let OkAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
            
            //alerta.addAction(OkAction)
            
            //self.presentViewController(alerta, animated: true, completion: nil)
            
            // Actualizamos los contadores de las reservas que faltan
            switch tipo{
            case 1:
                let num : Int? = Int(self.numeroReservasRioUILabel.text!)
                self.numeroReservasRioUILabel.text = String(num! - 1)
                self.tiempoEsperaUILabel.text =  String(Int(self.numeroReservasRioUILabel.text!)! * 5)
            case 2:
                let num : Int? = Int(self.numeroReservasElectricaUILabel.text!)
                self.numeroReservasElectricaUILabel.text = String(num! - 1)
            case 3:
                let num : Int? = Int(self.numeroReservasWhalyUILabel.text!)
                self.numeroReservasWhalyUILabel.text = String(num! - 1)
            default:
                let num : Int? = Int(self.numeroReservasGoldUILabel.text!)
                self.numeroReservasGoldUILabel.text = String(num! - 1)
            }
            
            
        } else if mensaje == "KO" {
            var alerta = UIAlertController(title: "PROBLEMMMM", message: "No puede salir ls reserva de la lista", preferredStyle: UIAlertControllerStyle.Alert)
            
            let OkAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
            
            alerta.addAction(OkAction)
            
            self.presentViewController(alerta, animated: true, completion: nil)
            
        }
    }
    
    func didReceiveResponse_reservasPorDar(respuesta : [String : AnyObject]) {
        
        var contenido : Dictionary<String,String>
        if respuesta["mensaje"] as! String == "OK" {
            contenido = respuesta["contenido"] as! Dictionary<String,String>
            self.numeroReservasRioUILabel.text = contenido["rio"]
            self.tiempoEsperaUILabel.text = String(Int(self.numeroReservasRioUILabel.text!)! * 5)
            self.numeroReservasElectricaUILabel.text = contenido["electrica"]
            self.numeroReservasWhalyUILabel.text = contenido["whaly"]
            self.numeroReservasGoldUILabel.text = contenido["gold"]
    
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
    }
    
    
    
    // IMPLEMENTO LOS METODOS DELEGADOS DE listaUITableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var contador = 0
        for var i = 0; i < self.lista.count; i++ {
            if self.lista[i]["fuera"] as! Int == 0 {
                contador += 1
            }
        }
        return contador
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell : ControlUITableViewCell = self.listaUITableView.dequeueReusableCellWithIdentifier("Cell") as! ControlUITableViewCell
        
        if self.lista[indexPath.row]["fuera"] as! Int == 0 {
            let numero : Int = self.lista[indexPath.row]["numero"] as! Int
            cell.numeroUILabelUITableViewCell.text = String(numero)
            cell.nombreUILabelUITableViewCell.text = self.lista[indexPath.row]["nombre"] as? String
            // hora  = self.lista[indexPath.row]["hora_prevista"]
            cell.tipoUILabelUITableViewCell.text = self.lista[indexPath.row]["hora_reserva"] as? String
            let fuera : Int = self.lista[indexPath.row]["fuera"] as! Int
            cell.libreUILabelUITableViewCell.text = String(fuera)
            //println("numero: \(numero)")
            
        }
        
        return cell
        
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //println("fila \(indexPath.row) seleccionada")
        
        //println(self.lista[indexPath.row])
        self.lista[indexPath.row]["fuera"] = 1
        
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        
        let tipo = self.lista[indexPath.row]["tipo"] as! Int
        //println("tipo: \(tipo)")
        webServiceControl.salidaReserva(self.lista[indexPath.row]["tipo"] as! Int, numero: self.lista[indexPath.row]["numero"] as! Int)
        
        // Elimino la reserva de la lista
        self.lista.removeAtIndex(indexPath.row)

    }

}

