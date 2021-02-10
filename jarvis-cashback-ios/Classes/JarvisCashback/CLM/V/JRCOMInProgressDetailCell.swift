//
//  JRCOMInProgressDetailCell.swift
//  Jarvis
//
//  Created by Siddharth Suneel on 21/01/19.
//  Copyright © 2019 One97. All rights reserved.
//

import UIKit

class JRCOMInProgressDetailCell: UITableViewCell {
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var rightLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        rightLabel.layer.cornerRadius = rightLabel.bounds.size.height / 2.0
    }
    
    func setDataInCell(stageViewModel: StageViewModel) {
        progressView.progress = stageViewModel.getStageProgressValue()
        rightLabel.text = stageViewModel.getStageTransactionsLeftText()
        setNeedsLayout()
    }
}
