//
//  WebCoverView.swift
//  SecretCamera
//
//  Created by Hung on 9/25/17.
//  Copyright © 2017 Hung. All rights reserved.
//

import UIKit
import WebKit

class WebCoverView: UIView {

    fileprivate var progressView: UIProgressView?
    fileprivate var webView: WKWebView?
    fileprivate var barView: UIView?
    
    override func draw(_ rect: CGRect) {
        setUpWebView(rect)
        super.draw(rect)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView?.isHidden = webView?.estimatedProgress == 1
            progressView?.setProgress(Float(webView?.estimatedProgress ?? 0), animated: true)
        }
    }
    
    func load(_ link: String) {
        var link = link
        if !link.contains("https://") {
            link = "https://" + link.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if let url = URL(string: link) {
            let urlRequest = URLRequest(url: url)
            webView?.load(urlRequest)
        }
    }
}

// MARK: - Private methods
private extension WebCoverView {
    
    func setUpWebView(_ rect: CGRect) {
        barView = UIView(frame: CGRect(x: 0, y: rect.size.height - 49, width: rect.size.width, height: 49))
        barView?.backgroundColor = UIColor.white
        if let barView = barView {
            addSubview(barView)
            setUpEvents(barView: barView)
        }
        
        webView = WKWebView(frame: CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width, height: rect.size.height - 49))
        webView?.navigationDelegate = self
        webView?.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        insertSubview(webView!, belowSubview: barView!)
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView?.frame = CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width, height: 2)
        progressView?.progress = 0
        insertSubview(progressView!, aboveSubview: webView!)
    }
}

// MARK: WKNavigationDelegate
extension WebCoverView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        if let viewController = self.superview?.superview?.parentViewController {
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView?.setProgress(0.0, animated: false)
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
    }
}

// MARK: - Gesture
private extension WebCoverView {
    func setUpEvents(barView: UIView) {

        // Swipe Right Gesture
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight(_:)))
        swipeRightGesture.direction = .right
        barView.addGestureRecognizer(swipeRightGesture)
        
        // Swipe Left Gesture
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft(_:)))
        swipeLeftGesture.direction = .left
        barView.addGestureRecognizer(swipeLeftGesture)
    }
    
    // @objc methods
    @objc
    private func handleSwipeRight(_ sender: UISwipeGestureRecognizer) {
        if self.alpha == 1 {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.25, animations: {
                    self.alpha = 0.011
                })
            }
        }
    }
    
    @objc
    private func handleSwipeLeft(_ sender: UISwipeGestureRecognizer) {
        if self.alpha <= 0.011 {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.25, animations: {
                    self.alpha = 1
                })
            }
        }
    }
}
