import { questionBank, getQuestionsByYear } from './data/questions.js';

class ExamApp {
    constructor() {
        this.currentQuestions = [];
        this.currentIndex = 0;
        this.userAnswers = {};
        this.statuses = {}; // 'unanswered', 'answered', 'review'
        this.timer = null;
        this.secondsRemaining = 180 * 60; // 3 hours
        
        this.init();
    }

    init() {
        this.showView('dashboard');
    }

    showView(id) {
        document.querySelectorAll('.view').forEach(v => v.classList.remove('active'));
        document.getElementById(id).classList.add('active');
        
        // Timer visibility
        document.getElementById('exam-timer').style.display = (id === 'exam-mode') ? 'block' : 'none';
    }

    startMockTest() {
        // Shuffle or take all questions for mock test
        this.currentQuestions = [...questionBank];
        this.resetExamState();
        this.showView('exam-mode');
        this.renderQuestion();
        this.startTimer();
    }

    loadPYQ(year) {
        if (!year) return;
        this.currentQuestions = getQuestionsByYear(year);
        if (this.currentQuestions.length === 0) {
            alert('No questions found for this year yet.');
            return;
        }
        this.resetExamState();
        this.showView('exam-mode');
        this.renderQuestion();
        this.startTimer();
    }

    resetExamState() {
        this.currentIndex = 0;
        this.userAnswers = {};
        this.statuses = this.currentQuestions.reduce((acc, _, i) => {
            acc[i] = 'unanswered';
            return acc;
        }, {});
        this.secondsRemaining = 180 * 60;
    }

    renderQuestion() {
        const q = this.currentQuestions[this.currentIndex];
        document.getElementById('q-number').textContent = `Question ${this.currentIndex + 1}`;
        document.getElementById('q-paper').textContent = q.paper;
        document.getElementById('q-topic').textContent = q.topic;
        document.getElementById('q-text').textContent = q.question;

        const optionsContainer = document.getElementById('options-container');
        optionsContainer.innerHTML = '';
        
        q.options.forEach(opt => {
            const div = document.createElement('div');
            div.className = `option-item ${this.userAnswers[this.currentIndex] === opt ? 'selected' : ''}`;
            div.innerHTML = `
                <div class="option-radio"></div>
                <div class="option-text">${opt}</div>
            `;
            div.onclick = () => this.selectOption(opt);
            optionsContainer.appendChild(div);
        });

        this.renderPalette();
    }

    selectOption(opt) {
        this.userAnswers[this.currentIndex] = opt;
        this.statuses[this.currentIndex] = 'answered';
        this.renderQuestion();
    }

    clearResponse() {
        delete this.userAnswers[this.currentIndex];
        this.statuses[this.currentIndex] = 'unanswered';
        this.renderQuestion();
    }

    markForReview() {
        this.statuses[this.currentIndex] = 'review';
        this.nextQuestion();
    }

    nextQuestion() {
        if (this.currentIndex < this.currentQuestions.length - 1) {
            this.currentIndex++;
            this.renderQuestion();
        }
    }

    prevQuestion() {
        if (this.currentIndex > 0) {
            this.currentIndex--;
            this.renderQuestion();
        }
    }

    jumpToQuestion(index) {
        this.currentIndex = index;
        this.renderQuestion();
    }

    renderPalette() {
        const palette = document.getElementById('q-palette');
        palette.innerHTML = '';
        
        this.currentQuestions.forEach((_, i) => {
            const div = document.createElement('div');
            div.className = `palette-item ${this.statuses[i]} ${this.currentIndex === i ? 'current' : ''}`;
            div.textContent = i + 1;
            div.onclick = () => this.jumpToQuestion(i);
            palette.appendChild(div);
        });
    }

    startTimer() {
        if (this.timer) clearInterval(this.timer);
        this.timer = setInterval(() => {
            this.secondsRemaining--;
            if (this.secondsRemaining <= 0) {
                this.submitExam();
            } else {
                this.updateTimerDisplay();
            }
        }, 1000);
    }

    updateTimerDisplay() {
        const h = Math.floor(this.secondsRemaining / 3600);
        const m = Math.floor((this.secondsRemaining % 3600) / 60);
        const s = this.secondsRemaining % 60;
        document.getElementById('timer-val').textContent = 
            `${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}`;
    }

    submitExam() {
        clearInterval(this.timer);
        const results = this.calculateResults();
        this.showResults(results);
    }

    calculateResults() {
        let correct = 0;
        this.currentQuestions.forEach((q, i) => {
            if (this.userAnswers[i] === q.correctAnswer) {
                correct++;
            }
        });
        const total = this.currentQuestions.length;
        const wrong = Object.keys(this.userAnswers).length - correct;
        
        return {
            correct,
            wrong,
            score: correct * 2,
            accuracy: total > 0 ? (correct / total * 100).toFixed(1) : 0
        };
    }

    showResults(res) {
        this.showView('result-view');
        document.getElementById('res-score').textContent = res.score;
        document.getElementById('res-correct').textContent = res.correct;
        document.getElementById('res-wrong').textContent = res.wrong;
        document.getElementById('res-accuracy').textContent = `${res.accuracy}%`;

        const reviewList = document.getElementById('review-list');
        reviewList.innerHTML = '<h3>Question Review</h3>';
        
        this.currentQuestions.forEach((q, i) => {
            const div = document.createElement('div');
            div.className = 'review-item';
            div.style.marginBottom = '20px';
            div.style.padding = '15px';
            div.style.border = '1px solid #eee';
            div.style.borderRadius = '8px';
            
            const isCorrect = this.userAnswers[i] === q.correctAnswer;
            
            div.innerHTML = `
                <p><strong>Q${i+1}:</strong> ${q.question}</p>
                <p class="${isCorrect ? 'text-success' : 'text-error'}">
                    Your Answer: ${this.userAnswers[i] || 'Not Answered'}
                </p>
                ${!isCorrect ? `<p class="text-success">Correct Answer: ${q.correctAnswer}</p>` : ''}
                <div style="background: #f9f9f9; padding: 10px; margin-top: 10px; font-size: 14px;">
                    <strong>Explanation:</strong> ${q.explanation}
                </div>
            `;
            reviewList.appendChild(div);
        });
    }

    showDashboard() {
        this.showView('dashboard');
    }
}

// polyfill for padLeft if needed (though modern browsers have padStart)
String.prototype.padLeft = function(n, c) {
    var s = this, c = c || '0';
    while (s.length < n) s = c + s;
    return s;
};

// Global instance
window.app = new ExamApp();
