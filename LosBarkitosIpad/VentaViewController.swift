//
//  FirstViewController.swift CLARO
//  LosBarkitosIpad
//
//  Created by Jesus Valladolid Rebollar on 14/11/14.
//  Copyright (c) 2014 Jesus Valladolid Rebollar. All rights reserved.
//
//import "VendedorUITableViewCell"

import UIKit

/*
protocol PrinterConnectivityDelegate {
    func connectedPrinterDidChangeTo(printer : Printer)
}*/


class VentaViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, WebServiceProtocoloVentas {


    let RIO       = 1
    let ELECTRICA = 2
    let WHALY     = 3
    let GOLD      = 4
    
    let VENDEDOR =  1
    let VENTAS =    2

    
    @IBOutlet weak var btnViewVendedoresUIButton: UIButton!
    
    @IBOutlet weak var vendedorUITextField: UITextField!
    
    @IBOutlet  weak var vendedorUITableView: UITableView!
    
    // Propiedades de la tabla de las ventas
    
   // @IBOutlet weak var ventasUITableView: UITableView!
    
    // Botones de las barcas

    @IBOutlet var btnBarcasIUButtonCollection: [UIButton]!
    
    @IBOutlet weak var infoImpresoraUILabel: UILabel!
    
    @IBOutlet weak var txtPasswordUITextField: UITextField!
    
    @IBOutlet weak var btnAceptarUIButton: UIButton!
    
    @IBOutlet weak var passwordUIView: UIView!
    
    @IBOutlet weak var infoAdministradoUILabel: UILabel!
    
    @IBOutlet weak var tipoListaUIView: UIView!
    
    @IBOutlet weak var numeroBarcasUILabel: UILabel!
    
    //var  PUNTO_VENTA : Int  = DataManager().getValueForKey("punto_venta_codigo", inFile: "appstate") as Int
    
    //var PUNTO_VENTA_NOMBRE : String = DataManager().getValueForKey("punto_venta", inFile: "appstate") as String
    var PUNTO_VENTA : Int = 2
    var PUNTO_VENTA_NOMBRE : String = "LosBarkitos"

    var barcaActual : Int = -1
    var barcaActualString : String? = nil

    
    // Este es el enlace a la clase que hace la conexion al servidor
    var webService : webServiceCallAPI = webServiceCallAPI()
    var conec : Conectividad = Conectividad()

    // Items de vendedorUITableView
    // numero de ticket en BDD
    var numeroTicket : Int = 0
    // ticket si es negro o no
    var negro : Bool = false
    // Diccionario que mantiene codigo y nombre de un vendedor
    var vendedor = [String : String]()
    // Diccinario que mantiene los datos de una venta
    var venta : [String : String] = [:]
    // Array de los diccionarios de los vendedores
    var vendedores = [[String : String]]()
    //var ventas  = [[String : String]]()
    var ventas = [[String:String]]()
    var ventasOrdenadas = [[String:String]]()
    
    var respuesta = [String : String]()
    
     
    // Valor devuelto por el PreciosViewController
    // Todo correcto : Ok
    // algo falla : String con informacion de lo que falla
    var toPreciosViewController : Int = 0
    
    // Valor devuelto por el tipoReservaViewController
    var totipoReservaViewControllerTipo : Int = 0
    var totipoReservaViewControllerPV : Int = 0
    var tovueltaReservaViewController : Bool = false
    
    var arrayPort : NSArray = ["Standard"]
    var arrayFunction : NSArray = ["Sample Receipt"]
    var arraySensorActive : NSArray = ["Hight"]
    var arraySensorActivePickerContents : NSArray = ["High When Drawer Open"]
    
    var selectedPort : NSInteger = 0
    var selectedSensorActive : NSInteger = 0
    
    var foundPrinters : NSArray = []
    var lastSelectedPortName : NSString = ""
    var p_portName : NSString = ""
    var p_portSettings : NSString = ""
    
    var gestion : String = "usuario"
    let datosUIPickerView = ["Lista Baja", "Lista Media", "Lista Alta"]
    
    var totalBarcas : [Int] = [0,0,0,0]
    var totalEuros : Int = 0
    
    var reservas : [Int] = [0,0,0,0]
    
