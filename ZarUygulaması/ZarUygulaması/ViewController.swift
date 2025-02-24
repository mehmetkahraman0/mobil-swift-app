//
//  ViewController.swift
//  ZarUygulaması
//
//  Created by Mehmet Kahraman on 17.02.2025.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var zar_1: UILabel!
    @IBOutlet weak var zar_2: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func zarAtButton(_ sender: Any){
        zar_1.text = String(Int.random(in: 1...6))
        zar_2.text = String(Int.random(in: 1...6))
    }
}

