//
//  AMColorPickerTableView.swift
//  TestProject
//
//  Created by am10 on 2018/01/03.
//  Copyright © 2018年 am10. All rights reserved.
//

import UIKit

protocol AMColorPickerTableViewDelegate: class {
    
    func colorPickerTableView(colorPickerTableView: AMColorPickerTableView, didSelect color: UIColor)
}

class AMColorPickerTableView: UIView, UITableViewDelegate, UITableViewDataSource {

    weak var delegate:AMColorPickerTableViewDelegate?
    var selectedColor:UIColor = UIColor.white {
        
        didSet {
            
            colorView.backgroundColor = selectedColor
            var alpha:CGFloat = 0
            selectedColor.getRed(nil, green: nil, blue: nil, alpha: &alpha)
            alpha = alpha * 100
            opacityLabel.text = NSString(format: "%.0f", alpha) as String
            opacitySlider.value = Float(alpha)
        }
    }
    
    @IBOutlet weak private var opacityLabel: UILabel!
    @IBOutlet weak private var opacitySlider: UISlider!
    @IBOutlet weak private var colorView: UIView!
    @IBOutlet weak private var tableView: UITableView!
    
    private let cellIdentifier = "AMColorPickerTableViewCell"
    private let dataList = [AMCPCellInfo(title: "Black", color: UIColor.black), AMCPCellInfo(title: "Blue", color: UIColor.blue),
                            AMCPCellInfo(title: "Brown", color: UIColor.brown), AMCPCellInfo(title: "Cyan", color: UIColor.cyan),
                            AMCPCellInfo(title: "Green", color: UIColor.green), AMCPCellInfo(title: "Magenta", color: UIColor.magenta),
                            AMCPCellInfo(title: "Orange", color: UIColor.orange), AMCPCellInfo(title: "Purple", color: UIColor.purple),
                            AMCPCellInfo(title: "Red", color: UIColor.red), AMCPCellInfo(title: "Yellow", color: UIColor.yellow),
                            AMCPCellInfo(title: "White", color: UIColor.white)]
    
    //MARK:Initialize
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        loadNib()
    }
    
    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)!
        loadNib()
    }
    
    private func loadNib() {
        
        let view = Bundle.main.loadNibNamed("AMColorPickerTableView", owner: self, options: nil)?.first as! UIView
        view.frame = bounds
        view.translatesAutoresizingMaskIntoConstraints = true
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "AMColorPickerTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellIdentifier)
        
        tableView.tableFooterView = UIView()
    }
    
    //MARK:IBAction
    @IBAction private func changedOpacitySlider(_ slider: UISlider) {
        
        opacityLabel.text = NSString(format: "%.0f", slider.value) as String
        didSelect(color: colorView.backgroundColor!)
    }
    
    //MARK:UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AMColorPickerTableViewCell
        cell.info = dataList[indexPath.row]
        return cell
    }
    
    //MARK:UITableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        didSelect(color: dataList[indexPath.row].color)
    }
    
    //MARK:SetColor
    private func didSelect(color: UIColor) {
        
        var red:CGFloat = 0
        var green:CGFloat = 0
        var blue:CGFloat = 0
        let alpha = NSString(string: opacityLabel.text!).floatValue/100.0
        color.getRed(&red, green: &green, blue: &blue, alpha: nil)
        let selectColor = UIColor(red: red, green: green, blue: blue, alpha: CGFloat(alpha))
        colorView.backgroundColor = selectColor
        
        if let delegate = delegate {
            
            delegate.colorPickerTableView(colorPickerTableView: self, didSelect: selectColor)
        }
    }
    
    //MARK:Reload
    func reloadTable() {
        
        tableView.reloadData()
        tableView.setContentOffset(CGPoint.zero, animated: false)
    }
}
