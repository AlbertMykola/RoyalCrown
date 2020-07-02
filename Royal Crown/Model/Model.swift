//
//  Model.swift
//  Royal Crown
//
//  Created by Albert on 24.06.2020.
//  Copyright © 2020 Albert Mykola. All rights reserved.
//

import Foundation

struct Info: Codable {
    var aboutUs: String?
    var aboutRoyalAssist: String?

    enum CodingKeys: String, CodingKey {
        case aboutUs = "about_us"
        case aboutRoyalAssist = "about_royal_assist"
    }
}

struct Branches: Codable {
    var title: String?
    var address: String?
    var phone: String?
    var fax: String?
    var email: String?
    var latitude: Double?
    var longitude: Double?
}

struct Services: Codable {
      var id: Int?
      var title: String?
      var website: String?
      var type: String?
      var description: String?
  }

struct WhatToDoIt: Codable {
    var title: String
    var tabs: Bool
    var tabTitleFirst: String
    var tabContentFirst: String
    var  tabTitleSecond: String
    var tabContentSecond: String
    
    enum CodingKeys: String, CodingKey {
        case tabTitleFirst = "tab_1_title"
        case tabContentFirst = "tab_1_content"
        case tabTitleSecond = "tab_2_title"
        case tabContentSecond = "tab_2_content"
        case title
        case tabs
    }
}

struct Question: Codable {
    var id: Int
    var text: String
    var order: Int
    var answers: [Answers]
}

struct Answers: Codable {
    var id: Int
    var text: String
    var correct: Bool
    var order: Int
}

struct Questionnaire: Codable {
    var id: Int
    var title: String
    var description: String
}

struct Message: Codable {
    var errors: [String]?
    var message: String?
}




