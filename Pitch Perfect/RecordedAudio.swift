//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Vinicius Brito on 8/29/15.
//  Copyright (c) 2015 Vinicius. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject
{
    var filePathUrl: NSURL!
    var title: String!
    
    init(url:NSURL, string:String)
    {
        self.filePathUrl = url
        self.title = string
    }
}
