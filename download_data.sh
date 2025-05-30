#!/bin/bash

mkdir -p data
cd data

# ------------------ Download CSV files ------------------

echo "Downloading parsed_questions_mass.csv..."
wget -q "https://osf.io/download/vyr5n" -O parsed_questions_mass.csv

echo "Downloading parsed_questions_stiff.csv..."
wget -q "https://osf.io/download/27skd" -O parsed_questions_stiff.csv

# ------------------ Download and extract bootstrap data ------------------

echo "Downloading parsed_questions_bootstrap.zip..."
wget -q "https://osf.io/download/5yg9w" -O parsed_questions_bootstrap.zip
unzip -q parsed_questions_bootstrap.zip
rm -rf __MACOSX
rm parsed_questions_bootstrap.zip

# ------------------ Download and extract NMDS data ------------------

echo "Downloading nmds.zip..."
wget -q "https://osf.io/download/87drt" -O nmds.zip
unzip -q nmds.zip
rm -rf __MACOSX
rm nmds.zip

# ------------------ Download wovenab.csv ------------------

echo "Creating wovenab directory and downloading wovenab.csv..."
mkdir -p wovenab
cd wovenab
wget -q "https://osf.io/download/esjfu" -O wovenab.csv
cd ..

# ------------------ Download and extract DNN data ------------------

echo "Downloading dnn.zip..."
wget -q "https://osf.io/download/nh4cq" -O dnn.zip
unzip -q dnn.zip
rm dnn.zip

# ------------------ Download and extract parsed_questions_dnn_over_epoch ------------------

echo "Downloading parsed_questions_dnn_over_epoch.zip..."
wget -q "https://osf.io/download/9cr8q" -O parsed_questions_dnn_over_epoch.zip
unzip -q parsed_questions_dnn_over_epoch.zip
rm parsed_questions_dnn_over_epoch.zip

# ------------------ Download and extract mass_wind.zip ------------------

echo "Downloading mass_wind.zip..."
wget -q "https://osf.io/download/fnsmp" -O mass_wind.zip
unzip -q mass_wind.zip
rm mass_wind.zip

echo "All files downloaded and extracted successfully."
cd ..
