//
//  SearchItemCell.swift
//  setScheduleTest
//
//  Created by JMC on 30/10/21.
//

import UIKit
import SnapKit

typealias SearchItemCellConfig = ListCellConfigurator<SearchItemCell, AbstractCellViewModel>

class SearchItemCell : UITableViewCell, ConfigurableCell {
    typealias DataType = AbstractCellViewModel
    
    var imageUrlAtCurrentIndex: String?
    
    let containerView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.isSkeletonable = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.darkGray.cgColor
        return view
    }()
    
    let lblTitle : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 18)
        lbl.textAlignment = .left
        lbl.numberOfLines = 1
        lbl.isSkeletonable = true
        lbl.skeletonLineSpacing = 10
        lbl.multilineSpacing = 10
        return lbl
    }()
    
    let lblOverview : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .darkGray
        lbl.font = UIFont.systemFont(ofSize: 15)
        lbl.textAlignment = .left
        lbl.numberOfLines = 2
        lbl.isSkeletonable = true
        lbl.skeletonLineSpacing = 10
        lbl.multilineSpacing = 10
        return lbl
    }()
    
    let ivPoster : UIImageView = {
        let imgView = UIImageView(image: UIImage(named: "img_avatar"))
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
//        imgView.layer.cornerRadius = 45
        imgView.isSkeletonable = true
        return imgView
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        ivPoster.image = nil
        lblTitle.text = ""
        lblOverview.text = ""
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubViews()
        addConstraintsToSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(ivPoster)
        containerView.addSubview(lblTitle)
        containerView.addSubview(lblOverview)
    }
    
    private func addConstraintsToSubviews() {
        containerView.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(contentView.snp.leading).offset(CGFloat(5).adaptiveValue())
            make.trailing.equalTo(contentView.snp.trailing).offset(-CGFloat(5).adaptiveValue())
            make.top.equalTo(contentView.snp.top).offset(CGFloat(5).adaptiveValue())
            make.bottom.equalTo(contentView.snp.bottom).offset(-CGFloat(5).adaptiveValue())
        }
        
        ivPoster.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(containerView.snp.leading).offset(CGFloat(10).adaptiveValue())
            make.centerY.equalTo(containerView.snp.centerY)
            make.width.equalTo(CGFloat(90).adaptiveValue())
            make.height.equalTo(CGFloat(90).adaptiveValue())
        }
        
        lblTitle.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(ivPoster.snp.trailing).offset(CGFloat(10).adaptiveValue())
            make.trailing.equalTo(containerView.snp.trailing).offset(-CGFloat(10).adaptiveValue())
            make.top.equalTo(ivPoster.snp.top).offset(CGFloat(10).adaptiveValue())
            make.bottom.equalTo(lblOverview.snp.top)
        }
        
        lblOverview.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(lblTitle.snp.leading)
            make.trailing.equalTo(lblTitle.snp.trailing)
            make.top.equalTo(lblTitle.snp.bottom).offset(CGFloat(5).adaptiveValue())
            make.bottom.equalTo(containerView.snp.bottom).offset(-CGFloat(10).adaptiveValue())
        }
    }
    
    public func configure(data: DataType) {
        backgroundColor = .white
        contentView.backgroundColor = .white
            
        ShimmerHelper.startShimmerAnimation(view: ivPoster)
        lblTitle.text = data.title
        lblOverview.text = data.overview
        
        let posterUrl = "\(AppConfig.shared.getServerConfig().getMediaBaseUrl())/\(data.thumbnail ?? "" )"
        imageUrlAtCurrentIndex = posterUrl
        
        ivPoster.loadImage(from: posterUrl, completionHandler: { [weak self] url, image, isFinished  in
            guard let weakSelf = self else {
                return
            }
            
            if weakSelf.imageUrlAtCurrentIndex == url {
                weakSelf.ivPoster.image = image
                ShimmerHelper.stopShimmerAnimation(view: weakSelf.ivPoster)
            }
        })
        
        //apply  change theme
        applyTheme()
    }
    
    // when theme change (dark or normal)
    public func applyTheme() {
        switch (traitCollection.userInterfaceStyle) {
        case .dark:
            containerView.backgroundColor = .lightGray
            containerView.layer.borderColor = UIColor.white.cgColor
            lblTitle.textColor = .white
            lblOverview.textColor = .white
            backgroundView?.backgroundColor = .black
            break
            
        case .light:
            containerView.backgroundColor = .white
            containerView.layer.borderColor = UIColor.black.cgColor
            lblTitle.textColor = .black
            lblOverview.textColor = .darkGray
            break
            
        default:
            break
        }
    }
}
