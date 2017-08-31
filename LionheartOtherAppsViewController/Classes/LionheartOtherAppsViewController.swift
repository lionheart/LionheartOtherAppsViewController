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

final class LionheartOtherAppsViewController: BaseTableViewController {
    var developerID: String!
    var developerURL: URL? {
        return URL(string: "https://itunes.apple.com/lookup?id=\(developerID)&entity=software")
    }

    var apps: [[String: String]] = []

    let activity = UIActivityIndicatorView(activityIndicatorStyle: .gray)

    init(developerID: String) {
        super.init(style: .grouped)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Our Apps"

        activity.hidesWhenStopped = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        activity.startAnimating()

        guard let url = developerURL else {
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data,
                let object = try? JSONSerialization.jsonObject(with: data, options: []),
                let payload = object as? [String: Any],
                let results = payload["results"] as? [[String: String]] else {
                return
            }

            for app in results {
                guard app["trackName"] != nil else {
                    continue
                }

                self.apps.append(app)
            }

            DispatchQueue.main.async {
                self.activity.stopAnimating()
                self.tableView.reloadData()
            }
        }
    }
}

extension LionheartOtherAppsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let urlString = apps[indexPath.row]["trackViewUrl"],
            let url = URL(string: urlString) else {
                return
        }

        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

extension LionheartOtherAppsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if apps.count > 0 {
            return apps.count
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as QuickTableViewCellSubtitle
        if apps.count > 0 {
            let app = apps[indexPath.row]
            guard let appName = app["trackName"]?.components(separatedBy: "-").first,
                let imageURLString = app["artworkUrl60"] else {
                    return cell
            }

            let ratingCount = app["userRatingCount"] ?? "0"
            var starString = ""

            if let currentRating = app["averageUserRating"],
                let decimal = Decimal(string: currentRating) {
                    let starRating = NSDecimalNumber(decimal: decimal)

                for i in 0..<5 {
                    if starRating.intValue - i > 0 {
                        starString += "★"
                    } else {
                        starString += "☆"
                    }
                }
            }

            let plural: String
            if ratingCount == "1" {
                plural = ""
            } else {
                plural = "s"
            }

            cell.textLabel?.text = appName
            cell.detailTextLabel?.text = "\(starString) \(ratingCount) review\(plural)"
            cell.imageView?.sd_setImage(with: URL(string: imageURLString), completed: nil)

        } else {
            cell.textLabel?.text = "Loading"
            cell.accessoryView = activity
        }
        return cell
    }
}
