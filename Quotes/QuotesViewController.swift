//
//  QoutesViewController.swift
//  Quotes
//
//  Created by Aleksey Nemychenkov on 21/01/2018.
//  Copyright © 2018 Aleksey Nemychenkov. All rights reserved.
//

import UIKit

protocol QuotesView: class {
    func updateQuotes()
    func showError(_ error: Error)
    func showLoader()
    func hideLoader()
}

class QuotesViewController: UIViewController {
    lazy var presenter: QuotesPresenter! = {
        let client = ExnessClient(urlString: "wss://quotes.exness.com:18400")
        let prefs = PrefsStorage()
        return QuotesPresenter(qoutesClient: client, prefs: prefs)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
        presenter.connect()
        NotificationCenter.default.addObserver(self, selector: #selector(appSuspended), name: .UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appResumed), name: .UIApplicationWillEnterForeground, object: nil)
    }
    
    @objc func appSuspended() {
        presenter.appSuspended()
    }
    
    @objc func appResumed() {
        presenter.appResumed()
    }
    
    override var isLoading: Bool {
        didSet {
            tableView.isHidden = isLoading
            editButton.isEnabled = !isLoading
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView()
        }
    }
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    @IBAction func editTouched(_ sender: Any) {
        let pairsListPresenter = presenter.pairsListPresenter()
        PairsListViewController.present(from: self, presenter: pairsListPresenter) { [unowned self] pairs in
            self.presenter.updatePairs(pairs)
        }
    }
}

extension QuotesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfQuotes()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell", for: indexPath) as! QuoteCell
        let quote = presenter.quote(at: indexPath.row)
        cell.symbolLabel.text = quote.symbol
        cell.bidAskLabel.text = quote.bidAsk
        cell.spreadLabel.text = quote.spread
        return cell
    }
}

extension QuotesViewController: UITableViewDelegate {
    
}

extension QuotesViewController: QuotesView {
    func updateQuotes() {
        tableView.reloadData()
    }
    
    func showError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func showLoader() {
        isLoading = true
    }
    
    func hideLoader() {
        isLoading = false
    }
}
