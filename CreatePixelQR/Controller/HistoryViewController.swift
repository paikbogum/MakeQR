//
//  HistoryViewController.swift
//  CreatePixelQR
//
//  Created by 백현진 on 12/18/24.
//

import UIKit


class HistoryViewController: UIViewController {
    
    let cellName = "HistoryTableViewCell"
    let cellReuseIdentifier = "HistoryTableViewCell"
    
    
    var historyItems: [QRHistory] = []
    
    @IBOutlet var historyView: HistoryView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerXib()
    }
    
    func registerXib() {
        let nibName = UINib(nibName: cellName, bundle: nil)
        historyView.historyTableView.register(nibName, forCellReuseIdentifier: cellReuseIdentifier)
        
        historyView.historyTableView.delegate = self
        historyView.historyTableView.dataSource = self
    }
    
    

    
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}
