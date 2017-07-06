//
//  TrailerViewController.swift
//  Mock-Cinema
//
//  Created by MrDummy on 7/6/17.
//  Copyright © 2017 Huy. All rights reserved.
//

import UIKit

class TrailerViewController: UIViewController {

    @IBOutlet weak var wbvTrailer: UIWebView!
    @IBOutlet weak var loadTrailer: UIActivityIndicatorView!
    
    var urlTrailer: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://www.youtube.com/embed/\(urlTrailer!)")
        wbvTrailer.loadRequest(URLRequest(url: url!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
