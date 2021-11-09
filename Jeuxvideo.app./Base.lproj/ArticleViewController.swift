//
//  ArticleViewController.swift
//  Jeuxvideo.app
//
//  Created by William Clement on 01/11/2021.
//

import UIKit
import WebKit

class ArticleViewController: UIViewController {

    @IBOutlet var label: UITextView!
    @IBOutlet var webView: WKWebView!
    
    var content: String!
     
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let intro: String = "<!DOCTYPE html><html lang='fr'><head><meta charset='UTF-8'/><meta name='viewport' content='width=device-width, initial-scale=1.0'><style media='screen'>iframe{width:100%; height:200px;} img{width:100%; height:auto;}</style></head><body>"
        let outro: String = "<br><p style='color: grey; font-size:17px;text-align:center;'>Un article Jeuxvideo.app</p></body></html>"
        
        print(intro+content+outro)
        webView.loadHTMLString(intro+content+outro, baseURL: nil)
    
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title:"Accueil", style: .done, target: self, action: #selector(rreturn))
    }

    @objc func rreturn(){
        navigationController?.popViewController(animated: true)
    }
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
