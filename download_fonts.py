import urllib.request
import zipfile
import os
import shutil

def download_and_extract(url, name):
    print(f"Downloading {name}...")
    zip_path = f"{name}.zip"
    
    req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
    with urllib.request.urlopen(req) as response, open(zip_path, 'wb') as out_file:
        shutil.copyfileobj(response, out_file)
        
    with zipfile.ZipFile(zip_path, 'r') as zip_ref:
        zip_ref.extractall(f"fonts/{name}")
    os.remove(zip_path)
    
    # move ttfs to fonts/
    for root, dirs, files in os.walk(f"fonts/{name}"):
        for file in files:
            if file.endswith('.ttf'):
                dest = os.path.join("fonts", file)
                if not os.path.exists(dest):
                    shutil.move(os.path.join(root, file), dest)
    shutil.rmtree(f"fonts/{name}")

os.makedirs('fonts', exist_ok=True)
download_and_extract("https://fonts.google.com/download?family=Manrope", "Manrope")
download_and_extract("https://fonts.google.com/download?family=Inter", "Inter")
print("Done!")
