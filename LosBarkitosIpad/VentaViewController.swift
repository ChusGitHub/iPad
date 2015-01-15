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

    let RIO       = 0
    let ELECTRICA = 1
    let WHALY     = 2
    let GOLD      = 3
    
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
    var item = [Int: String]()
    // Array de los diccionarios de los vendedores
    var items = [[Int : String]]()
    
    var respuesta = [String : String]()
    
    
    var webService : webServiceCallAPI = webServiceCallAPI()
    var vendedores : NSArray = NSArray()
    
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
        case 1:
            self.barcaActual = RIO
            self.barcaActualString = "RIO"
        case 2:
            self.barcaActual = ELECTRICA
            self.barcaActualString = "ELÉCTRICA"
        case 3:
            self.barcaActual = WHALY
            self.barcaActualString = "WHALY"
        case 4:
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
    
        cargarValoresCon_appstate(inFile: "appstate")
        
        // Registro el cell class vendedorViewController
        self.vendedorUITableView.hidden = true
        
        // Si es posible pongo el nombre del vendedor
        
        
        // creo enlace a webService y digo que el protocolo soy yo mismo
        webService.delegate = self
        
        
    }
    
    override func viewWillAppear(animated: Bool) {

        var estadoActual = DataManager().getValueForKey("estado_venta", inFile: "appstate") as Int
        
        estadoVentaUITextField.text = "\(estadoActual)"
        estadoActual += 1
        // guardamos el valor actual del estado
        DataManager().setValueForKey("estado_venta", value: estadoActual, inFile: "appstate")
        
        
        // Miro si hay algo en toPrecioViewController
        if (self.toPreciosViewController != 0) {
            var alertController = UIAlertController(title: "TICKET", message: "Barca: \(self.barcaActualString!)\nPrecio: \(self.toPreciosViewController) €", preferredStyle: UIAlertControllerStyle.Alert)
            
            let ticketAction = UIAlertAction(title: "Ticket", style: UIAlertActionStyle.Default, handler: {action in self.accion()})
            let cancelAction = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Default, handler: nil)
            alertController.addAction(ticketAction)
            alertController.addAction(cancelAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }

        
    }

    func accion() {
        println("Estoy dentro de accion")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // Respuesta del webService de los vendedores del sistema
    func didReceiveResponse(respuesta: Dictionary<String, AnyObject >) { // : Dictionary) {
        println("Respuesta del servidor : \(respuesta)")
        for (k,v) in respuesta {
            if k as NSString == "error" && v as NSString == "si" {
                println("ERROR EN EL DICCIONARIO DEVUELTO")
                EXIT_FAILURE
            }
            // añado el vendedor al diccionario
            self.item = [:]
            self.item[v["codigo"] as Int] = v["nombre"] as? String
            self.items.append(item)

        }
        self.vendedorUITableView.reloadData()
    }
    
    
    func cargarValoresCon_appstate(inFile file: String) {
        
        self.vendedorUITextField.text = DataManager().getValueForKey("nombre_vendedor", inFile: file) as String?
        
    }

    
    // IMPLEMENTO LOS METODOS DELEGADOS DE vendedorUITableView
    func tableView(vendedorUITableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell: VendedorUITableViewCell = self.vendedorUITableView.dequeueReusableCellWithIdentifier("cell") as VendedorUITableViewCell
        
        
        cell.nombreVendedorUILabelCell.textColor = UIColor.grayColor()
        cell.codigoVendedorUILabelCell.textColor = UIColor.grayColor()
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(red: 1, green: 0.74, blue: 1, alpha: 1)
        } else {
            cell.backgroundColor = UIColor(red: 0.53, green: 0.64, blue: 1, alpha: 1)
        }
        
        let vendedor = self.items[indexPath.row]
        let codigo = Array(vendedor.keys)
        let nombre = Array(vendedor.values)
        cell.codigoVendedorUILabelCell.text = String(codigo[0])
        cell.nombreVendedorUILabelCell.text = nombre[0]
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let altura = tableView.frame.height
        return altura/(CGFloat) (self.items.count)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // recupero los valores de la celda
        let dictVendedor : [Int : String] = self.items[indexPath.row]
        let codigo = Array(dictVendedor.keys)
        let nombre = Array(dictVendedor.values)
        
        // Guardo el vendedor en el plist
        DataManager().setValueForKey("codigo_vendedor", value: Int(codigo[0]), inFile: "appstate")
        DataManager().setValueForKey("nombre_vendedor", value: String(nombre[0]), inFile: "appstate")
        
        // Pongo el nombre del vendedor en el uitextview
        self.vendedorUITextField.text = nombre[0]
        
        // Quito el uitableview de los  vendedores
        self.vendedorUITableView.hidden = true
        self.btnViewVendedoresUIButton.enabled = true
        self.items = []
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

