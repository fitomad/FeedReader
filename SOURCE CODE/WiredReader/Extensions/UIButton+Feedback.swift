//
//  UIButton+Feedback.swift
//  desappstre framework
//
//  Created by Adolfo on 19/05/15.
//  Copyright (c) 2015 Desappstre Studio. All rights reserved.
//

import UIKit
import Foundation
import AudioToolbox

public extension UIButton
{
    /**
     Sonido por defecto al pulsar un botón
    */
	public func tapFeedback() -> Void
	{
		AudioServicesPlaySystemSound(1104)
	}
}
