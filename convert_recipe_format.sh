#!/bin/bash

# Define a function to replace fractions in a file
replace_fractions() {
    # Map fractions to their Unicode representations
    fractions_mapping_1_2="½"
    fractions_mapping_1_3="⅓"
    fractions_mapping_2_3="⅔"
    fractions_mapping_1_4="¼"
    fractions_mapping_3_4="¾"
    fractions_mapping_1_5="⅕"
    fractions_mapping_2_5="⅖"
    fractions_mapping_3_5="⅗"
    fractions_mapping_4_5="⅘"
    fractions_mapping_1_6="⅙"
    fractions_mapping_5_6="⅚"
    fractions_mapping_1_8="⅛"
    fractions_mapping_3_8="⅜"
    fractions_mapping_5_8="⅝"
    fractions_mapping_7_8="⅞"
    fractions_mapping_1_10="⅒"
    fractions_mapping_1_9="⅑"
    fractions_mapping_1_7="⅐"
    # Add more fractions if needed

    # Replace fractions in the file
    sed -i "" -e "s/1\/2/${fractions_mapping_1_2}/g" \
        -e "s/1\/3/${fractions_mapping_1_3}/g" \
        -e "s/2\/3/${fractions_mapping_2_3}/g" \
        -e "s/1\/4/${fractions_mapping_1_4}/g" \
        -e "s/3\/4/${fractions_mapping_3_4}/g" \
        -e "s/1\/5/${fractions_mapping_1_5}/g" \
        -e "s/2\/5/${fractions_mapping_2_5}/g" \
        -e "s/3\/5/${fractions_mapping_3_5}/g" \
        -e "s/4\/5/${fractions_mapping_4_5}/g" \
        -e "s/1\/6/${fractions_mapping_1_6}/g" \
        -e "s/5\/6/${fractions_mapping_5_6}/g" \
        -e "s/1\/8/${fractions_mapping_1_8}/g" \
        -e "s/3\/8/${fractions_mapping_3_8}/g" \
        -e "s/5\/8/${fractions_mapping_5_8}/g" \
        -e "s/7\/8/${fractions_mapping_7_8}/g" \
        -e "s/1\/10/${fractions_mapping_1_10}/g" \
        -e "s/1\/9/${fractions_mapping_1_9}/g" \
        -e "s/1\/7/${fractions_mapping_1_7}/g" \
        "$1"
}

# Define a function to lint markdown recipe files
replace_with_abbreviations() {
    # Map common spellings to their abbreviated forms
    abbreviations_mapping_tsp="Tsp"
    abbreviations_mapping_tsps="Tsps"
    abbreviations_mapping_tbsp="Tbsp"
    abbreviations_mapping_tbsps="Tbsps"
    abbreviations_mapping_cup="Cup "
    abbreviations_mapping_cups="Cups"
    abbreviations_mapping_ounce="oz"
    abbreviations_mapping_ounces="Ounces"
    abbreviations_mapping_pound="Lb"
    abbreviations_mapping_pounds="Lbs"
    abbreviations_mapping_quart="Qt"
    abbreviations_mapping_quarts="Qts"
    abbreviations_mapping_pint="Pt"
    abbreviations_mapping_pints="Pts"
    abbreviations_mapping_liter="L"
    abbreviations_mapping_liters="Ls"
    abbreviations_mapping_milliliter="Ml"
    abbreviations_mapping_milliliters="Mls"
    abbreviations_mapping_gram="G"
    abbreviations_mapping_grams="Gs"
    abbreviations_mapping_kilogram="Kg"
    abbreviations_mapping_kilograms="Kgs"

    # Replace common spellings with their abbreviated forms in the file
    sed -i "" -e "s/teaspoon/${abbreviations_mapping_tsp}/gi" \
        -e "s/teaspoons/${abbreviations_mapping_tsps}/gi" \
        -e "s/tablespoon/${abbreviations_mapping_tbsp}/gi" \
        -e "s/tablespoons/${abbreviations_mapping_tbsps}/gi" \
        -e "s/cup /${abbreviations_mapping_cup}/gi" \
        -e "s/cups/${abbreviations_mapping_cups}/gi" \
        -e "s/ounce/${abbreviations_mapping_ounce}/gi" \
        -e "s/ounces/${abbreviations_mapping_ounces}/gi" \
        -e "s/pound/${abbreviations_mapping_pound}/gi" \
        -e "s/pounds/${abbreviations_mapping_pounds}/gi" \
        -e "s/quart/${abbreviations_mapping_quart}/gi" \
        -e "s/quarts/${abbreviations_mapping_quarts}/gi" \
        -e "s/pint/${abbreviations_mapping_pint}/gi" \
        -e "s/pints/${abbreviations_mapping_pints}/gi" \
        -e "s/liter/${abbreviations_mapping_liter}/gi" \
        -e "s/liters/${abbreviations_mapping_liters}/gi" \
        -e "s/milliliter/${abbreviations_mapping_milliliter}/gi" \
        -e "s/milliliters/${abbreviations_mapping_milliliters}/gi" \
        -e "s/gram/${abbreviations_mapping_gram}/gi" \
        -e "s/grams/${abbreviations_mapping_grams}/gi" \
        -e "s/kilogram/${abbreviations_mapping_kilogram}/gi" \
        -e "s/kilograms/${abbreviations_mapping_kilograms}/gi" \
        "$1"

}

# Define a function to lint markdown recipe files
lint_markdown_files() {
    # Check if the file exists and is readable
    if [ -f "$1" ] && [ -r "$1" ]; then
        # Replace fractions in the file
        replace_fractions "$1"
        # Replace common spellings with their abbreviated forms in the file
        replace_with_abbreviations "$1"
        echo "Linted $1"
    else
        echo "Error: $1 is not a readable file." >&2
    fi
}

# Check if an argument is provided
if [ $# -eq 1 ]; then

    # Use the file path provided as an argument
    lint_markdown_files "$1"
else

    # Statement to print usage information
    echo "Usage: $0 <file.md>"
    echo "Lint markdown recipe files by replacing fractions and common spellings with their abbreviated forms."

fi
