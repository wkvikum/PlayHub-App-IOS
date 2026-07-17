//
//  QuizAPI.swift
//  PlayHubApp
//
//  Created by W.K.W.D.M on 2026-07-17.
//

import Foundation

// Custom errors to help handle issues gracefully in the UI
enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
}

class NetworkService {
    // Keep your URL in one designated place
    private let urlString = "https://opentdb.com/api.php?amount=10&type=multiple"
    
    // The single async function returning an array of Questions
    func fetchQuestions() async throws -> [Question] {
        // 1. Validate the URL
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        // 2. Fetch data from the network
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // 3. Verify it's a valid HTTP response (status code 200 OK)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        // 4. Decode the JSON payload
        do {
            let decoder = JSONDecoder()
            // Using the outer wrapper model we built in Step 1
            let decodedResponse = try decoder.decode(QuizResponse.self, from: data)
            return decodedResponse.results
        } catch {
            throw NetworkError.decodingError
        }
    }
}

