//
//  ViewController.swift
//  NetflixPreviewFeature
//
//  Created by Victor Magalhaes on 21/04/2018.
//  Copyright © 2018 Victor Magalhaes. All rights reserved.
//

import UIKit

class CoreViewController: UIViewController {

    var mView = UIView()
    var previews: [PreviewEntity] = []
    
    let tableView : UITableView = {
        let mTable = UITableView()
        mTable.register(PreviewsCell.self, forCellReuseIdentifier: "mCell")
        mTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return mTable
    }()
    
    var previewsView : PreviewCustomView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        setupView()
        setupPreviewsContent()
    }
    
    func setupView(){
        self.tableView.frame = self.view.safeAreaLayoutGuide.layoutFrame
        self.view.addSubview(tableView)
    }
    
    func setupPreviewsContent(){
        self.previews = [PreviewEntity]()
        var previewA = PreviewEntity()
        var previewB = PreviewEntity()
        previewA.previewVideoUrl = Bundle.main.path(forResource: "superman", ofType: "mov")
        previewA.staticImage = "supermanImg"
        previewA.logoHeader = "supermanHeader"
        previewB.previewVideoUrl = Bundle.main.path(forResource: "madMax", ofType: "mov")
        previewB.staticImage = "madMaxImg"
        previewB.logoHeader = "madMaxHeader"
        self.previews.append(previewA)
        self.previews.append(previewB)
    }
    
}

extension CoreViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "mCell", for: indexPath) as! PreviewsCell
            cell.delegate = self
            cell.previews = previews
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "NETFLIX PREVIEWS"
            cell.textLabel?.textColor = UIColor.white
            cell.backgroundColor = UIColor.black
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension CoreViewController : PreviewItemTouchProtocol, UIGestureRecognizerDelegate {
    
    func previewItemTouched(startPos: Int, cell: PreviewsCell, collectionOffsetX: CGFloat, itemFrame: CGRect){
        self.previewsView = PreviewCustomView(startPos, self.previews, collectionOffsetX,tableView.contentOffset.y,itemFrame,cell.frame.origin)
        setupPreviewGesture()
        self.view.addSubview(previewsView!)
        self.previewsView?.showPreview()
    }
    
    func setupPreviewGesture() {
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(handleDismissPreviewSwipe))
        gesture.delegate = self
        gesture.direction = .down
        self.previewsView!.addGestureRecognizer(gesture)
        self.view.addSubview(previewsView!)
    }

    @objc func handleDismissPreviewSwipe(){
        self.previewsView!.dismissPreview()
    }
    
}







