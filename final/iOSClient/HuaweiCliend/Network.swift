//
//  Newtowk.swift
//  HuaweiCliend
//
//  Created by Amin Benarieb on 3/27/17.
//  Copyright © 2017 Amin Benarieb. All rights reserved.
//

import Foundation
import Alamofire

typealias NetworkCompletion = (Any?, NetworkError?) -> (Void)

enum NetworkError {
	case invalidRequest
	case unauthorized
	case failedRequest
	case unknown
	case unreachable
	case notFound
}

class Network : NSObject, URLSessionDelegate {

	func sendRequest(url : String, jsonData : Data, token : String? = nil, completion : @escaping NetworkCompletion) {
		
		guard let url = URL(string: url) else {
			completion(nil, .invalidRequest)
			return
		}
		
		let defaultConfigObject = URLSessionConfiguration.default
		let defaultSession = URLSession(configuration: defaultConfigObject,
		                                delegate: self,
		                                delegateQueue: OperationQueue.main)
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.httpBody = jsonData
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		if let token = token {
			request.addValue(token, forHTTPHeaderField: "X-Auth-Token")
		}
		let task = defaultSession.dataTask(with: request) { data, response, error in
			guard let data = data else {
				completion(nil, .unreachable)
				return
			}
			
			guard error == nil else {
				completion(nil, .failedRequest)
				return
			}
			
			let httpStatus = response as? HTTPURLResponse
			guard httpStatus?.statusCode == 200 else {
				switch(httpStatus?.statusCode ?? 0){
				case 401:
					completion(data, .unauthorized)
				default:
					completion(data, .unknown)
				}
				return
			}
			
			completion(data, nil)
			
		}
		task.resume()
	}
	func sendRequest(url : String, token : String? = nil, completion : @escaping NetworkCompletion) {
		guard let url = URL(string: url) else {
			completion(nil, .invalidRequest)
			return
		}
		
		
		let defaultConfigObject = URLSessionConfiguration.default
		let defaultSession = URLSession(configuration: defaultConfigObject,
		                                delegate: self,
		                                delegateQueue: OperationQueue.main)
		
		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		if let token = token {
			request.addValue(token, forHTTPHeaderField: "X-Auth-Token")
		}
		let task = defaultSession.dataTask(with: request) { data, response, error in
			guard let data = data else {
				completion(nil, .unreachable)
				return
			}
			
			guard error == nil else {
				completion(nil, .failedRequest)
				return
			}
			
			let httpStatus = response as? HTTPURLResponse
			guard httpStatus?.statusCode == 200 else {
				switch(httpStatus?.statusCode ?? 0){
				case 401:
					completion(nil, .unauthorized)
				case 404:
					completion(nil, .notFound)
				default:
					completion(nil, .unknown)
				}
				return
			}
			
			completion(data, nil)
			
		}
		task.resume()
		
	}
	
	// MARK : Delegate
	
	func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
		
		completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
	}
	
	
}
