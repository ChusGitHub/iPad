//
//  FirstViewController.swift CLARO
//  LosBarkitosIpad
//
//  Created by Jesus Valladolid Rebollar on 14/11/14.
//  Copyright (c) 2014 Jesus Valladolid Rebollar. All rights reserved.
//
//import "VendedorUITableViewCell"
import UIKit

class VentaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource , WebServiceProtocolo {

    let RIO       = 1
    let ELECTRICA = 2
    let WHALY     = 3
    let GOLD      = 4
    
    var barcaActual : Int = -1
    var barcaActualString : String? = nil

    @IBOutlet weak var estadoVentaUITextField: UITextField!
    
    
    @IBOutlet weak var btnViewVendedoresUIButton: UIButton!
    
    @IBOutlet weak var vendedorUITextField: UITextField!
    
    @IBOutlet  weak var vendedorUITableView: UITableView!

    // Botones de las barcas

    @IBOutlet var btnBarcasIUButtonCollection: [UIButton]!
    
    
    // Items de vendedorUITableView
    // Diccionario que mantiene codigo y nombre de un vendedor
    var vendedor = [String: String]()
    // Array de los diccionarios de los vendedores
    var vendedores = [[String : String]]()
    
    var respuesta = [String : String]()
    
    // Este es el enlace a la clase que hace la conexion al servidor
    var webService : webServiceCallAPI = webServiceCallAPI()
  //  var vendedores : NSArray = NSArray()
    
    // Valor devuelto por el PreciosViewController
    // Todo correcto : Ok
    // algo falla : String con informacion de lo que falla
    var toPreciosViewController : Int = 0
    
    
    // LLamo a obtenerVendedores cuando se pulsa el boton del uitableview
    @IBAction func btnViewVendedoresIBAction(sender: AnyObject) {
        if self.vendedorUITableView.hidden == true {
            webService.obtenerVendedores()
            self.vendedorUITableView.hidden = false
            self.btnViewVendedoresUIButton.enabled = false
        } else {
            // Esto borrael UITableView
            //self.items = []
            //self.vendedorUITableView.reloadData()
            self.vendedorUITableView.hidden = true
            self.btnViewVendedoresUIButton.enabled = false
        }
     }
    
    
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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Compruebo si ya se ha abierto el dia
        println(DataManager().getValueForKey("vendedor", inFile: "appstate") as String)
    
        cargarValoresCon_appstate(inFile: "appstate")
        
        // Registro el cell class vendedorViewController
        self.vendedorUITableView.hidden = true
        
        // Si es posible pongo el nombre del vendedor
        
        
        // creo enlace a webService y digo que el protocolo soy yo mismo
        webService.delegate = self
        
        // PREPARO LA IMPRESORA DE TICKETS
        
    }
    
    func accionPrinters() {
        
    }
    
    
    override func viewWillAppear(animated: Bool) {

        var estadoActual = DataManager().getValueForKey("estado_venta", inFile: "appstate") as Int
        
        estadoVentaUITextField.text = "\(estadoActual)"
        estadoActual += 1
        // guardamos el valor actual del estado
        DataManager().setValueForKey("estado_venta", value: estadoActual, inFile: "appstate")
        
        
        // Miro si hay algo en toPrecioViewController - Esto quiere decir que se ha vendido una barca
        if (self.toPreciosViewController != 0) {
            var alertController = UIAlertController(title: "TICKET", message: "Barca: \(self.barcaActualString!)\nPrecio: \(self.toPreciosViewController) €", preferredStyle: UIAlertControllerStyle.Alert)
            
            let ticketAction = UIAlertAction(title: "Ticket", style: UIAlertActionStyle.Default, handler: {action in self.procesarTicket()})
            let cancelAction = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Default, handler: nil)
            alertController.addAction(ticketAction)
            alertController.addAction(cancelAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }

        
    }

    // Se ha vendido un ticket de barkito y hay que procesarlo
    // FALTA PONER EL PUNTOVENTA CUANDO SEA IMPLANTADO
    func procesarTicket() {
        // Introducir el ticket vendido en la BDD correspondiente
        // obtengo el vendedor que ha hecho la venta
        let codVend : Int = (DataManager().getValueForKey("vendedor", inFile: "appstate") as String).toInt()!
        println("codVend: \(codVend)")
        webService.entradaBDD_ventaBarca(self.barcaActual, precio: self.toPreciosViewController, puntoVenta: 1, vendedor: codVend)
        
        // Imprimir el ticket en la impresora de tickets
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////
    // Respuesta del webService de las llamadas al sistema
    func didReceiveResponse_listadoVendedores(respuesta: Dictionary<String, AnyObject >) {
        println("Respuesta del servidor : \(respuesta)")
        for (k,v) in respuesta {
            if k as NSString == "error" && v as NSString == "si" {
                println("ERROR EN EL DICCIONARIO DEVUELTO")
                EXIT_FAILURE
            }
            // añado el vendedor al diccionario
            self.vendedor = [:]
            let cod = v["codigo"] as Int
            let nom = v["nombre"] as String
            self.vendedor[String(cod)] = nom
            println("cod: \(cod)")
            println("nom: \(nom)")

            self.vendedores.append(self.vendedor)
            

        }
        self.vendedorUITableView.reloadData()
    }
    
    func didReceiveResponse_entradaBDD_ventaBarca(respuesta: [String : AnyObject]) {
        println("respuesta del servidor : \(respuesta)")
        for (k,v) in respuesta {
            if k as NSString == "error" && v as NSString == "si" {
                println("ERROR EN EL DICCIONARIO DEVUELTO")
                EXIT_FAILURE
            }
        }
    }
    
    func cargarValoresCon_appstate(inFile file: String) {
     
        let nombre_v : String = DataManager().getValueForKey("nombre_vendedor", inFile: file) as String
        let codigo_v  = DataManager().getValueForKey("vendedor", inFile: file) as String
        
        self.vendedorUITextField.text = nombre_v
        self.vendedor[codigo_v] = nombre_v
        
    }

    
    // IMPLEMENTO LOS METODOS DELEGADOS DE vendedorUITableView
    func tableView(vendedorUITableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vendedores.count
    }
    
    func tableView(VendedorUITableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell: VendedorUITableViewCell = self.vendedorUITableView.dequeueReusableCellWithIdentifier("cell") as VendedorUITableViewCell
        
        
        cell.nombreVendedorUILabelCell.textColor = UIColor.grayColor()
        cell.codigoVendedorUILabelCell.textColor = UIColor.grayColor()
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(red: 1, green: 0.74, blue: 1, alpha: 1)
        } else {
            cell.backgroundColor = UIColor(red: 0.53, green: 0.64, blue: 1, alpha: 1)
        }
        
        let vendedor = self.vendedores[indexPath.row]
        let codigo = Array(vendedor.keys)
        let nombre = Array(vendedor.values)
        cell.codigoVendedorUILabelCell.text = String(codigo[0])
        cell.nombreVendedorUILabelCell.text = nombre[0]
        
        // añado el codigo del vendedor al plist
        
        
        return cell
    }
    
    func tableView(VendedorUITableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let altura = VendedorUITableView.frame.height
        return altura/(CGFloat) (self.vendedores.count)
    }
    
    func tableView(VendedorUITableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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
        self.vendedorUITableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "seguePrecios" {
            let siguienteVC : PreciosViewController = segue.destinationViewController as PreciosViewController
            siguienteVC.toTipo = self.barcaActual
            siguienteVC.toTipoString = self.barcaActualString
        }
    }
    
}

