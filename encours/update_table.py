import csv

# 1. Lire les données du fichier CSV (mettez le vrai nom de votre fichier)
csv_filename = "donnees.csv"
html_filename = "index.html"

lignes_html = ""
encodings_to_try = ("utf-8-sig", "utf-8", "cp1252", "latin-1")

for encoding in encodings_to_try:
    try:
        with open(csv_filename, mode="r", encoding=encoding, newline="") as file:
            reader = csv.reader(file)
            next(reader, None)  # Saute l'entête du CSV si nécessaire

            for row in reader:
                # Transforme chaque ligne CSV en ligne de tableau HTML <tr>
                cellules = "".join(f"<td>{cellule}</td>" for cellule in row)
                lignes_html += f"        <tr>{cellules}</tr>\n"
        break
    except UnicodeDecodeError:
        continue
else:
    raise UnicodeDecodeError("utf-8", b"", 0, 1, "Impossible de décoder le fichier CSV avec les encodages supportés.")

# 2. Lire le fichier HTML actuel
with open(html_filename, "r", encoding="utf-8") as file:
    html_content = file.read()

# 3. Remplacer le contenu entre les balises repères
debut_balise = "<!-- DEBUT_TABLEAU -->"
fin_balise = "<!-- FIN_TABLEAU -->"

if debut_balise in html_content and fin_balise in html_content:
    partie_1 = html_content.split(debut_balise)[0]
    partie_2 = html_content.split(fin_balise)[1]

    nouveau_html = f"{partie_1}{debut_balise}\n{lignes_html}        {fin_balise}{partie_2}"

    # 4. Sauvegarder le fichier index.html mis à jour
    with open(html_filename, "w", encoding="utf-8") as file:
        file.write(nouveau_html)
    print("HTML mis à jour avec succès depuis le CSV !")
else:
    print("Aucune balise de repère trouvée dans index.html; la page utilise un rendu dynamique et le script n'a donc rien modifié.")
