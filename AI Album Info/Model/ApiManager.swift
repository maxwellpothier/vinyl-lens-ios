//
//  ApiManager.swift
//  AI Album Info
//
//  Created by Max Pothier on 7/15/23.
//

import Foundation

struct Environment {
    static var OPENAI_API_KEY: String {
        return "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"
    }
}

struct RequestData: Encodable {
    let model: String
    let prompt: String
    let temperature: Float
    let max_tokens: Int
}

struct ApiManager {
    
    func generateIGCaption(title: String, completion: @escaping (String?) -> Void) {
        let aiPrompt = "You're a record store owner, hoping to help others understand the meaning and backstory of each album in your shop. A customer shows you the album \(title) and asks you about it. Give an overview of the album and the artist who created it."

        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Authorization": "Bearer \(Environment.OPENAI_API_KEY)"]

        let session = URLSession(configuration: config)
        let url = URL(string: "https://api.openai.com/v1/completions")!

        let requestData = RequestData(model: "text-davinci-003",
                                      prompt: aiPrompt,
                                      temperature: 0.9,
                                      max_tokens: 1024)
        
        do {
            let jsonData = try JSONEncoder().encode(requestData)
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            let task = session.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    completion(nil)
                } else if let data = data {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            if let choices = json["choices"] as? [[String: Any]], let firstChoice = choices.first, let text = firstChoice["text"] as? String {
                                completion(text)
                            }
                        }
                    } catch {
                        completion(nil)
                    }
                }
            }

            
            task.resume()
        } catch {
            print("Error generating the request")
            completion(nil)
        }
    }
}
