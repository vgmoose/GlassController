//
//  Result.swift
//  GlassCon
//
//

import Foundation

class Result : Hashable
{
    var hashValue: Int = 0
    
    static func ==(lhs: Result, rhs: Result) -> Bool {
        return lhs.code == rhs.code && lhs.opts == rhs.opts && lhs.key == rhs.key
    }
    
    var key: String = ""
    var code: Int = 0
    
    var opts: [Int] = []
        
    func invoke(_ enabled: Bool)
    {
        // do nothing (override me)
    }
    
    func toString() -> String
    {
        return "?"
    }
}

