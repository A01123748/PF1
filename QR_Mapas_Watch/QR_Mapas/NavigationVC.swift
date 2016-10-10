//
//  NavigationVC.swift
//  QR_Mapas
//
//  Created by Eliseo Fuentes on 10/9/16.
//  Copyright © 2016 Eliseo Fuentes. All rights reserved.
//

import UIKit

class NavigationVC: UIViewController,UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    var urls = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        webView.delegate = self
        webView.loadRequest(NSURLRequest(URL: NSURL(string: urls)!))
    }
}
