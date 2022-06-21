//
//  TimerTableViewCell.swift
//  Timers
//
//  Created by Artem Listopadov on 25.09.21.
//

import UIKit

protocol TimerTableViewCellDelegate: AnyObject {
    func deleteTableViewCell(at index: IndexPath)
}

class TimerTableViewCell: UITableViewCell {
    
    var timeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var timerName: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    weak var delegate: TimerTableViewCellDelegate?
    var timer = Timer()
    var count = 0
    var indexPath: IndexPath?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(timeLabel)
        contentView.addSubview(timerName)
        
        NSLayoutConstraint.activate([
            timeLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            timeLabel.heightAnchor.constraint(equalToConstant:30),
            timeLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 1/2.5),
            
            timerName.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            timerName.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            timerName.heightAnchor.constraint(equalToConstant:30),
            timerName.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 1/2.5)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func update() {
        if(count > 0){
            let minutes = String(count / 60)
            let seconds = String(count % 60)
            timeLabel.text = minutes + ":" + seconds
            count -= 1
        } else if count == 0 {
            timer.invalidate()
            if let delegate = delegate {
                guard let index = getIndexPath() else {
                    return
                }
                delegate.deleteTableViewCell(at: index)
                timer.fire()
                timer.invalidate()
                print("stopTimer")
            }
        }
    }
    
    func configure(name: String, time: Int){
        count = time
        timerName.text = "\(name)"
        timer = Timer(timeInterval: 1.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: .common)
        timer.tolerance = 0.1
    }
    
    func getIndexPath() -> IndexPath? {
        guard let superView = self.superview as? UITableView else {
            print("superview is not a UITableView - getIndexPath")
            return nil
        }
        indexPath = superView.indexPath(for: self)
        return indexPath
    }
}

