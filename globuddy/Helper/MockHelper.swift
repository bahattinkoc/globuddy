//
//  MockHelper.swift
//  globuddy
//
//  Created by BAHATTIN KOC on 27.11.2024.
//

struct ProfileModel {
    let imageName: String
    let name: String
    let description: String
    let latitude: Double
    let longitude: Double
}

final class MockHelper {

    // MARK: - PROPERTIES

    static let mockUserList = [
        ProfileModel(imageName: "bahattin", name: "Bahattin Koc", description: "iOS Developer", latitude: 40.7128, longitude: -74.0060),
        ProfileModel(imageName: "cook", name: "Tim Cook", description: "CEO of Apple", latitude: 35.6895, longitude: 139.6917),
        ProfileModel(imageName: "wozniak", name: "Steve Wozniak", description: "Co-founder of Apple", latitude: -33.8688, longitude: 151.2093),
        ProfileModel(imageName: "elon", name: "Elon Musk", description: "Artist", latitude: -33.9249, longitude: 18.4241),
        ProfileModel(imageName: "ironman", name: "Iron Man", description: "Billioner", latitude: -22.9068, longitude: -43.1729),
        ProfileModel(imageName: "thor", name: "Thor", description: "God of Lightning", latitude: 34.0522, longitude: -118.2437),
        ProfileModel(imageName: "hulk", name: "Bruce Banner", description: "Scientist", latitude: 51.5074, longitude: -0.1278),
        ProfileModel(imageName: "spiderman", name: "Peter Parker", description: "Neighborhood", latitude: 35.6895, longitude: 139.6917),
        ProfileModel(imageName: "camerica", name: "Steve", description: "Soldier", latitude: -33.8688, longitude: 151.2093),
        ProfileModel(imageName: "bpanter", name: "Black Panter", description: "Rich", latitude: 78.8566, longitude: 2.3522)
    ]
}
