class Game {
    constructor() {
        this.homeScreen = document.getElementById('home-screen');
        this.matchingMenu = document.getElementById('matching-menu');
        this.gameScreen = document.getElementById('game-screen');
        this.grid = document.getElementById('game-grid'); // Reused for most game areas
        this.categoryTitle = document.getElementById('category-title');
        this.scoreDisplay = document.getElementById('score');

        this.score = 0;
        this.currentMode = null; // 'learn', 'matching', 'falling', 'balloon', 'shadow'
        this.currentCategory = null;
        this.synth = window.speechSynthesis;

        // Game specific state
        this.matchingState = { selectedLeft: null, matchesFound: 0 };
        this.fallingState = { interval: null, score: 0 };
    }

    // --- Navigation ---

    showHome() {
        this.homeScreen.classList.remove('d-none');
        this.matchingMenu.classList.add('d-none');
        this.gameScreen.classList.add('d-none');
        this.stopGames();
    }

    showHomeFromMenu() {
        this.matchingMenu.classList.add('d-none');
        this.homeScreen.classList.remove('d-none');
    }

    showMatchingMenu() {
        this.homeScreen.classList.add('d-none');
        this.matchingMenu.classList.remove('d-none');
    }

    showGameScreen(title) {
        this.homeScreen.classList.add('d-none');
        this.matchingMenu.classList.add('d-none');
        this.gameScreen.classList.remove('d-none');
        this.categoryTitle.textContent = title;
        this.score = 0;
        this.updateScore();
        this.grid.innerHTML = ''; // Clear previous game
        this.grid.className = 'game-grid'; // Reset class
    }

    stopGames() {
        if (this.fallingState.interval) clearInterval(this.fallingState.interval);
        // Clean up other game loops if any
    }

    // --- Learn Mode ---

    startLearn(category) {
        this.showGameScreen(category.charAt(0).toUpperCase() + category.slice(1));
        this.currentMode = 'learn';
        this.currentCategory = category;

        let items = [];
        if (category === 'alphabet') items = GameData.alphabet;
        else if (category === 'hindi') items = GameData.hindi;
        else if (category === 'numbers') {
            for (let i = 1; i <= 100; i++) items.push({ text: i.toString(), icon: '', color: this.getRandomColor() });
        } else if (category === 'tables') {
            for (let i = 1; i <= 20; i++) items.push({ text: i.toString(), icon: '', color: this.getRandomColor() });
        }

        this.renderLearnGrid(items);
        this.speak(`Let's learn ${category}!`);
    }

    renderLearnGrid(items) {
        this.grid.style.display = 'grid';
        this.grid.style.gridTemplateColumns = 'repeat(auto-fill, minmax(120px, 1fr))';

        items.forEach((item, index) => {
            const tile = document.createElement('div');
            tile.className = 'tile animate__animated animate__zoomIn';
            tile.style.backgroundColor = item.color || '#fff';
            tile.style.animationDelay = `${index * 0.02}s`;

            // Adjust styles for text-only items (Numbers/Tables)
            if (!item.icon) {
                tile.innerHTML = `<span class="tile-text" style="font-size: 2.5rem;">${item.text}</span>`;
            } else {
                tile.innerHTML = `
                    <span class="tile-icon">${item.icon}</span>
                    <span class="tile-text">${item.text}</span>
                 `;
            }

            tile.onclick = () => this.handleLearnClick(item, tile);
            this.grid.appendChild(tile);
        });
    }

    handleLearnClick(item, tile) {
        // Animation
        tile.classList.remove('animate__zoomIn');
        tile.classList.add('animate__pulse');
        setTimeout(() => tile.classList.remove('animate__pulse'), 500);

        if (this.currentCategory === 'tables') {
            this.showTable(item.text);
        } else {
            let textToSpeak = item.name || item.text;
            if (this.currentCategory === 'hindi' && item.audioText) textToSpeak = item.audioText;
            this.speak(textToSpeak);
        }
    }

