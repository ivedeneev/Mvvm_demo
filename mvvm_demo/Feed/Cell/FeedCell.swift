//
//  FeedCell.swift
//  mvvm_demo
//
//  Created by Igor Vedeneev on 3/4/19.
//  Copyright © 2019 Igor Vedeneev. All rights reserved.
//

import UIKit
import IVCollectionKit

final class FeedCell: UICollectionViewCell {
    private let titleLabel = LTLabel()
    private let descriptionLabel = LTLabel()
    private let imageView = UIImageView()
    
    var viewModel: FeedCellViewModel?
    static let placeholder = UIImage.imageWithColor(color: Color.feedImageBackground, size: CGSize(width: 40, height: 40))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        backgroundColor = Color.background
        layer.cornerRadius = 10
        clipsToBounds = true
        titleLabel.backgroundColor = Color.background
        addSubview(titleLabel)
        
        descriptionLabel.backgroundColor = Color.background
        addSubview(descriptionLabel)
        
        addSubview(imageView)
        imageView.contentMode = .center
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let vm = viewModel else { return }
        imageView.frame = CGRect(x: 8, y: 8, width: 40, height: 40)
        titleLabel.frame = CGRect(x: imageView.frame.maxX + 8, y: 8, width: vm.title.size.width, height: vm.title.size.height)
        descriptionLabel.frame = CGRect(x: imageView.frame.maxX + 8, y: titleLabel.frame.maxY + 8, width: vm.subtitle.size.width, height: vm.subtitle.size.height)
    }
}

extension FeedCell: ConfigurableCollectionItem {
    static func estimatedSize(item: FeedCellViewModel?, boundingSize: CGSize) -> CGSize {
        guard let itm = item else { return .zero }
        let height = max(itm.title.size.height + itm.subtitle.size.height + 8 * 3, 40 + 8 * 2)
        return CGSize(width: boundingSize.width, height: height)
    }
    
    func configure(item: FeedCellViewModel) {
        viewModel = item
        titleLabel.text = item.title
        descriptionLabel.text = item.subtitle
        imageView.setImage(url: item.url, placeholder: FeedCell.placeholder, size: CGSize(width: 40, height: 40), backgroundColor: Color.background, cornerMask: [.allCorners], cornerRadius: 10, takeUntil: reactive.prepareForReuse)
    }
}
