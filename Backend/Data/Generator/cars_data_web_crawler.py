from selenium import webdriver
from selenium.webdriver.chrome.webdriver import ChromiumDriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.remote.webelement import WebElement
from selenium.webdriver.common.by import By
import json

from my_utils import sleepFor

current_car = 0
current_maker = 0
current_variant = 0
current_model = 0

chrome_options = Options()
chrome_options.add_argument("user-data-dir=/Users/gabrielcarvalho/Library/Application Support/Google/Chrome/")
chrome_service = Service("./chromedriver")

driver: ChromiumDriver = webdriver.Chrome(options=chrome_options, service=chrome_service)
sleepFor(2)
driver.get("https://www.cars-data.com/en/car-brands-cars-logos.html")
sleepFor(2)

def extract_number(string: str):
    result_string: [character] = []
    for character in string:
        if character.isnumeric() or character == ",":
            if character == ",":
                result_string += "."
            else:
                result_string += character

    result_string = str("".join(result_string))
    if len(result_string) == 0:
        print("Failed to convert", string, "to number (result string is empty)")
        return None
    try:
        if "." in result_string:
            return float(str(result_string))
        else:
            return int(str(result_string))
    except:
        print("Failed to convert", string, "to number")
        return None

def openLink(link: str):
    driver.get(link)

# MAKERS
makers: [WebElement] = driver.find_elements(By.XPATH, f'//div[@class="models"]//a[@href]')
famous_makers = ["Aston Martin", "Audi", "BMW", "Bugatti",
                 "Corvette", "Dodge", "Ferrari", "Honda",
                 "Hyundai", "Jaguar", "Lamborghini", "Land Rover",
                 "Lexus", "Lotus", "Maserati", "Mazda", "McLaren",
                 "Mercedes-Benz","Mitsubishi", "Nissan", "Porsche",
                 "Rolls-Royce", "Subaru", "Tesla", "Toyota", "Volvo"]

with open('cars.json', 'w') as fp:
    fp.write('{ "cars": [')
    fp.close()

maker_links: list[str] = [maker.get_attribute("href") for maker in makers if maker.text in famous_makers]
maker_links = list(dict.fromkeys(maker_links))

