import Foundation
import SwiftUI
import Combine

@MainActor
final class QuizRushVM: ObservableObject {
    
    enum State {
        case loading
        case loaded
        case failed(String)
        case finished
    }
    
    @Published var state: State = .loading
    
    @Published var questions: [TriviaQuestion] = []
    @Published var index: Int = 0
    @Published var score: Int = 0
    @Published var streak: Int = 0
    @Published var correctCount: Int = 0
    @Published var selectedAnswer: String? = nil
    @Published var answerWasCorrect = false
    @Published var showAnswerAnimation = false
    
    @Published var highScore = 0

    init() {
        refreshHighScore()
    }
    
    var currentQuestion: TriviaQuestion? {
        guard index < questions.count else { return nil }
        return questions[index]
    }
    
    func load() async {
        state = .loading
        refreshHighScore()
        
        do {
            let fetched = try await TriviaAPI.shared.fetchQuestions()
            
            questions = fetched
            index = 0
            score = 0
            streak = 0
            correctCount = 0
            
            state = .loaded
        } catch {
            state = .failed("Failed to load quiz. Check internet.")
        }
    }
    func answer(_ selected: String) {

        guard let question = currentQuestion else { return }

        selectedAnswer = selected

        let isCorrect = selected == question.correct_answer

        answerWasCorrect = isCorrect

        withAnimation {
            showAnswerAnimation = true
        }

        if isCorrect {

            streak += 1
            correctCount += 1
            score += 10 + (streak * 2)

        } else {

            streak = 0
            score -= 2

        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {

            self.showAnswerAnimation = false
            self.selectedAnswer = nil
            self.next()

        }
    }

    private func next() {
        index += 1
        
        if index >= questions.count {
            state = .finished
            saveSession()
        }
    }
    
    func retry() async {
        await load()
    }
    private func saveSession() {
        
        let session = GameSession(
            id: UUID(),
            mode: .quizRush,
            score: score,
            timestamp: Date(),
            latitude: LocationService.shared.latitude,
            longitude: LocationService.shared.longitude
        )
        
        
        GameStorage.shared.saveSession(session)
        refreshHighScore()
        
    }

    private func refreshHighScore() {
        highScore = GameStorage.shared.bestScore(for: .quizRush)
    }
}
