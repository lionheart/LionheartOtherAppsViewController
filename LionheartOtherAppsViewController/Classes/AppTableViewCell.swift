//
//  AppTableViewCell.swift
//  LionheartOtherAppsViewController
//
//  Created by Dan Loewenherz on 3/1/18.
//

import UIKit
import SuperLayout
import QuickTableView

final class AppTableViewCell: UITableViewCell {
    var theImageView: UIImageView!
    var theTextLabel: UILabel!
    var theDetailTextLabel: UILabel!
    
    var horizontalStackView: UIStackView!
    var rightStackView: UIStackView!

    override var imageView: UIImageView? { return theImageView }
    override var textLabel: UILabel? { return theTextLabel }
    override var detailTextLabel: UILabel? { return theDetailTextLabel }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        accessoryType = .none
        
        theTextLabel = UILabel()
        theTextLabel.translatesAutoresizingMaskIntoConstraints = false
        theTextLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        theTextLabel.textColor = .black
        theTextLabel.textAlignment = .left

        theDetailTextLabel = UILabel()
        theDetailTextLabel.translatesAutoresizingMaskIntoConstraints = false
        theDetailTextLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        theDetailTextLabel.textColor = .black
        theDetailTextLabel.textAlignment = .left
        
        theImageView = UIImageView()
        theImageView.translatesAutoresizingMaskIntoConstraints = false
        theImageView.contentMode = .scaleAspectFit
        theImageView.layer.cornerRadius = 8
        theImageView.clipsToBounds = true
        
        rightStackView = UIStackView(arrangedSubviews: [theTextLabel, theDetailTextLabel])
        rightStackView.axis = .vertical
        rightStackView.alignment = .leading
        rightStackView.spacing = 1

        horizontalStackView = UIStackView(arrangedSubviews: [theImageView, rightStackView])
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.spacing = 10
        horizontalStackView.alignment = .center
        
        contentView.addSubview(horizontalStackView)
        
        theImageView.heightAnchor ~~ 50
        theImageView.widthAnchor ~~ theImageView.heightAnchor
        
        let margins = contentView.layoutMarginsGuide
        horizontalStackView.topAnchor ≥≥ margins.topAnchor
        horizontalStackView.leadingAnchor ~~ margins.leadingAnchor
        horizontalStackView.trailingAnchor ~~ margins.trailingAnchor

        let constraint = horizontalStackView.bottomAnchor.constraint(lessThanOrEqualTo: margins.bottomAnchor)
        constraint.priority = .defaultHigh
        constraint.isActive = true
        
        updateConstraintsIfNeeded()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AppTableViewCell: QuickTableViewCellIdentifiable {
    static var identifier: String { return "PriceBreakdownTableViewCellIdentifier" }
}
