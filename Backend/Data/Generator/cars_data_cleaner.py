import json
from cars_data_web_crawler import extract_number

# Opening JSON file
f = open('cars.json')

# returns JSON object as
# a dictionary
data = json.load(f)

id = 1
years = range(2007, 2023)
years = [str(year) for year in years]
for car in data["cars"]:
    car["id"] = id
    for year in years:
        car_name = car["name"]
        if year in car_name:
            car["name"] = car_name.replace(year, "").strip()
        car_name = car["name"]
        if "\u00e9" in car_name:
            car["name"] = car_name.replace("\u00e9", "é")
    car["images"] = sorted(car["images"], key=lambda x: extract_number(x[-6:]))
    id += 1

with open('cars-cleaned.json', 'w') as fp:
    json.dump(data, fp)
    fp.close()
