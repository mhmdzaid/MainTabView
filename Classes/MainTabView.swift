//
//  MainTabView.swift
//  kiddo
//
//  Created by Mac on 1/30/20.
//  Copyright © 2020 Mohamed Zead. All rights reserved.
//

import Foundation
import UIKit
public class MainTabView: UIView {
    
    //MARK:- inspectables
    @IBInspectable var selectedTitleColor: UIColor = .black
    @IBInspectable var ViewBackgroundColor: UIColor = .white
    @IBInspectable var normalTitleColor: UIColor = .black
    @IBInspectable var normalBackGround: UIColor = .white
    @IBInspectable var barColor: UIColor = .blue
    @IBInspectable var titleFont: UIFont = UIFont.systemFont(ofSize: 18)
    @IBInspectable var barPadding: CGFloat = 5
    
    /// MainTabView delegate protocol for interaction with the tabs
    public var delegate: MainTabDelegate? {
        didSet{
            
        }
    }
    /// MainTabView dataSource  protocol
    public var dataSource:  MainTabViewDataSource? {
        didSet{
            items = self.dataSource?.viewControllersToBeHosted(in: self) ?? []
            let frameWidth = frame.width
            var sidBarWidth = items.isEmpty ? frameWidth : frameWidth / CGFloat(items.count)
            sidBarWidth -= barPadding
            sideBarWidthConstraint?.constant = sidBarWidth
            setInitialContainer()
        }
    }
    /// Items to be in the view must conform to TabItem
    public var items: [TabItem] = [] {
        didSet{
        fillSegmentation()
    }}
    private var sideBarConstraint: NSLayoutConstraint?
    private var sideBarWidthConstraint: NSLayoutConstraint?
    /// Appearance attributes for selected tab
    var selectedTitleAttirbutes: [NSAttributedString.Key: Any] {
        return [NSAttributedString.Key.foregroundColor: selectedTitleColor,
                NSAttributedString.Key.backgroundColor: UIColor.clear,
                NSAttributedString.Key.font :titleFont]
    }
    
    /// Appearance attributes for non-selected tab
    var normalTitleAttributes: [NSAttributedString.Key: Any] {
        return [NSAttributedString.Key.foregroundColor: normalTitleColor,
                NSAttributedString.Key.backgroundColor: UIColor.clear,
                NSAttributedString.Key.font :titleFont]
        
    }
    
    
    //MARK:- View setUp
    
    lazy var segmentation: UISegmentedControl = {
        let segmented = UISegmentedControl()
        segmented.setBackgroundImage(UIImage(), for: .normal, barMetrics: UIBarMetrics.default)
        segmented.tintColor = .white
        segmented.translatesAutoresizingMaskIntoConstraints = false
        segmented.setTitleTextAttributes(selectedTitleAttirbutes, for: .selected)
        segmented.setTitleTextAttributes(normalTitleAttributes, for: .normal)
        return segmented
    }()
    
    
    lazy var containerView: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .red
        return container
    }()
    
    lazy var sideBar: UIView = {
        let view = UIView()
        view.backgroundColor = barColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    private func fillSegmentation() {
        for i in 0..<items.count{
            segmentation.insertSegment(withTitle: items[i].tabTitle ?? "" , at: i, animated: true)
        }
    }
    
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        fillSegmentation()
        addSubview(segmentation)
        setUpSegmentConstraints()
        addSubview(sideBar)
        setSideBarConstraints()
        segmentation.addTarget(self, action: #selector(semgentAciton(_:)), for: .valueChanged)
        addSubview(containerView)
        setContainerViewConstraints()
        
    }
    
    
    func removeSubViewController(vc: UIViewController) {
        vc.willMove(toParent: nil)
        vc.view.removeFromSuperview()
        vc.removeFromParent()
        
    }
    
    func addSubViewController(vc: UIViewController) {
        let container = dataSource?.viewController
        containerView.addSubview(vc.view)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        setUpChildConstraints(vc.view)
        container?.addChild(vc)
        vc.didMove(toParent: container)
    }
    
    
    func setUpChildConstraints(_ childView : UIView) {
        NSLayoutConstraint.activate([
            childView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            childView.topAnchor.constraint(equalTo: containerView.topAnchor),
            childView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            childView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
    }
    
    private func setInitialContainer() {
        guard !items.isEmpty else {
            return
        }
        let item = items[0].viewController
        addSubViewController(vc: item!)
    }
    
    
    @objc func semgentAciton(_ sender: UISegmentedControl) {
        animateSideBar(index:sender.selectedSegmentIndex)
        delegate?.didSelectItemAt(index: sender.selectedSegmentIndex)
        let item = items[sender.selectedSegmentIndex].viewController
        addSubViewController(vc: item!)
    }
    
    
    
    private func animateSideBar(index : Int) {
        let X = CGFloat(index) * self.bounds.width/CGFloat(items.count) + barPadding/2
        self.sideBarConstraint?.constant = X
        
        UIView.animate(withDuration: 0.3) {[weak self] in
            guard let self = self else{return}
            self.layoutIfNeeded()
        }
    }
    
    
    
    
    
    
    private func setUpSegmentConstraints(){
        NSLayoutConstraint.activate([
            segmentation.topAnchor.constraint(equalTo: topAnchor),
            segmentation.leadingAnchor.constraint(equalTo: leadingAnchor),
            segmentation.trailingAnchor.constraint(equalTo: trailingAnchor),
            segmentation.heightAnchor.constraint(equalToConstant: 45.0),
        ])
        
    }
    
    
    
    private func setSideBarConstraints() {
        sideBarConstraint =  sideBar.leadingAnchor.constraint(equalTo: segmentation.leadingAnchor, constant: barPadding)
        let frameWidth = frame.width
        var sidBarWidth = items.isEmpty ? frameWidth : frameWidth / CGFloat(items.count)
        sidBarWidth -= barPadding
        sideBarWidthConstraint = sideBar.widthAnchor.constraint(equalToConstant: sidBarWidth)
        NSLayoutConstraint.activate([
            sideBar.topAnchor.constraint(equalTo: segmentation.bottomAnchor),
            sideBarConstraint!,
            sideBarWidthConstraint!,
            sideBar.heightAnchor.constraint(equalToConstant: 6)
        ])
    }
    
    
    private func setContainerViewConstraints() {
        guard let view = superview else{
            return
        }
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: sideBar.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
}
