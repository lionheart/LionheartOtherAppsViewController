//
//  Copyright 2017 Lionheart Software LLC
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//

import QuickTableView
import SDWebImage

fileprivate struct App {
    var affiliateCode: String?
    var name: String
    var rating: Decimal?
    var numberOfRatings: Int?
    var imageURLString: String?
    var imageURL: URL? {
        guard let urlString = imageURLString else {
            return nil
        }

        return URL(string: urlString)
    }

    var urlString: String?
    var url: URL? {
        guard var urlString = urlString else {
            return nil
        }

        if let affiliateCode = affiliateCode {
            urlString += "&at=\(affiliateCode)"
        }

        return URL(string: urlString)
    }

    var starString: String? {
        guard let rating = rating else {
            return nil
        }

        var value = ""
        let starRating = NSDecimalNumber(decimal: rating)

        for i in 0..<5 {
            if starRating.intValue - i > 0 {
                value += "★"
            } else {
                value += "☆"
            }
        }

        return value
    }

    var detailText: String {
        guard let numberOfRatings = numberOfRatings,
            let starString = starString else {
                return "No reviews"
        }

        let plural: String
        if numberOfRatings == 1 {
            plural = ""
        } else {
            plural = "s"
        }

        return "\(starString) \(numberOfRatings) review\(plural)"
    }

    init?(payload: [String: Any], affiliateCode: String?) {
        guard let appNameString = payload["trackName"] as? String,
            let appName = appNameString.components(separatedBy: "-").first else {
                return nil
        }

        self.affiliateCode = affiliateCode
        name = appName
        rating = (payload["averageUserRating"] as? NSNumber)?.decimalValue
        numberOfRatings = payload["userRatingCount"] as? Int
        imageURLString = payload["artworkUrl60"] as? String
        urlString = payload["trackViewUrl"] as? String
    }
}

public final class LionheartOtherAppsViewController: BaseTableViewController {
    var developerID = 0
    var affiliateCode: String?
    var developerURL: URL {
        return URL(string: "https://itunes.apple.com/lookup?id=\(developerID)&entity=software")!
    }
    fileprivate var apps: [App] = []

    let activity = UIActivityIndicatorView(activityIndicatorStyle: .gray)

    public init(developerID: Int, affiliateCode: String? = nil) {
        super.init(style: .grouped)

        self.developerID = developerID
        self.affiliateCode = affiliateCode
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        title = "Our Apps"

        activity.hidesWhenStopped = true

        tableView.registerClass(QuickTableViewCellSubtitle.self)
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        activity.startAnimating()

        let task = URLSession.shared.dataTask(with: developerURL) { (data, response, error) in
            guard let data = data,
                let object = try? JSONSerialization.jsonObject(with: data, options: []),
                let payload = object as? [String: Any],
                let results = payload["results"] as? [[String: Any]] else {
                return
            }

            self.apps = results.flatMap({ App(payload: $0, affiliateCode: self.affiliateCode) }).sorted(by: { $0.0.name > $0.1.name })

            DispatchQueue.main.async {
                self.activity.stopAnimating()
                self.tableView.reloadData()
            }
        }

        task.resume()
    }
}

extension LionheartOtherAppsViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let url = apps[indexPath.row].url else {
            return
        }

        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

extension LionheartOtherAppsViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard apps.count > 0 else {
            return 1
        }

        return apps.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as QuickTableViewCellSubtitle

        guard apps.count > 0 else {
            cell.textLabel?.text = "Loading"
            cell.accessoryView = activity
            return cell
        }

        let app = apps[indexPath.row]
        cell.textLabel?.text = app.name
        cell.detailTextLabel?.text = app.detailText
        cell.accessoryView = nil

        if let url = app.imageURL {
            cell.imageView?.sd_setImage(with: url, completed: nil)
        }

        return cell
    }
}
