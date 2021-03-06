//
//  ArticleListViewController.swift
//  Reader
//
//  Created by Martin Richter on 18/09/15.
//  Copyright © 2015 Futurice. All rights reserved.
//

import UIKit

class ArticleListViewController: UITableViewController {

    private let articleStore: ArticleStore
    private var articles: [Article]

    // MARK: Lifecycle

    required init?(coder aDecoder: NSCoder) {
        self.articleStore = ArticleStore()
        self.articles = []

        super.init(coder: aDecoder)
    }

    // MARK: View Lifecycle

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120

        articleStore.fetchArticles(success: { [weak self] articles in
            // Ensure that the UI gets updated on the main thread
            dispatch_async(dispatch_get_main_queue(), {
                self?.articles = articles
                self?.tableView.reloadData()
            })
        })
    }

    // Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showArticle",
            let detailVC = (segue.destinationViewController as? UINavigationController)?.topViewController as? ArticleDetailViewController,
            let indexPath = tableView.indexPathForSelectedRow {
                let article = articles[indexPath.row]
                detailVC.article = article
                detailVC.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                detailVC.navigationItem.leftItemsSupplementBackButton = true
        }
    }

    // MARK: - UITableViewDataSource

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // This is how many rows we want in the table
        return articles.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Dequeue a cell (this will auto-create one if none found)
        let cell = tableView.dequeueReusableCellWithIdentifier("articleCell") as! ArticleCell

        // Get the relevant article
        let article = articles[indexPath.row]

        // Configure the cell content
        cell.titleLabel.text = article.title
        cell.descriptionLabel.text = article.description

        return cell
    }
}