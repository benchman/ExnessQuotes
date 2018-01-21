//
//  QoutesViewController.swift
//  Quotes
//
//  Created by Aleksey Nemychenkov on 21/01/2018.
//  Copyright © 2018 Aleksey Nemychenkov. All rights reserved.
//

import UIKit

protocol QuotesView: class {
    func updateQuotes(at indexes: [Int])
    func updateQuotes()
    func showError(_ error: Error)
    func showLoader()
    func hideLoader()
}

class QuotesViewController: UIViewController {
    lazy var presenter: QuotesPresenting! = {
        let url = "wss://quotes.exness.com:18400"
        let client = ExnessClient(urlString: url)
        let prefs = PrefsStorage()
        let networkChecker = NetworkStatusChecker()
        return QuotesPresenter(qoutesClient: client, prefs: prefs, networkChecker: networkChecker)
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
        editMode = !editMode
    }
    
    @objc func showAll() {
        let pairsListPresenter = presenter.pairsListPresenter()
        PairsListViewController.present(from: self, presenter: pairsListPresenter) { [unowned self] pairs in
            self.presenter.updatePairs(pairs)
        }
        editMode = false
    }
    
    private var editMode: Bool = false {
        didSet {
            if editMode {
                tableView.isEditing = true
                let button = UIBarButtonItem(title: "Show All", style: .plain, target: self, action: #selector(showAll))
                navigationItem.rightBarButtonItem = button
            }
            else {
                tableView.isEditing = false
                navigationItem.rightBarButtonItem = nil
            }
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter.delete(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        presenter.move(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
}

extension QuotesViewController: QuotesView {
    func updateQuotes(at indexes: [Int]) {
        let indexPaths = indexes.map { IndexPath(row: $0, section: 0) }
        tableView.reloadRows(at: indexPaths, with: .none)
    }
    
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
