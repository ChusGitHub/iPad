//
//  marinaferryViewController.swift
//  LosBarkitosIpad
//
//  Created by Jesús Valladolid Rebollar on 8/12/17.
//  Copyright © 2017 Jesus Valladolid Rebollar. All rights reserved.
//

import UIKit

class marinaferryViewController: UIViewController {
    
    @IBOutlet weak var partGrupView: UIView!
    @IBOutlet weak var partButton: UIButton!
    @IBOutlet weak var gruposButton: UIButton!
    @IBOutlet weak var precioPartView: UIView!
    @IBOutlet weak var precioGruposView: UIView!
    
    @IBAction func partPush(_ sender: UIButton) {
        fadeOut(view: self.precioGruposView)
        fadeIn(view: self.precioPartView)
    }
    @IBAction func gruposPush(_ sender: UIButton) {
        fadeIn(view: self.precioGruposView)
        fadeOut(view: self.precioPartView)
    }
    
    ////////////////////////////////////////////////////////////////////////
    
    /// Fade in a view with a duration
    ///
    /// Parameter duration: custom animation duration
    func fadeIn(withDuration duration: TimeInterval = 1.0, view : UIView) {
        UIView.animate(withDuration: duration, animations: {
            view.alpha = 1.0
        })
    }
    /// Fade out a view with a duration
    ///
    /// - Parameter duration: custom animation duration
    func fadeOut(withDuration duration: TimeInterval = 1.0, view: UIView) {
        UIView.animate(withDuration: duration, animations: {
            view.alpha = 0.0
        })
    }
    /////////////////////////////////////////////////////////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
        self.precioPartView.alpha = 0
        self.precioGruposView.alpha = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

