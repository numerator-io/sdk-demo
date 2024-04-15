async function getFlagFromAPI() {
    try {
        const response = await fetch('http://127.0.0.1:8080/land-pet', {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json'
            }
        });
        if (!response.ok) {
            document.getElementById('error-message').textContent = `Error: flag is not available.`;
            document.getElementById('error-message').style.display = 'block';
        }
        const data = await response.json();
        const flag = data.land_pet === "true";
        console.log(`Flag is enable: ${flag}`);
        return flag
    } catch (error) {
        document.getElementById('error-message').textContent = `Error: ${error.message}`;
        document.getElementById('error-message').style.display = 'block';
    }
}

async function getRarePetFromAPI(guessName) {
    try {
        const response = await fetch(
            'http://127.0.0.1:8080/rare-animal?guess=' + guessName,
            {
                method: 'GET',
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json'
                }
            }
        );
        if (!response.ok) {
            document.getElementById('error-message').textContent = `Error: rare of flag is not available.`;
            document.getElementById('error-message').style.display = 'block';
        }
        const data = await response.json();
        const rareAnimal = data.rare_animal;
        console.log(`rare animal is: ${rareAnimal}`);
        return rareAnimal
    } catch (error) {
        document.getElementById('error-message').textContent = `Error: ${error.message}`;
        document.getElementById('error-message').style.display = 'block';
    }
}

async function getPets() {
    document.getElementById('loading').style.display = 'block';
    try {
        const flag = await getFlagFromAPI();
        if (flag) {
            isLandPet = true;
            currentTitle = "What kind of land animal is it?";
            updateTitle();
            return land_pets;
        }
        isLandPet = false;
        currentTitle = "What kind of sea animal is it?";
        updateTitle();
        return sea_pets;
    } finally {
        document.getElementById('loading').style.display = 'none';
    }
}

async function getRarePet(guessName) {
    document.getElementById('loading').style.display = 'block';
    try {
        currentRarePet = await getRarePetFromAPI(guessName);
        updateRarePet();
    } finally {
        document.getElementById('loading').style.display = 'none';
    }
}

function updateTitle() {
    document.getElementById('title').textContent = currentTitle;
    document.getElementById('title').style.color = isLandPet ? 'green' : 'orange';
    document.getElementById('title_header').textContent = currentTitle;
}

function updateRarePet() {
    // const shouldShow = currentRarePet === 'This is a rare Animal' ? 'block' : 'none';
    document.getElementById('special-text').textContent = currentRarePet;
    document.getElementById('special-text').style.display = 'block';
}

const land_pets = [
    {name: "Cat", image: "cat.jpg"},
    {name: "Dog", image: "dog.jpg"},
    {name: "Rabbit", image: "rabbit.jpg"},
    {name: "Lion", image: "lion.jpg"},
    {name: "Deer", image: "deer.jpg"},
];

const sea_pets = [
    {name: "Seal", image: "seal.jpg"},
    {name: "Shark", image: "shark.jpg"},
    {name: "Whale", image: "whale.jpg"},
    {name: "Starfish", image: "starfish.jpg"},
    {name: "Penguin", image: "penguin.jpg"},
];

function shuffleArray(array) {
    for (let i = array.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1));
        [array[i], array[j]] = [array[j], array[i]];
    }
}

let currentPetIndex;
let currentTitle;
let currentRarePet;
let isLandPet = false;

function initGame(_pets) {
    currentPetIndex = Math.floor(Math.random() * _pets.length);
    document.getElementById('pet-image').src = `images/${_pets[currentPetIndex].image}`;
}

async function checkGuess(guess, _pets) {
    _pets = isLandPet ? land_pets : sea_pets;
    const guessLowerCase = guess.toLowerCase();
    console.log(`User guess: ${guess}`);
    console.log(`Current pet: ${_pets[currentPetIndex].name.toLowerCase()}`);
    if (guessLowerCase === _pets[currentPetIndex].name.toLowerCase()) {
        document.getElementById('result').textContent = "Correct!";
        console.log("Guess is correct");
        disableInput();
        document.getElementById('play-again-btn').style.display = 'inline';
        document.getElementById('submit-btn').style.display = 'none';
        document.getElementById('guess-input').style.display = 'none';
        document.getElementById('pet-image').classList.add('correct-animation');
        await getRarePet(guessLowerCase);
    } else {
        document.getElementById('result').textContent = "Incorrect! Try again.";
        console.log("Guess is incorrect");
    }
}

function resetGame() {
    document.getElementById('guess-input').value = "";
    document.getElementById('result').textContent = "";
    enableInput();
    document.getElementById('play-again-btn').style.display = 'none';
    document.getElementById('special-text').style.display = 'none';
    document.getElementById('submit-btn').style.display = 'inline';
    document.getElementById('guess-input').style.display = 'inline';
    initGame(isLandPet ? land_pets : sea_pets);
}

function playAgain() {
    resetGame();
}

function disableInput() {
    document.getElementById('guess-input').disabled = true;
}

function enableInput() {
    document.getElementById('guess-input').disabled = false;
}

window.addEventListener('DOMContentLoaded', async () => {
    try {
        const pets = await getPets();
        shuffleArray(sea_pets)
        initGame(pets);
    } catch (error) {
        console.error(`There was an error while getting pets: ${error.message}`);
    }
});