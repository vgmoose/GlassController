//
//  Activator.swift
//  GlassCon
//
//

import Foundation

// an activator initiates the corresponding action's result based on certain conditions
// most actions are different, at this time there isn't any common code between them,
// and they are manually checked in the main touchpad callback whether or not they should be invoked

// TODO: give activators an isValid method that takes in the touchpad data, possibly merge with Contexts

// TODO: multi activators, such as OrActivator or AndActivactor that can take a list of other activactors,
// and determine whether or not to fire them based on whethery one/all are true

class Activator
{
    func toString() -> String
    {
        return "Unknown Activator"
    }
}
