for file in *.xlsx; do
# Wyciągnij numer NNN z początku nazwy pliku
if [[ "$file" =~ ^([0-9]{3})\  ]]; then
num="${BASH_REMATCH[1]}"
mkdir -p "$num"
mv "$file" "$num/"
fi
done