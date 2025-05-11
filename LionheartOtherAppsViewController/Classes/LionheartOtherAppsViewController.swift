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
import UIKit
import StoreKit

public final class LionheartOtherAppsViewController: BaseTableViewController {
    var developerID = 0
    var affiliateCode: String?
    var developerURL: URL {
        return URL(string: "https://itunes.apple.com/lookup?id=\(developerID)&entity=software")!
    }
    fileprivate var apps: [App] = []
    var imageCache: [URL: UIImage] = [:]

    let activity = UIActivityIndicatorView(activityIndicatorStyle: .gray)

    lazy var placeholder: UIImage? = {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 44, height: 44), false, 1.0)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }()

    @objc public init(developerID: Int, affiliateCode: String? = nil) {
        super.init(style: .grouped)

        self.developerID = developerID
        self.affiliateCode = affiliateCode
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        title = "Our Apps"

        activity.hidesWhenStopped = true

        tableView.registerClass(AppTableViewCell.self)
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

            self.apps = results.compactMap({ App(payload: $0, affiliateCode: self.affiliateCode) }).sorted {
                $0.name < $1.name
            }

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

      let app = apps[indexPath.row]
      guard let appIdentifier = app.trackId,
            let scene = view.window?.windowScene else {
            return
        }
    
      let config = SKOverlay.AppConfiguration(
        appIdentifier: String(appIdentifier),
         position: .bottom
      )
      config.campaignToken   = affiliateCode
      let overlay = SKOverlay(configuration: config)
      overlay.present(in: scene)
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
        let cell = tableView.dequeueReusableCell(for: indexPath) as AppTableViewCell

        guard apps.count > 0 else {
            cell.textLabel?.text = "Loading"
            cell.accessoryView = activity
            return cell
        }

        let app = apps[indexPath.row]
        cell.textLabel?.text = app.name
        cell.detailTextLabel?.text = app.detailText
        
        if let url = app.imageURL {
            if let image = imageCache[url] {
                cell.imageView?.image = image
            } else {
                cell.imageView?.image = placeholder
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    guard let data = data else {
                        return
                    }

                    let image = UIImage(data: data)
                    self.imageCache[url] = image
                    
                    DispatchQueue.main.async {
                        self.tableView.beginUpdates()
                        self.tableView.reloadRows(at: [indexPath], with: .automatic)
                        self.tableView.endUpdates()
                    }
                }
                task.resume()
            }
        }
        return cell
    }
}
