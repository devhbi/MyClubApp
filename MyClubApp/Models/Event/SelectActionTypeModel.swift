//
//  SelectActionTypeModel.swift
//  MyClubApp
//
//  Created by Honoré BIZAGWIRA on 05/09/2022.
//

import Foundation

struct SelectActionTypeModel: Hashable {
    let name: String
    let imageName: String
    let action: Event.ActionType
}

struct SelectActionFrequencyModel: Hashable {
    let name: String
    let imageName: String
    let action: Event.ActionTimingType
}

extension SelectActionTypeModel {
    static var actions: [SelectActionTypeModel] {
        var actionArray = [SelectActionTypeModel]()
        actionArray.append(SelectActionTypeModel(name: "Événemnt", imageName: "calendar", action: .event))
        actionArray.append(SelectActionTypeModel(name: "Message", imageName: "pencil", action: .message))
        return actionArray
    }
    
    static var defaultAction: SelectActionTypeModel {
        return SelectActionTypeModel(name: "Événemnt", imageName: "calendar", action: .event)
    }
}

extension SelectActionFrequencyModel {
    
    
    static var periods: [SelectActionFrequencyModel] {
        var periodArray = [SelectActionFrequencyModel]()
        periodArray.append(SelectActionFrequencyModel(name: "Une date précise", imageName: "calendar", action: .once))
        periodArray.append(SelectActionFrequencyModel(name: "Répéter", imageName: "arrow.counterclockwise", action: .periodic))
        return periodArray
    }
    
    static var defaultPeriod: SelectActionFrequencyModel {
        return SelectActionFrequencyModel(name: "Une date précise", imageName: "calendar", action: .once)
    }
}
