//
//  PairsListViewController.swift
//  Quotes
//
//  Created by Aleksey Nemychenkov on 21/01/2018.
//  Copyright © 2018 Aleksey Nemychenkov. All rights reserved.
//

import UIKit

class PairsListViewController: UIViewController {
    typealias SelectionCallback = ([Pairs]) -> ()
    
    static func present(from: UIViewController, presenter: PairsListPresenter, callback: @escaping SelectionCallback) {
        let navigation = from.storyboard?.instantiateViewController(withIdentifier: "PairsList") as! UINavigationController
        let vc = navigation.viewControllers.first! as! PairsListViewController
        vc.presenter = presenter
        vc.callback = callback
        from.present(navigation, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelTouched(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveTouched(_ sender: Any) {
        callback(presenter.selectedPairs())
        dismiss(animated: true, completion: nil)
    }
    
    private var callback: SelectionCallback!
    private var presenter: PairsListPresenter!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView()
        }
    }
}

extension PairsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfPairs()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PairCell", for: indexPath)
        let pair = presenter.pair(at: indexPath.row)
        cell.textLabel?.text = pair.pair.displayedTitle
        cell.accessoryType = pair.selected ? .checkmark : .none
        return cell
    }
}

extension PairsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        presenter.update(at: indexPath.row)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}