    showTable(number) {
        // Simple alert or modal for now, or replace grid content temporarily
        let tableText = `Table of ${number}\n`;
        for (let i = 1; i <= 10; i++) {
            tableText += `${number} x ${i} = ${number * i}\n`;
        }
        alert(tableText); // Simple for now
        this.speak(`Table of ${number}`);
    }

    // --- Matching Mode ---

    startMatching(category) {
        this.showGameScreen(`Matching: ${category.charAt(0).toUpperCase() + category.slice(1)}`);
        this.currentMode = 'matching';
        this.matchingState = { selectedLeft: null, matchesFound: 0 };

        // Pick 4 random items
        const rawItems = GameData[category] || GameData.alphabet; // Fallback
        const shuffled = [...rawItems].sort(() => 0.5 - Math.random()).slice(0, 4);

        // Create left (text) and right (icon) arrays
        const leftItems = [...shuffled].sort((a, b) => a.text.localeCompare(b.text));
        const rightItems = [...shuffled].sort(() => 0.5 - Math.random());

        this.renderMatchingGame(leftItems, rightItems);
        this.speak("Match the items!");
    }

    renderMatchingGame(leftItems, rightItems) {
        this.grid.style.display = 'flex';
        this.grid.style.justifyContent = 'space-between';
        this.grid.innerHTML = '';

        const leftCol = document.createElement('div');
        leftCol.className = 'd-flex flex-column gap-3 w-40';

        const rightCol = document.createElement('div');
        rightCol.className = 'd-flex flex-column gap-3 w-40';

        leftItems.forEach(item => {
            const btn = document.createElement('button');
            btn.className = 'btn btn-lg btn-light w-100 py-3 border-2';
            btn.innerText = item.text;
            btn.dataset.value = item.text;
            btn.onclick = (e) => this.handleMatchLeft(e.target, item);
            leftCol.appendChild(btn);
        });

        rightItems.forEach(item => {
            const btn = document.createElement('button');
            btn.className = 'btn btn-lg btn-light w-100 py-3 border-2';
            btn.innerHTML = `<span style="font-size: 2rem">${item.icon}</span>`;
            btn.dataset.value = item.text; // Store text to match against
            btn.onclick = (e) => this.handleMatchRight(e.target, item);
            rightCol.appendChild(btn);
        });

        this.grid.appendChild(leftCol);
        this.grid.appendChild(rightCol);
    }

    handleMatchLeft(btn, item) {
        // Reset previous selection
        const prev = document.querySelector('.btn-warning');
        if (prev) prev.classList.remove('btn-warning');

        btn.classList.add('btn-warning');
        this.matchingState.selectedLeft = { btn, item };
        this.speak(item.name || item.text);
    }

    handleMatchRight(btn, item) {
        if (!this.matchingState.selectedLeft) {
            this.speak("Select a name first");
            return;
        }

        const left = this.matchingState.selectedLeft;
        if (left.item.text === item.text) {
            // Match!
            this.speak("Correct!");
            btn.classList.add('btn-success');
            left.btn.classList.remove('btn-warning');
            left.btn.classList.add('btn-success');

            // Disable buttons
            btn.disabled = true;
            left.btn.disabled = true;

            this.matchingState.selectedLeft = null;
            this.score += 10;
            this.updateScore();
            this.matchingState.matchesFound++;

            if (this.matchingState.matchesFound === 4) {
                this.celebrate();
            }
        } else {
            this.speak("Try again");
            btn.classList.add('btn-danger');
            setTimeout(() => btn.classList.remove('btn-danger'), 500);
        }
    }

