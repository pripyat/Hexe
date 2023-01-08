//
//  Document.swift
//  Hexe
//
//  Created by David Schiefer on 02.01.2023.
//

import Cocoa

class Document: NSDocument {

    @IBOutlet weak var hexeTextView: NSTextView!
    @IBOutlet weak var hexeLineCountView: DALineCounter!
    @IBOutlet weak var hexeStatusField: NSTextField!
    
    var _hexDocumentContents: NSAttributedString = NSAttributedString(string: "")

    override init() {
        super.init()
        // Add your subclass-specific initialization here.
    }
    
    deinit
    {
        // we no longer need this observer, the document is about to close
        NotificationCenter.default.removeObserver(self, name: NSTextView.didChangeNotification, object: self.hexeTextView)
        UserDefaults.standard.removeObserver(self, forKeyPath: Preferences.DASettingsKeyShowLineCount)
    }

    override class var autosavesInPlace: Bool {
        return UserDefaults.standard.bool(forKey: Preferences.DASettingsKeyAutosave)
    }

    override var windowNibName: NSNib.Name? {
        // Returns the nib file name of the document
        // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this property and override -makeWindowControllers instead.
        return NSNib.Name("Document")
    }
    
    override func windowControllerDidLoadNib(_ windowController: NSWindowController) {
        self.hexeTextView.font = NSFont.init(name: "Menlo", size: 11.0)
        
        if UserDefaults.standard.bool(forKey: Preferences.DASettingsKeyShowLineCount)
        {
            self.hexeTextView.lnv_setUpLineNumberView()
        }
        
        self.hexeTextView.textStorage?.setAttributedString(_hexDocumentContents)
        self._refreshCharacterCount()
        
        // attach our observer to monitor character count within our document
        NotificationCenter.default.addObserver(self, selector: #selector(self._refreshCharacterCount), name: NSTextView.didChangeNotification, object: self.hexeTextView)
        
        UserDefaults.standard.addObserver(self, forKeyPath: Preferences.DASettingsKeyShowLineCount, options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    override func data(ofType typeName: String) throws -> Data
    {
        let _contentToSave = self.hexeTextView.string
        
        if let _theData = _contentToSave.data(using: String.Encoding.utf8)
        {
            return _theData
        }
        else
        {
            throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
        }
        // Insert code here to write your document to data of the specified type, throwing an error in case of failure.
        // Alternatively, you could remove this method and override fileWrapper(ofType:), write(to:ofType:), or write(to:ofType:for:originalContentsURL:) instead.
    }
    
    override func read(from fileWrapper: FileWrapper, ofType typeName: String) throws
    {
        var _theData: NSAttributedString = NSAttributedString(string: "")

        switch (typeName)
        {
            case "public.rtf":
            if let _fileContents = fileWrapper.regularFileContents
            {
                _theData = NSAttributedString(rtf: _fileContents, documentAttributes: nil)!
            }
            case "com.apple.rtfd":
                _theData = NSAttributedString(rtfdFileWrapper: fileWrapper, documentAttributes: nil)!
            case "public.plain-text":
            if let _fileContents = fileWrapper.regularFileContents
            {
                let _plainText = String(data: _fileContents, encoding: String.Encoding.utf8)!
                _theData = NSAttributedString(string: _plainText)
            }
            default:
                throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
        }
        
        _hexDocumentContents = _theData
    }
    
    // this function updates the character count
    @objc private func _refreshCharacterCount(_ obj: Notification? = nil)
    {
        // calculate the total character length and amount of words in the document
        let _characterLength = self.hexeTextView.string.count
        let _numberOfWords = self.hexeTextView.string.split(separator: " ").count
        
        // calculate the amount of lines in the document
        guard let _numberOfGlyphs = self.hexeTextView.layoutManager?.numberOfGlyphs else { NSLog("Error - there's no text view!"); return }
        var _index = 0, _numberOfLines = 0
        var lineRange = NSRange(location: NSNotFound, length: 0)
        
        while _index < _numberOfGlyphs
        {
            self.hexeTextView.layoutManager?.lineFragmentRect(forGlyphAt: _index, effectiveRange: &lineRange)
            _index = NSMaxRange(lineRange)
            _numberOfLines += 1
        }
        
        var _characterText = "characters"
        var _wordText = "words"
        var _linesText = "lines"
        
        if _characterLength == 1
        {
            _characterText = "character"
        }
        
        if _numberOfWords == 1
        {
            _wordText = "word"
        }
        
        if _numberOfLines == 1
        {
            _linesText = "line"
        }
        
        // if we are dealing with more than zero characters and we got a change notification, this means a change has been performed
        if _characterLength > 0 && obj != nil
        {
            self.updateChangeCount(NSDocument.ChangeType.changeDone)
        }
        
        self.hexeStatusField.stringValue = "\(_numberOfLines) \(_linesText), \(_numberOfWords) \(_wordText), \(_characterLength) \(_characterText)"
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if keyPath == Preferences.DASettingsKeyShowLineCount
        {
            guard keyPath == Preferences.DASettingsKeyShowLineCount,
                  let change = change else {
                    return
            }
            
            if change[.newKey] as? Bool == true
            {
                self.hexeTextView.lnv_setUpLineNumberView()
            }
            else
            {
                self.hexeTextView.lnv_destroyLineNumberView()
            }
        }
        
        // use the language string value here
    }
}

