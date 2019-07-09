//
//  ViewController.swift
//  AttributedImageText
//
//  Created by MAC on 5/6/9.
//  Copyright © 209 MAC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    let fullString = "Your costs for covered services could include a deductible, plus copays or coinsurance "
    let stringToColorRed = "deductible"
    let stringToColorBlue = "plus copays or coinsurance"
    var rangeWholeText:NSRange!
    var rangeTextRed:NSRange!
    var rangeTextBlue:NSRange!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.textTapped(_:)))
        textView.addGestureRecognizer(tap)
        rangeWholeText = NSRange(location: 0, length: fullString.count)
        rangeTextRed = (fullString as NSString).range(of: stringToColorRed)
        rangeTextBlue = (fullString as NSString).range(of: stringToColorBlue)
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // create an NSMutableAttributedString that we'll append everything to
       
        
        let attributedString = NSMutableAttributedString(string: fullString)
        attributedString.addAttribute(NSAttributedString.Key.redTextTappableAttributeName, value: "", range: rangeTextRed)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red
            , range: rangeTextRed)
        
        attributedString.addAttribute(NSAttributedString.Key.blueTextTappableAttributeName, value: "", range: rangeTextBlue)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue
            , range: rangeTextBlue)
        
        let imageAttachment = CustomTextAttachment()
        let image = UIImage(named: "cardiogram")
        
        imageAttachment.image = image
        
        
        // wrap the attachment in its own attributed string so we can append it
        let imageString = NSAttributedString(attachment: imageAttachment)
        // add the NSTextAttachment wrapper to our full string, then add some more text.
        attributedString.append(imageString)
        
        
        // draw the result in a label
        textView.attributedText = attributedString
    }
    
    @objc func textTapped(_ sender: UITapGestureRecognizer){
        let myTextView = sender.view as! UITextView
        let layoutManager = myTextView.layoutManager
        
        // location of tap in myTextView coordinates and taking the inset into account
        var location = sender.location(in: myTextView)
        location.x -= myTextView.textContainerInset.left;
        location.y -= myTextView.textContainerInset.top;
        
        // character index at tap location
        let characterIndex = layoutManager.characterIndex(for: location, in: myTextView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        // if index is valid then do something.
        let ch = (myTextView.textStorage.string as NSString).character(at: characterIndex)
        if ch == NSTextAttachment.character{
            print("Image is tapped")
        }else{
            if characterIndex < myTextView.textStorage.length {
                if let _ = getValueForCustomAttribute(myTextView.attributedText, attributeName: NSAttributedString.Key.redTextTappableAttributeName.rawValue, characterIndex: characterIndex){
                    print("Red Target text is tapped")
                }else if let _ = getValueForCustomAttribute(myTextView.attributedText, attributeName: NSAttributedString.Key.blueTextTappableAttributeName.rawValue, characterIndex: characterIndex){
                    print("Blue Target text is tapped")
                }
            }
        }
    }
    
    func getValueForCustomAttribute(_ attrText:NSAttributedString, attributeName:String, characterIndex:Int) -> (value:Any, range:NSRange)?{
        
        // check if the tap location has a particular attribute
        let attributeName = NSAttributedString.Key(attributeName)
        var range:NSRange? = NSMakeRange(0, 1)
        if let value = attrText.attribute(attributeName, at: characterIndex, longestEffectiveRange: &range!, in:NSMakeRange(0, attrText.length)){
            return (value, range!)
        }else{
            return nil
        }
    }

}

class CustomTextAttachment:NSTextAttachment{
    @objc override func attachmentBounds(for textContainer: NSTextContainer?, proposedLineFragment lineFrag: CGRect, glyphPosition position: CGPoint, characterIndex charIndex: Int) -> CGRect {
        return CGRect(x: 0.0, y: -5.0, width: self.image?.size.width ?? 0.0, height: self.image?.size.height ?? 0.0)
    }
}

extension NSAttributedString.Key {
    static let redTextTappableAttributeName = NSAttributedString.Key(rawValue: "tappableRedText")
    static let blueTextTappableAttributeName = NSAttributedString.Key(rawValue: "tappableBlueText")
}