for maker_link in maker_links:
    openLink(maker_link)
    current_maker += 1

    # CARS
    cars: [WebElement] = driver.find_elements(By.XPATH, f'//section[@class="models"]//a[@href]')
    cars_links: list[str] = [car.get_attribute("href") for car in cars[1:]] # First link is always to return to the category
    cars_links = list(dict.fromkeys(cars_links))
    current_car = 0
    for car_link in cars_links:
        openLink(car_link)
        current_car += 1

        # VARIANTS
        sections: [WebElement] = driver.find_elements(By.XPATH, f'//section[@class="models"]')
        sections = [section for section in sections if "People Who Viewed Also Viewed" not in section.text]

        variants: [WebElement] = []
        for section in sections:
            variants += section.find_elements(By.XPATH, f'./child::div//a[@href]')

        variant_links: list[str] = [variant.get_attribute("href") for variant in variants[1:]] # First link is always to return to the category
        if len(variant_links) > 0:
            variant_links = [variant_links[0]]

        current_variant = 0
        for variant_link in variant_links:
            openLink(variant_link)
            current_variant += 1

            # MODELS
            models: [WebElement] = driver.find_elements(By.XPATH, f'//section[@class="types"]//a[@href]')
            original_models_links: list[str] = [model.get_attribute("href") for model in models if "specs" in model.get_attribute("href")]
            models_links = original_models_links
            if len(original_models_links) > 0:
                models_links = [original_models_links[0]]

            current_model = 0
            models_links = list(dict.fromkeys(models_links))
            for model_link in models_links:
                openLink(model_link)
                current_model += 1

                # SPECS
                possible_car_name_elements = driver.find_elements(By.XPATH, f'//li//span[contains(@itemprop, "name")]')
                name_element = None
                if len(possible_car_name_elements) > 0:
                    name_element = possible_car_name_elements[len(possible_car_name_elements) - 1]

                description = driver.find_element(By.XPATH, f'//div[@class="col-10"]//h2')

                name = None
                if name_element is None:
                    possible_name = description.text.split(" is")
                    if len(possible_name) > 0:
                        name = possible_name[0]
                else:
                    name = name_element.text

                car_dict = {
                    "drive": {},
                    "performance": {},
                    "consumption": {},
                    "cargo_capacity": {},
                }
                if name is not None:
                    car_dict["name"] = name
                    year = None
                    if "Executive" in name or "XDrive" in name:
                        print("Skipped car: year", name)
                        continue
                    if len(name) >= 4:
                        year = name[-4:]
                    if year is None:
                        print("No year found in:", name, model_link)

                    year = extract_number(year)
                    if year is None:
                        year = name[:4]
                        year = extract_number(year)
                        if year is not None:
                            print("Nevermind, found it:", year)
                    if year is not None:
                        if year < 2007:
                            print("Skipped car: year", year)
                            continue
                        car_dict["year"] = int(year)

                if description is not None:
                    car_dict["description"] = description.text


                spec_rows: [WebElement] = driver.find_elements(By.XPATH, f'//tr')
                for spec_row in spec_rows:
                    spec = spec_row.find_elements(By.XPATH, f'./child::*')
                    if len(spec) == 2:
                        key = spec[0].text
                        value = spec[1].text

                        # General
                        if "Price:" == key:
                            value = extract_number(value)
                            if value is not None:
                                car_dict["price"] = value
                        elif "Body Type:" == key:
                            new_value = value.split(" ")
                            if len(new_value) >= 2:
                                car_type = new_value[1]
                                if len(car_type) > 0:
                                    car_type = car_type.split("/")[0]
                            else:
                                car_type = value
                            car_dict["type"] = car_type
                        elif "Transmission:" == key:
                            car_dict["transmission"] = value

                        # Drive
                        elif "Drive Wheel:" == key:
                            car_dict["drive"]["traction"] = value
                        elif "Engine/motor Type:" == key:
                            car_dict["drive"]["engine_type"] = value
                        elif "Fuel Type:" == key:
                            car_dict["drive"]["fuel_type"] = value
                        elif "Power:" == key:
                            values= value.split("(")
                            if len(values) >= 2:
                                value = values[1].replace(" hp)", "")
                            value = extract_number(value)
                            if value is not None:
                                car_dict["drive"]["power"] = value

                        # Performance
                        elif "Top Speed:" == key:
                            values= value.split(" ")
                            if len(values) >= 2:
                                value = values[0]
                            value = extract_number(value)
                            if value is not None:
                                car_dict["performance"]["top_speed"] = value
                        elif "Acceleration 0-100 Km / H:" == key:
                            value = extract_number(value)
                            if value is not None:
                                car_dict["performance"]["acceleration"] = value

                        # Consumption
                        elif "Urban Consumption:" == key:
                            values = value.split(" ")
                            if len(values) >= 2:
                                value = extract_number(values[0])
                                if value is not None:
                                    car_dict["consumption"]["urban_consumption"] = value
                        elif "Extra-urban Consumption:" == key:
                            values = value.split(" ")
                            if len(values) >= 2:
                                value = extract_number(values[0])
                                if value is not None:
                                    car_dict["consumption"]["road_consumption"] = value

                        # Luggage
                        elif "Cargo Capacity:" == key:
                            values = value.replace(" l", "")
                            values = values.split("-")
                            if len(values) >= 2:
                                min_litters = extract_number(values[0])
                                max_litters = extract_number(values[1])
                                if min_litters is not None:
                                    car_dict["cargo_capacity"]["min_litters"] = min_litters
                                if max_litters is not None:
                                    car_dict["cargo_capacity"]["max_litters"] = max_litters
                            else:
                                max_litters = extract_number(value)
                                if max_litters is not None:
                                    car_dict["cargo_capacity"]["max_litters"] = max_litters

                images = driver.find_elements(By.XPATH, f'//img')
                car_images_urls = [car_image.get_attribute("src") for car_image in images if "pictures/thumbs/" in car_image.get_attribute("src")]
                car_dict["images"] = car_images_urls

                with open('result.json', 'a') as fp:
                    json.dump(car_dict, fp)
                    fp.write(", ")
                    print(f'\nmaker {current_maker}/{len(maker_links)}')
                    print(f'car {current_car}/{len(cars_links)}')
                    print(f'variant {current_variant}/{len(variant_links)}')
                    print(f'model {current_model}/{len(models_links)}')
                    models_url_components = model_link.split('/')
                    if len(models_url_components) > 1:
                        print(f'model:', models_url_components[len(models_url_components) - 2].replace("-specs", ""))

with open('cars.json', 'a') as fp:
    fp.write("]}")
    fp.close()

