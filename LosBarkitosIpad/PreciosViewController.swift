//
//  PreciosViewController.swift
//  LosBarkitosIpad
//
//  Created by chus on 9/12/14.
//  Copyright (c) 2014 Jesus Valladolid Rebollar. All rights reserved.
//

import UIKit


class PreciosViewController: UIViewController {

    

    var toPass : Int?

    @IBOutlet weak var cancelarUIButton: UIButton!
    @IBOutlet weak var precioUILabel: UILabel!
    @IBOutlet var preciosUIButton : [UIButton] = []
    @IBAction func btnPreciosUIButton(sender : UIButton) {
        self.precioUILabel.text = ""
        self.precioUILabel.text = "\(sender.tag)"
    }
    
 
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
