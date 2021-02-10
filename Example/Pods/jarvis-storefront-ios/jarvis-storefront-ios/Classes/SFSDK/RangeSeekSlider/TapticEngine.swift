//
//  TapticEngine.swift
//  RangeSeekSlider
//
//  Created by Keisuke Shoji on 2017/04/09.
//
//

import UIKit

/// Generates iOS Device vibrations by UIFeedbackGenerator.
open class TapticEngine {

    public static let selection: Selection = Selection()

    /// Wrapper of `UISelectionFeedbackGenerator`
    open class Selection {

        private var generator: Any? = {
            guard #available(iOS 10.0, *) else { return nil }

            let generator: UISelectionFeedbackGenerator = UISelectionFeedbackGenerator()
            generator.prepare()
            return generator
        }()

        public func feedback() {
            guard #available(iOS 10.0, *) else { return }
            guard let generator = generator as? UISelectionFeedbackGenerator else { return }

            generator.selectionChanged()
            generator.prepare()
        }

        public func prepare() {
            guard #available(iOS 10.0, *) else { return }
            guard let generator = generator as? UISelectionFeedbackGenerator else { return }

            generator.prepare()
        }
    }
}
