import csv, json
import sys

if len(sys.argv) != 4:
    print("Supply exactly three arguments: the csv, the json file and the output file")
    print(sys.argv[0], "<csv> <json> <out>")
    exit(1)

CSV_FILE = sys.argv[1]
JSON_FILE = sys.argv[2]
OUT_FILE = sys.argv[3]
print("csv:", CSV_FILE)
print("json:", JSON_FILE)
print("out:", OUT_FILE)
print("---------------")

print("loading csv", end=' ')
csv_data = []
with open(CSV_FILE, 'r', encoding='utf-8') as csv_file:
    reader = csv.reader(csv_file, )
    for row in reader:
        csv_data.append(row)
print("[done]")

print("loading json", end=' ')
json_data = {}
with open(JSON_FILE, 'r', encoding='utf-8') as json_file:
    json_data = json.load(json_file)
print("[done]")

print("modify metadata")
DECK_ID = 0
deck_core = json_data['ObjectStates'][DECK_ID]

deck_core['Nickname'] = "Academia Polonia - Syllable Cards"
deck_core['Description'] = "PnP Syllable Cards"
deck_core['Tooltip'] = True

print("modify cards")
deck_cards = deck_core['ContainedObjects']

for i, card in enumerate(deck_cards):
    card_id = i + 1
    print('card [' + str(card_id) + ']',end=' ')
    card['Nickname'] = csv_data[card_id][0] + " [" + csv_data[card_id][3] + ", " + csv_data[card_id][4] + ", " + csv_data[card_id][1] + ", " + csv_data[card_id][2] + "]"
    card['Description'] = csv_data[card_id][1] + "\n" + csv_data[card_id][2]

print("\nwrite out")
with open(OUT_FILE, 'w', encoding='utf-8') as out_file:
    json.dump(json_data, out_file, indent=4, ensure_ascii=False)