    //let conectado : Conectividad?


    
    // LLamo a obtenerVendedores cuando se pulsa el boton del uitableview
    @IBAction func btnViewVendedoresIBAction(sender: AnyObject) {
        if self.vendedorUITableView.hidden == true {
            webService.obtenerVendedores()
            self.vendedorUITableView.hidden = false
            self.btnViewVendedoresUIButton.enabled = false
        } else {
            self.vendedorUITableView.hidden = true
            self.btnViewVendedoresUIButton.enabled = false
        }
     }
    
  /*  @IBAction func btnRefrescarVentas(sender: UIButton) {
        
        // limpiar uitableview
        self.ventasUITableView.clearsContextBeforeDrawing = true
        webService.obtenerVentas()
    }*/
    
    @IBAction func btnBarcasUIButtonTouch(sender: UIButton) {

        switch sender.tag {
        case 0:
            self.barcaActual = RIO
            self.barcaActualString = "RIO"
        case 1:
            self.barcaActual = ELECTRICA
            self.barcaActualString = "ELÉCTRICA"
        case 2:
            self.barcaActual = WHALY
            self.barcaActualString = "WHALY"
        case 3:
            self.barcaActual = GOLD
            self.barcaActualString = "GOLD"
        default:
            self.barcaActual = -1
            self.barcaActualString = nil
        }
    }
    
    
    @IBAction func btnGestionUIbutton(sender: UIButton) {
        self.txtPasswordUITextField.text = ""
        if self.passwordUIView.hidden == true {
            self.passwordUIView.hidden = false
        } else {
            self.passwordUIView.hidden = true
        }
    }
    
    
    @IBAction func btnAceptarGestionPushButton(sender: UIButton) {
        
        if self.txtPasswordUITextField.text == "Otisuhc0" {
            self.gestion = "administrador"
            self.infoAdministradoUILabel.text = "Administrador"
            self.tipoListaUIView.hidden = false
            self.passwordUIView.hidden = true
            self.resignFirstResponder()
        } else {
            self.resignFirstResponder()
            let alerta = UIAlertController(title: "PASS INCORRECTO", message: "El password es incorrecto. No tiene privilegios de administrador", preferredStyle: UIAlertControllerStyle.Alert)
            let aceptarAction = UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Cancel, handler: {action in self.noAdministrador()} )
            alerta.addAction(aceptarAction)
            self.presentViewController(alerta, animated: true, completion: nil)
        }
    }
    
    @IBAction func lista1ButtonListaUIView(sender: AnyObject) {
        DataManager().setValueForKey("lista_precio", value: String("1"), inFile: "appstate")
        self.tipoListaUIView.hidden = true
    }
    @IBAction func lista2ButtonListaUiView(sender: AnyObject) {
        DataManager().setValueForKey("lista_precio", value: String("2"), inFile: "appstate")
        self.tipoListaUIView.hidden = true
    }
    @IBAction func lista3ButtonListaUIView(sender: AnyObject) {
        DataManager().setValueForKey("lista_precio", value: String("3"), inFile: "appstate")
        self.tipoListaUIView.hidden = true
    }

    
    @IBAction func imprimirTotalVentas(sender: UIButton) {
        
        let totalImpreso : Bool = imprimirTotal()
        
        if !totalImpreso {
            var alertaNoImpresora = UIAlertController(title: "SIN IMPRESORA", message: "No hay una impresora conectada. Intenta establecer nuevamente la conexión (Ajustes -> Bluetooth->Seleccionar Impresora TSP)", preferredStyle: UIAlertControllerStyle.Alert)
            
            let OkAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
            
            alertaNoImpresora.addAction(OkAction)

        }
        
    }
    
    @IBAction func reservasUIButton(sender: UIButton) {
        webService.delegate = self
        
        /*var alertController = UIAlertController(title: "RESERVA", message: "Clic en el tipo de barco para reservar", preferredStyle: UIAlertControllerStyle.Alert)
        let rioAction = UIAlertAction(title: "Rio", style: UIAlertActionStyle.Default, handler: {action in self.webService.obtenerNumeroReserva(self.RIO, pv: 2)})
        let electricaAction = UIAlertAction(title: "Eléctrica", style: UIAlertActionStyle.Default, handler: {action in self.webService.obtenerNumeroReserva(self.ELECTRICA, pv: 2)})
        let whalyAction = UIAlertAction(title: "Whaly", style: UIAlertActionStyle.Default, handler: {action in self.webService.obtenerNumeroReserva(self.WHALY, pv: 2)})
        let goldAction = UIAlertAction(title: "Gold", style: UIAlertActionStyle.Default, handler: {action in self.webService.obtenerNumeroReserva(self.GOLD, pv: 2)})

        alertController.addAction(rioAction)
        alertController.addAction(electricaAction)
        alertController.addAction(whalyAction)
        alertController.addAction(goldAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)*/

    }
    
    func noAdministrador () {
        self.gestion = "usuario"
        self.passwordUIView.hidden = true
        self.infoAdministradoUILabel.text = "Usuario"
    }
    
    required init(coder aDecoder: NSCoder) {
    
        super.init(coder: aDecoder)
        webService.delegate = self
     //   if self.PUNTO_VENTA == 0 {
      //      self.PUNTO_VENTA  = DataManager().getValueForKey("punto_venta_codigo", inFile: "appstate") as Int
        //}
        //if self.PUNTO_VENTA_NOMBRE == "" {
          //  self.PUNTO_VENTA_NOMBRE  = DataManager().getValueForKey("punto_venta", inFile: "appstate") as String
        //}
      //  webService.obtenerNumero()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // miro la conectividad del ipad
        if conec.estaConectado() == true {
            println("Esta conectado")
        } else {
            println("No está conectado")
        }
        
        self.passwordUIView.hidden = true
        self.tipoListaUIView.hidden = true
        
        
       // NSNotificationCenter.defaultCenter().addObserver(self, selector: {action in accessoryConected}, name: EAAccessoryDidConnectNotification, object: nil)
        
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: {action in accessoryDisconnected}, name: EAAccessoryDidConnectNotification, object: nil)
        
        // Compruebo si ya se ha abierto el dia
        println(DataManager().getValueForKey("vendedor", inFile: "appstate") as! String)
    
        //cargarValoresCon_appstate(inFile: "appstate")
        
        // Registro el cell class vendedorViewController
        self.vendedorUITableView.hidden = true
        
        // Si es posible pongo el nombre del vendedor
        self.vendedorUITextField.text = DataManager().getValueForKey("nombre_vendedor", inFile: "appstate") as! String
        
        
        // creo enlace a webService y digo que el protocolo soy yo mismo
        webService.delegate = self
        
        txtPasswordUITextField.delegate = self
        
        //webService.obtenerNumero()

    }
    
    override func viewWillAppear(animated: Bool) {
        
        // Miro si hay algo en toPrecioViewController - Esto quiere decir que se ha vendido una barca
        if (self.toPreciosViewController != 0) {
            self.webService.obtenerNumero(self.toPreciosViewController)
        }
       
        // Miro si vuelve de la pantalla de reservas
        if self.tovueltaReservaViewController {
            self.webService.obtenerNumeroReserva(self.totipoReservaViewControllerTipo, pv: self.totipoReservaViewControllerPV)
            self.tovueltaReservaViewController = false
        }
        
        // Miro si hay impresora conectada
        self.setupImpresora()
       
        self.infoAdministradoUILabel.text = "Usuario"
        
        let total : Int = DataManager().getValueForKey("total_barcas", inFile: "appstate") as! Int
       
        self.numeroBarcasUILabel.text = String(total)
        
    }
    

    
    // Mira si está la impresora conectada:
    // True -> conectada
    // False -> no hay impresora
    func setupImpresora() -> Bool {
        
        self.foundPrinters = SMPort.searchPrinter("BT:")
        
        if self.foundPrinters.count > 0 {// Hay impresora conectada
            
            println(self.foundPrinters.count)
            var portInfo : PortInfo = self.foundPrinters.objectAtIndex(0) as! PortInfo
           
            self.lastSelectedPortName = portInfo.portName
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.setPortName(portInfo.portName)
            appDelegate.setPortSettings(arrayPort.objectAtIndex(0) as! NSString)
            var p_portName : NSString = appDelegate.getPortName()
            var p_portSettings : NSString = appDelegate.getPortSettings()
            self.infoImpresoraUILabel.text = portInfo.portName
            
            println("Impresoras: \(self.foundPrinters.objectAtIndex(0))" )
            return true 
        }
        else { // No hay ninguna impresora conectada
            var alertaNoImpresora = UIAlertController(title: "SIN IMPRESORA", message: "No hay una impresora conectada. Intenta establecer nuevamente la conexión (Ajustes -> Bluetooth->Seleccionar Impresora TSP)", preferredStyle: UIAlertControllerStyle.Alert)
            
            let OkAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
            
            alertaNoImpresora.addAction(OkAction)
            
            self.presentViewController(alertaNoImpresora, animated: true, completion: nil)
            return false
            
        }

    }


    // Se ha vendido un ticket de barkito y hay que procesarlo
    // FALTA PONER EL PUNTOVENTA CUANDO SEA IMPLANTADO
    func procesarTicket() {
        // Si se consigue imprimir el ticket se introduce en la BDD, sino da una alerta
        let ticketImpreso = self.imprimirTicket()
        if (ticketImpreso == true) {

            // Introducir el ticket vendido en la BDD correspondiente
            // obtengo el vendedor que ha hecho la venta
            let codVend : Int = (DataManager().getValueForKey("vendedor", inFile: "appstate") as! String).toInt()!
            println("codVend: \(codVend)")
            // Se inserta la venta de la barca en HEROKU
            webService.entradaBDD_ventaBarca(self.numeroTicket,
                                             tipo: self.barcaActual,
                                             precio: self.toPreciosViewController,
                                             puntoVenta: PUNTO_VENTA ,
                                             vendedor: codVend,
                                             negro: self.negro)
            var total : Int = (DataManager().getValueForKey("total_barcas", inFile: "appstate")) as! Int
            total += 1
            DataManager().setValueForKey("total_barcas", value: total, inFile: "appstate")
            self.numeroBarcasUILabel.text = String(total)
            // Se inserta la venta de la barca en SQLITE
           // var insertado = insertaViajeSQLite()
            
        } else {
            
            self.dismissViewControllerAnimated(true, completion: {
                var alertaNOInsercionBDD = UIAlertController(title: "SIN IMPRESORA-NO HAY TICKET", message: "No hay una impresora conectada. Intenta establecer nuevamente la conexión (Ajustes -> Bluetooth->Seleccionar Impresora TSP) - No se ha insertado en la BDD", preferredStyle: UIAlertControllerStyle.Alert)
            
                let OkAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
            
                alertaNOInsercionBDD.addAction(OkAction)
            
                self.presentViewController(alertaNOInsercionBDD, animated: true, completion: nil)
            
            })
        }
    }
    
    func imprimirTicket() -> Bool? {
        
        if self.setupImpresora() {
        
            self.foundPrinters = SMPort.searchPrinter("BT:")
            
        
            var portInfo : PortInfo = self.foundPrinters.objectAtIndex(0) as! PortInfo
            self.lastSelectedPortName = portInfo.portName
        
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.setPortName(portInfo.portName)
            appDelegate.setPortSettings(arrayPort.objectAtIndex(0) as! NSString)
            var p_portName : NSString = appDelegate.getPortName()
            var p_portSettings : NSString = appDelegate.getPortSettings()
            
            let vend : String = DataManager().getValueForKey("nombre_vendedor", inFile: "appstate") as! String
            let punto : String = DataManager().getValueForKey("punto_venta", inFile: "appstate") as! String
            let precio : Int = self.toPreciosViewController
            let numero : Int = self.numeroTicket
            let barca : String = self.barcaActualString!
            let diccParam : [String : AnyObject] = [
                "numero"      : numero,
                "punto_venta" : punto,
                "precio"      : precio,
                "barca"       : barca,
                "vendedor"    : vend
            ]

            let ticketImpreso : Bool = PrintSampleReceipt3Inch(p_portName, p_portSettings, diccParam)
            
            // Trataré de desconectar el puerto
    
            return ticketImpreso
        } else {
            return false
        }
    }
    
    func imprimirReserva(PV : String) {
        if setupImpresora() {
            self.foundPrinters = SMPort.searchPrinter("BT:")
            
            
            var portInfo : PortInfo = self.foundPrinters.objectAtIndex(0) as! PortInfo
            self.lastSelectedPortName = portInfo.portName
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.setPortName(portInfo.portName)
            appDelegate.setPortSettings(arrayPort.objectAtIndex(0) as! NSString)
            var p_portName : NSString = appDelegate.getPortName()
            var p_portSettings : NSString = appDelegate.getPortSettings()
            
            let reservaImpresa : Bool = PrintSampleReceipt3Inch(p_portName, p_portSettings, PV, self.reservas)
        }
    }
    
    func imprimirTotal() -> Bool {
        
        if self.setupImpresora() {
            
            self.foundPrinters = SMPort.searchPrinter("BT:")
            
            
            var portInfo : PortInfo = self.foundPrinters.objectAtIndex(0) as! PortInfo
            self.lastSelectedPortName = portInfo.portName
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.setPortName(portInfo.portName)
            appDelegate.setPortSettings(arrayPort.objectAtIndex(0) as! NSString)
            var p_portName : NSString = appDelegate.getPortName()
            var p_portSettings : NSString = appDelegate.getPortSettings()
            
            // AQUI ESTAN LOS DATOS A IMPRIMIR
            
            prepararImpresion()
            
            // Trataré de desconectar el puerto
            
            return true
        } else {
            return false
        }

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //////////////////////////////////////////////////////////////////////////////////////////////
    // Respuesta del webService de las llamadas al sistema
    /////////////////////////////////////////////////////////////////////////////////////////////
    
    
    func didReceiveResponse_listadoVendedores(respuesta: Dictionary<String, AnyObject >) {
        println("Respuesta del servidor : \(respuesta)")
        for (k,v) in respuesta {
            if k as NSString == "error" && v as! NSString == "si" {
                println("ERROR EN EL DICCIONARIO DEVUELTO")
                EXIT_FAILURE
            }
            // añado el vendedor al diccionario
            self.vendedor = [:]
            let cod = v["codigo"] as! Int
            let nom = v["nombre"] as! String
            self.vendedor[String(cod)] = nom
            println("cod: \(cod)")
            println("nom: \(nom)")

            self.vendedores.append(self.vendedor)
        }
        self.vendedorUITableView.clearsContextBeforeDrawing = true
        self.vendedorUITableView.reloadData()
    }
    
    func didReceiveResponse_entradaBDD_ventaBarca(respuesta: [String : AnyObject]) {
        println("respuesta del servidor : \(respuesta)")
        for (k,v) in respuesta {
            if k as NSString == "error" && v as! NSString == "si" {
                println("ERROR EN EL DICCIONARIO DEVUELTO")
                EXIT_FAILURE
            }
         }
        //self.ventasUITableView.clearsContextBeforeDrawing = true
        //webService.obtenerVentas()
    }
    
    /*func didReceiveResponse_listadoVentas(respuesta: [String : AnyObject]) {
        self.ventas = []
        println("respuesta del servidor(respuesta) : \(respuesta)")
        for (k,v) in respuesta {
            if k as NSString == "error" && v as NSString == "si" {
                println("ERROR EN EL DICCIONARIO DEVUELTO")
                EXIT_FAILURE
            
            } else if k as NSString == "numero_viajes" {
                    self.numeroBarcasUILabel.text = String(v as Int)
            } else {
                println("k: \(k), v: \(v)")
                let n : Int = v["numero"] as Int
                self.venta["numero"] = String(n)
                self.venta["nombre"] = v["nombre_vendedor"] as? String
                let p : Int = v["precio"] as Int
                self.venta["precio"] = String(p)
                self.venta["base"]   = v["punto_venta"] as? String
                self.venta["fecha"]  = v["fecha"] as? String
                self.venta["tipo"]   = v["tipo"] as? String
                self.ventas.append(self.venta)
            }
        }
        ordenarVentas()
        println("ventas ordenadas : \(self.ventas)")
        self.ventasUITableView.clearsContextBeforeDrawing = true        // limpiar uitableview
        self.ventasUITableView.reloadData()
    }*/
    
    func didReveiveResponse_numeroTicket(respuesta: [String : AnyObject]) {
        println("respuesta del servidor(respuesta) : \(respuesta)")
        for (k,v) in respuesta {
            if k as NSString == "error" && v as! NSString == "si" {
                println("ERROR EN EL DICCIONARIO DEVUELTO : \(v)")
                EXIT_FAILURE
            } else {
                if k as NSString == "numero" {
                    self.numeroTicket = v as! Int
                }
                if k as NSString == "negro" {
                    if v  as! String == "si" {
                        self.negro = true
                    } else {
                        self.negro = false
                    }
                }
            }
        }
        self.procesarTicket()
    }
    
    func prepararImpresion() {
        webService.totalBarcas(self.PUNTO_VENTA)
        
        println(self.totalBarcas)
        let totalBarcas : Int = self.totalBarcas[0] + self.totalBarcas[1] + self.totalBarcas[2] + self.totalBarcas[3]
    }
    func didReceiveResponse_totalBarcas(respuesta : [String : Int]) {
        
        println("respuesta del servidor : Total Barcas :\(respuesta)")
        for (k,v) in respuesta {
            if k as NSString == "error" && v as Int == 1 {
                println("Error en el diccionario devuelto : \(v)")
                EXIT_FAILURE
            } else {
                self.totalBarcas = Array(respuesta.values)
            }
        }
        webService.totalEuros(self.PUNTO_VENTA)
    }
    
    func didReceiveResponse_totalEuros(respuesta : [String : Int]) {
        
        println("respuesta del servidor : Total Euros :\(respuesta)")
        for (k,v) in respuesta {
            if k == "total" {
                self.totalEuros = v as Int
            } else {
                self.totalEuros = 0
            }
        }
        
        let formatoFecha = NSDateFormatter()
        formatoFecha.dateFormat = "dd-MM-yyyy"
        let dia = formatoFecha.stringFromDate(NSDate())
        
        let diccParam : [String : AnyObject] = [
            "p_venta"   : self.PUNTO_VENTA_NOMBRE,
            "rio"       : self.totalBarcas[0],
            "electrica" : self.totalBarcas[1],
            "whaly"     : self.totalBarcas[2],
            "gold"      : self.totalBarcas[3],
            "dia"       : dia,
            "euros"     : self.totalEuros,
            "total"     : totalBarcas
        ]
        
        let ticketImpreso : Bool = PrintTotal3Inch(p_portName, p_portSettings, diccParam)
    }
    
    func didReceiveResponse_reserva(respuesta : [String : AnyObject]) {
        println("respuesta del servidor : \(respuesta)")
        var dicc : [String : AnyObject]
        var PV : String = ""
        self.reservas = [0,0,0,0]
        for (k,v) in respuesta {
            if k == "PV" {
                PV = v as! String
            }
            if k == "numero" {
                self.reservas = v as! [Int]
            }
        }
        imprimirReserva(PV)
    }

    
    func cargarValoresCon_appstate(inFile file: String) {
     
        let nombre_v : String = DataManager().getValueForKey("nombre_vendedor", inFile: file) as! String
        let codigo_v  = DataManager().getValueForKey("vendedor", inFile: file) as! String
        
        self.vendedorUITextField.text = nombre_v
        self.vendedor[codigo_v] = nombre_v
        
    }

    
    // IMPLEMENTO LOS METODOS DELEGADOS DE vendedorUITableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == VENDEDOR {
            return self.vendedores.count
        } else {
            return self.ventas.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
       // if tableView.tag == VENDEDOR {
            var cell: VendedorUITableViewCell = self.vendedorUITableView.dequeueReusableCellWithIdentifier("cell") as! VendedorUITableViewCell
        
        
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
            
        }/* else {
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
    }*/
    
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "seguePrecios" {
            let siguienteVC : PreciosViewController = segue.destinationViewController as! PreciosViewController
            siguienteVC.toTipo = self.barcaActual
            siguienteVC.toTipoString = self.barcaActualString
        }
        if segue.identifier == "segueTipoReserva" {
            let siguienteVC : tipoReservaUIViewController = segue.destinationViewController as! tipoReservaUIViewController
            
        }
    }
    
    func ordenarVentas() {
       // println("SIN ORDENAR : \(self.ventas)")
        self.ventas.sort({(primero : [String:String], segundo : [String:String]) -> Bool in
            return primero["numero"]?.toInt() > segundo["numero"]?.toInt()
        })
        //(println(" ORDENADO : \(self.ventas)")
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.gestion = "administrador"
        self.infoAdministradoUILabel.text = "Administrador"
        self.tipoListaUIView.hidden = false
        self.passwordUIView.hidden = true
        self.resignFirstResponder()

        return true
    }
    
    
    // TRABAJO CON LA BDD SQLITE
    func insertaViajeSQLite() -> Bool {
        
        var viaje : Viaje = Viaje()
        let formatoFecha = NSDateFormatter()
        formatoFecha.dateFormat = "dd-MM-yyyy hh:mm:ss"
        let fecha = formatoFecha.stringFromDate(NSDate())
        
        viaje.fecha = fecha
        viaje.barca = self.barcaActual
        viaje.blanco = false
        viaje.vendedor =  (DataManager().getValueForKey("vendedor", inFile: "appstate") as! String).toInt()!
        viaje.punto_venta = (DataManager().getValueForKey("punto_venta_codigo", inFile: "appstate") as! Int)
        
        var estaInsertadoSQLITE = ManejoSQLITE.instance.insertaViajeSQLITE(viaje)
        return estaInsertadoSQLITE
    }

}
