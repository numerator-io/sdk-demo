    Demo: Integrating numerator-sdk

    * Create Project: Demo Game Pet
    -> Create Flag
        -> enable_land_pet of type Boolean
            -> Set [variation on] is TRUE
            -> Set [variation off] is FALSE
        -> rare_animal of type String
            -> Set [variation on] is "Animal"
            -> Set [variation off] is "Not Animal"
            -> Set [variation not match] "This is a normal Animal"
            -> Set [variation match] "This is a rare Animal"
    -> Create Condition Key
        -> key: "rare_animal"
        -> Description: "Condition for Rare animal"
        -> Type STRING
    -> Set Condition for rare_animal
        -> Set Condition for variation : [variation_match]
            -> with name "Land Rare Animal Condition"
            -> priority 1
            -> Conditions
                -> Group Operator: OR
                -> Group Condition
                    -> Key: rare_animal
                    -> Operator: EQUALS
                    -> Value: lion

                    -> Key: rare_animal
                    -> Operator: EQUALS
                    -> Value: deer


    -------------------------------------------------------------------------------------

    * Present: How the Flag Work
    - Test Case for enable_land_pet

    Scenario 1:
    Given:
        enable_land_pet status is ON
    When:
        1. Open browser
        2. go to the page "./index.html"
    Then:
        1. Play a game -> "Guess the names of land animals"

    Scenario 2:
    Given:
        enable_land_pet status is OFF
    When:
        1. Open browser
        2. go to the page "./index.html"
    Then:
        1. Play a game -> "Guess the names of sea animals"

    -------------------------------------------------------------------------------------

    *Present: How the flag: [rare_animal] Work
    - Test Case: rare_animal with Condition

    Scenario 1:
    Given:
        rare_animal status is ON
        context {rare_animal : "guess_name"}
    When:
        1. When user play the game
        2. if user not win the game
    Then:
        1. Game is show a text highlight -> "Animal"

    Scenario 2:
    Given:
        rare_animal status is ON
        context {rare_animal : "guess_name"}
    When:
        1. When user play the game
        2. if user win the game
        3. and the [guess_name] match with "lion" or "deer"
    Then:
        1. Game is show a text highlight -> "This is a rare Animal"

    Scenario 3:
    Given:
        rare_animal status is OFF
        context {rare_animal : "guess_name"}
    When:
        1. When user play the game
        2. if user not win the game
    Then:
        1. Game is show a text highlight -> "Not Animal"

    Scenario 4:
    Given:
        rare_animal status is OFF
        context {rare_animal : "guess_name"}
    When:
        1. When user play the game
        2. if user win the game
        3. and the [guess_name] match with "lion" or "deer"
    Then:
        1. Game is show a text highlight -> "Not Animal"