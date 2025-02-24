//
//  ViewController.swift
//  SayısalLoto
//
//  Created by Mehmet Kahraman on 17.02.2025.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    @IBOutlet weak var label6: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func createButton(_ sender: Any) {
        label1.text = String(Int.random(in: 1...49))
        label2.text = String(Int.random(in: 1...49))
        label3.text = String(Int.random(in: 1...49))
        label4.text = String(Int.random(in: 1...49))
        label5.text = String(Int.random(in: 1...49))
        label6.text = String(Int.random(in: 1...49))
    }
    
}

