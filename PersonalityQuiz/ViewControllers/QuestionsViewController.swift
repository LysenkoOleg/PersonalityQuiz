//
//  QuestionsViewController.swift
//  PersonalityQuiz
//
//  Created by Олег Лысенко on 01.09.2021.
//

import UIKit

class QuestionsViewController: UIViewController {

    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var questionProgressView: UIProgressView!
    
    @IBOutlet var singleStackView: UIStackView!
    @IBOutlet var singleButtons: [UIButton]!
    
    @IBOutlet var multipleStackView: UIStackView!
    @IBOutlet var multipleLabels: [UILabel]!
    @IBOutlet var multipleSwitches: [UISwitch]!
    
    @IBOutlet var rangedStackView: UIStackView!
    @IBOutlet var rangedLabels: [UILabel]!
    @IBOutlet var rangedSlider: UISlider! {
        didSet {
            let answerCount = Float(currentAnswers.count - 1)
            rangedSlider.maximumValue = answerCount
            rangedSlider.value = answerCount / 2
        }
    }
    
    
    private let questions = Question.getQuestion()
    private var answersChosen: [Answer] = []
    private var currentAnswers: [Answer]{
        questions[questionIndex].answers
    }
    private var questionIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }
    
    @IBAction func singleAnswerButtonPressed(_ sender: UIButton) {
        guard let buttonIndex = singleButtons.firstIndex(of: sender) else { return }
        let currentAnswers = currentAnswers[buttonIndex]
        answersChosen.append(currentAnswers)
        
        nextQuestion()
    }
    
    @IBAction func multipleAnswerButtonPressed() {
        for (multipleSwitches, answer) in zip(multipleSwitches, currentAnswers){
            if multipleSwitches .isOn {
                answersChosen.append(answer)
            }
        }
        nextQuestion()
    }
    
    @IBAction func rangedAnswerButtonPressed() {
        let index = lrintf(rangedSlider.value)
        answersChosen.append(currentAnswers[index])
        nextQuestion()
    }
    
}

// MARK: - Private Methods
extension QuestionsViewController {
    private func updateUI() {
        for stackView in [singleStackView, multipleStackView, rangedStackView] {
            stackView?.isHidden = true
        }
        let currentQuestion = questions[questionIndex]
        
        questionLabel.text = currentQuestion.title
        
        let totalProgress = Float(questionIndex) / Float(questions.count)
        
        questionProgressView.setProgress(totalProgress, animated: true)
        
        title = "Вопрос № \(questionIndex + 1) из \(questions.count)"
        
        showCurrentAnswers(for: currentQuestion.type)
    }
    
    private func showCurrentAnswers(for type: ResponseType){
        switch type {
        case .single: showSingleStackView(for: currentAnswers)
        case .multiple: showMultipleStackView(for: currentAnswers)
        case .ranged: showRangedStackView(for: currentAnswers)
        }
    }
    
    private func showSingleStackView(for answers: [Answer]){
        singleStackView.isHidden.toggle()
        
        for (button, answer) in zip(singleButtons, answers){
            button.setTitle(answer.title, for: .normal)
        }
    }
    
    private func showMultipleStackView(for answers: [Answer]){
        multipleStackView.isHidden.toggle()
        
        for (label, answer) in zip(multipleLabels, answers){
            label.text = answer.title
        }
    }
    
    private func showRangedStackView(for answers: [Answer]){
        rangedStackView.isHidden.toggle()
        
        rangedLabels.first?.text = answers.first?.title
        rangedLabels.last?.text = answers.last?.title

    }
    
    private func nextQuestion() {
        questionIndex += 1
        
        if questionIndex < questions.count {
            updateUI()
            return
        }
        performSegue(withIdentifier: "showResult", sender: nil)
        
    }
}
