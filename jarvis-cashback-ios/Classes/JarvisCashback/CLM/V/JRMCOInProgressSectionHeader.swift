//
//  JRMCOInProgressSectionHeader.swift
//  Jarvis
//
//  Created by Siddharth Suneel on 22/01/19.
//  Copyright © 2019 One97. All rights reserved.
//

import UIKit

class JRMCOInProgressSectionHeader: UITableViewHeaderFooterView {
    
    @IBOutlet weak var sectionProgressHeaderImage: UIImageView!
    @IBOutlet weak var sectionProgressHeaderTitle: UILabel!
    @IBOutlet weak var sectionProgressHeaderRightLabel: UILabel!    
    
    func setDataInView(stageViewModel: StageViewModel) {
        sectionProgressHeaderTitle.text = stageViewModel.stage_screen_construct1
        sectionProgressHeaderRightLabel.text = stageViewModel.getStageHeaderRightText()
        let status = stageViewModel.stage_status_enum
        switch status {
        case .completed:
            sectionProgressHeaderImage.image = UIImage.imageWith(name: "icTick3")
            break
        default:
            sectionProgressHeaderImage.image = UIImage.imageWith(name: "icTick2")
            break
        }
    }        
}
