import Foundation

// MARK: - Models

struct SessionResponse: Codable {
    let idSession: Int
    let titre: String
    let lieu: String
    let dateDebut: String
    let dateFin: String
    let description: String
    let comission: String
    
    // This field may not always be present, so make it optional
    let descriptionPeriode: String?
}

struct CreateSessionRequest: Codable {
    let titre: String
    let lieu: String
    let dateDebut: String
    let dateFin: String
    let description: String
    let comission: Int
}

struct UpdateSessionRequest: Codable {
    let id: Int
    let titre: String
    let lieu: String
    let dateDebut: String
    let dateFin: String
    let description: String
    let comission: Int
}

struct SearchSessionRequest: Codable {
    let titre: String?
    let lieu: String?
    let dateDebut: String?
    let dateFin: String?
    
    init(titre: String? = nil, lieu: String? = nil, dateDebut: String? = nil, dateFin: String? = nil) {
        self.titre = titre
        self.lieu = lieu
        self.dateDebut = dateDebut
        self.dateFin = dateFin
    }
}

struct DeleteSessionRequest: Codable {
    let id: Int
}

enum SessionServiceError: Error {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case httpError(Int)
    case invalidResponse
    case unauthorized
    case noSessionAvailable
    case emptyResponse
}

// MARK: - Session Service

class SessionService {
    private let baseURL: String
    private var authToken: String?
    
    init() {
        // Get API URL from Config.xcconfig
        if let apiURL = Bundle.main.infoDictionary?["API_URL"] as? String {
            self.baseURL = apiURL
        } else {
            // Fallback in case the config isn't available
            self.baseURL = "https://backjeutaro-e8bf61eb52f5.herokuapp.com"
        }
    }
    
    // Set auth token after user logs in
    func setAuthToken(_ token: String) {
        self.authToken = token
    }
    
    // MARK: - API Calls
    
    /// Gets the next upcoming session
    /// - Returns: The next session (first item in the array returned by the API)
    func getNextSession() async throws -> SessionResponse {
        let sessions: [SessionResponse] = try await performRequest(
            endpoint: "/session/NextSession", 
            method: "GET"
        )
        
        if sessions.isEmpty {
            throw SessionServiceError.noSessionAvailable
        }
        
        return sessions[0]
    }
    
    /// Gets the current active session if one exists
    /// - Returns: The active session or nil if none exists
    func getActualSession() async throws -> SessionResponse? {
        do {
            let sessions: [SessionResponse] = try await performRequest(
                endpoint: "/session/ActualSession", 
                method: "GET"
            )
            
            if sessions.isEmpty {
                return nil
            }
            
            return sessions[0]
        } catch SessionServiceError.emptyResponse {
            return nil
        } catch {
            throw error
        }
    }
    
    /// Creates a new session (requires authentication)
    func createSession(_ session: CreateSessionRequest) async throws -> SessionResponse {
        return try await performRequest(
            endpoint: "/session/CreateSession", 
            method: "POST", 
            body: session, 
            requiresAuth: true
        )
    }
    
    /// Updates an existing session (requires authentication)
    func updateSession(_ session: UpdateSessionRequest) async throws -> SessionResponse {
        return try await performRequest(
            endpoint: "/session/UpdateSession", 
            method: "PUT", 
            body: session, 
            requiresAuth: true
        )
    }
    
    /// Deletes a session by ID (requires authentication)
    func deleteSession(id: Int) async throws -> Bool {
        let response: [String: Bool] = try await performRequest(
            endpoint: "/session/DeleteSession", 
            method: "POST", 
            body: DeleteSessionRequest(id: id), 
            requiresAuth: true
        )
        return response["result"] ?? false
    }
    
    /// Gets a filtered list of sessions (requires authentication)
    func getSessionList(_ searchParams: SearchSessionRequest = SearchSessionRequest()) async throws -> [SessionResponse] {
        return try await performRequest(
            endpoint: "/session/GetListSession", 
            method: "POST", 
            body: searchParams, 
            requiresAuth: true
        )
    }
    
    // MARK: - Helper Methods
    
    // Overload for requests WITH a body
    private func performRequest<T: Decodable, B: Encodable>(
        endpoint: String,
        method: String,
        body: B,
        requiresAuth: Bool = false
    ) async throws -> T {
        guard let url = URL(string: baseURL + endpoint) else {
            throw SessionServiceError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if requiresAuth {
            guard let token = authToken else {
                throw SessionServiceError.unauthorized
            }
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let encoder = JSONEncoder()
        request.httpBody = try encoder.encode(body)
        
        return try await performRequest(request: request)
    }
    
    // Overload for requests WITHOUT a body
    private func performRequest<T: Decodable>(
        endpoint: String,
        method: String,
        requiresAuth: Bool = false
    ) async throws -> T {
        guard let url = URL(string: baseURL + endpoint) else {
            throw SessionServiceError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if requiresAuth {
            guard let token = authToken else {
                throw SessionServiceError.unauthorized
            }
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        return try await performRequest(request: request)
    }
    
    // Common implementation used by both overloads
    private func performRequest<T: Decodable>(request: URLRequest) async throws -> T {
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw SessionServiceError.invalidResponse
            }
            
            if httpResponse.statusCode < 200 || httpResponse.statusCode >= 300 {
                throw SessionServiceError.httpError(httpResponse.statusCode)
            }
            
            // Check for empty response
            if data.isEmpty {
                throw SessionServiceError.emptyResponse
            }
            
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch let decodingError as DecodingError {
            print("Decoding error: \(decodingError)")
            throw SessionServiceError.decodingError(decodingError)
        } catch {
            throw SessionServiceError.networkError(error)
        }
    }
}

// MARK: - Test Functions

// Add these functions to test the service without UI
extension SessionService {
    // Function to test getting actual session
    static func testGetActualSession() async {
        let service = SessionService()
        do {
            if let session = try await service.getActualSession() {
                print("✅ Actual Session found:")
                print("ID: \(session.idSession)")
                print("Titre: \(session.titre)")
                print("Description: \(session.description)")
            } else {
                print("ℹ️ No active session available")
            }
        } catch {
            print("❌ Error fetching actual session: \(error)")
        }
    }
    
    // Function to test getting next session
    static func testGetNextSession() async {
        let service = SessionService()
        do {
            let session = try await service.getNextSession()
            print("✅ Next Session:")
            print("ID: \(session.idSession)")
            print("Titre: \(session.titre)")
            print("Lieu: \(session.lieu)")
            print("Description: \(session.description)")
            print("Date début: \(session.dateDebut)")
            print("Date fin: \(session.dateFin)")
        } catch {
            print("❌ Error fetching next session: \(error)")
        }
    }
}

// MARK: - Command Line Entry Point


@main
struct SessionServiceRunner {
    static func main() async {
        print("🚀 Starting SessionService tests...")
        
        print("\n📝 Testing getActualSession:")
        await SessionService.testGetActualSession()
        
        print("\n📝 Testing getNextSession:")
        await SessionService.testGetNextSession()
        
        print("\n✅ Tests completed")
    }
}