    // --- Falling Text Game (Simplified) ---
    startFallingText() {
        this.showGameScreen("Falling Text");
        this.speak("Catch the falling letters!");
        this.grid.innerHTML = '<div id="game-area" style="position:relative; height: 60vh; background: #e0f7fa; overflow: hidden;"></div>';

        const area = document.getElementById('game-area');
        this.fallingState.score = 0;

        this.fallingState.interval = setInterval(() => {
            const char = String.fromCharCode(65 + Math.floor(Math.random() * 26));
            const el = document.createElement('div');
            el.innerText = char;
            el.style.position = 'absolute';
            el.style.left = Math.random() * 90 + '%';
            el.style.top = '-50px';
            el.style.fontSize = '2rem';
            el.style.fontWeight = 'bold';
            el.style.cursor = 'pointer';
            el.style.transition = 'top 3s linear';

            el.onclick = () => {
                this.speak(char);
                el.remove();
                this.score += 5;
                this.updateScore();
            };

            area.appendChild(el);

            // Trigger animation
            setTimeout(() => {
                el.style.top = '110%';
            }, 50);

            // Cleanup
            setTimeout(() => {
                if (el.parentNode) el.remove();
            }, 3000);

        }, 1000);
    }

    // --- Balloon Pop Game ---
    startBalloonPop() {
        this.showGameScreen("Balloon Pop");
        this.speak("Pop the balloons!");
        this.grid.innerHTML = '<div id="game-area" style="position:relative; height: 60vh; background: #ffebee; overflow: hidden;"></div>';

        const area = document.getElementById('game-area');

        this.fallingState.interval = setInterval(() => {
            const el = document.createElement('div');
            el.innerHTML = '🎈';
            el.style.position = 'absolute';
            el.style.left = Math.random() * 90 + '%';
            el.style.bottom = '-50px';
            el.style.fontSize = '3rem';
            el.style.cursor = 'pointer';
            el.style.transition = 'bottom 4s linear';

            el.onclick = () => {
                this.speak("Pop!");
                el.innerHTML = '💥';
                setTimeout(() => el.remove(), 200);
                this.score += 5;
                this.updateScore();
            };

            area.appendChild(el);

            setTimeout(() => el.style.bottom = '110%', 50);
            setTimeout(() => { if (el.parentNode) el.remove(); }, 4000);
        }, 800);
    }

    // --- Shadow Match (Stub) ---
    startShadowMatch() {
        // A simple version where you pick the correct shadow
        this.showGameScreen("Shadow Match");
        this.grid.innerHTML = '<div class="text-center p-5"><h2>Game coming soon!</h2></div>';
        this.speak("Select the correct shadow!");

        // Reuse matching logic concepts but with images
        // Implementation omitted for brevity, keeping it simple as stub for now or basic:

        const item = GameData.animals[Math.floor(Math.random() * GameData.animals.length)];
        this.grid.innerHTML = `
            <div class="text-center mb-5">
                <span style="font-size: 5rem; filter: brightness(0) blur(2px);">${item.icon}</span> <!-- Shadow -->
                <p>Who is this?</p>
            </div>
            <div class="d-flex justify-content-center gap-4">
               <!-- Options generated dynamically -->
            </div>
        `;

        // Better to implement fully if time, but sticking to basics for now due to file limits
    }


    // --- Utils ---
    getRandomColor() {
        const colors = ['#F44336', '#E91E63', '#9C27B0', '#673AB7', '#3F51B5', '#2196F3', '#03A9F4', '#00BCD4', '#009688', '#4CAF50', '#8BC34A', '#CDDC39', '#FFEB3B', '#FFC107', '#FF9800', '#FF5722'];
        return colors[Math.floor(Math.random() * colors.length)];
    }

    updateScore() {
        if (this.scoreDisplay) this.scoreDisplay.textContent = this.score;
    }

    speak(text) {
        if (this.synth.speaking) this.synth.cancel();
        const utterThis = new SpeechSynthesisUtterance(text);

        // Attempt to select a better voice
        if (this.currentCategory === 'hindi') {
            utterThis.lang = 'hi-IN';
        }

        utterThis.pitch = 1.1;
        utterThis.rate = 0.9;
        this.synth.speak(utterThis);
    }

    celebrate() {
        const modal = new bootstrap.Modal(document.getElementById('celebrationModal'));
        modal.show();
        this.speak("Amazing! You did it!");
        confetti({ particleCount: 150, spread: 80, origin: { y: 0.6 } });
    }
}

const game = new Game();
