//
//  SearchViewModel.swift
//  Swifty-Companion
//
//  Created by Tom Ecker on 29.07.26.
//

import Observation

@Observable
class SearchViewModel {
    var searchText: String = ""
    var activeUser: UserData? = nil
    private let apiService: ApiService
    private(set) var history: [UserData] = []
    var state: SearchState = .idle
    
    init(apiService: ApiService) {
        self.apiService = apiService
        
//        let tempUser1 = UserData(
//            id: "jdoe",
//            login: "jdoe",
//            email: "jdoe@student.42.fr",
//            pictureLink: "https://cdn.intra.42.fr/users/default.png",
//            firstName: "John",
//            lastName: "Doe",
//            campusCity: "Paris",
//            start: "2024-01-15T10:00:00.000Z",
//            level: 8.42,
//            skills: [
//                Skill(id: 1, level: 5.2, name: "Algorithms & AI"),
//                Skill(id: 2, level: 4.8, name: "Graphics")
//            ],
//            projects: [
//                Project(finalGrade: 125, projectName: "libft", projectValidated: true),
//                Project(finalGrade: 100, projectName: "ft_printf", projectValidated: true)
//            ]
//        )
        
        let tempUser2 = UserData(
            id: "asmith",
            login: "asmith",
            email: "asmith@student.42.fr",
            pictureLink: "https://cdn.intra.42.fr/users/default.png",
            firstName: "Alice",
            lastName: "Smith",
            campusCity: "Berlin",
            evalPoints: 4,
            grade: "Learner",
            start: "2024-03-20T09:30:00.000Z",
            level: 6.25,
            skills: [
                Skill(id: 3, level: 3.7, name: "Unix"),
                Skill(id: 4, level: 7.2, name: "Rigor")
            ],
            projects: [
                Project(id: "get_next_line", finalGrade: nil, name: "get_next_line", isValidated: nil),
                Project(id: "Born2beroot", finalGrade: 84, name: "Born2beroot", isValidated: true)
            ]
        )
        
        history = [tempUser2]
    }
    
    public func addHistory(user: UserData) {
        if !history.contains(where: { $0.id == user.id }) {
            history.insert(user, at: 0)
        }
    }
    public func clearHistory() {
        history.removeAll()
    }
    
    public func selectUser (user: UserData) {
        activeUser = user
    }
    
    public func search() async throws {
        print("Searching for \(searchText)")
        state = .loading
        do {
            let profileInfo = try await apiService.getUserInfo(userName: searchText.lowercased())
            print(profileInfo)
            addHistory(user: profileInfo)
            activeUser = profileInfo
            state = .idle
            searchText = ""
            print("Found user: \(profileInfo.login)")
        } catch {
            state = .error(error)
        }
    }
}
