import urllib.request
import re
import os

os.makedirs('fonts', exist_ok=True)

def download_font(family, weights, filename_prefix):
    url = f"https://fonts.googleapis.com/css2?family={family}:wght@{weights}&display=swap"
    # Old Safari UA to force TTF instead of WOFF2
    req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.75.14 (KHTML, like Gecko) Version/7.0.3 Safari/7046A194A'})
    
    with urllib.request.urlopen(req) as response:
        css = response.read().decode('utf-8')
    
    # Extract URLs
    urls = re.findall(r"url\((https://[^)]+\.ttf)\)", css)
    if not urls:
        print(f"Failed to find TTF for {family}")
        print(css)
        return
        
    print(f"Downloading {filename_prefix}.ttf...")
    req_font = urllib.request.Request(urls[0], headers={'User-Agent': 'Mozilla/5.0'})
    with urllib.request.urlopen(req_font) as response_font:
        with open(f"fonts/{filename_prefix}.ttf", 'wb') as f:
            f.write(response_font.read())

download_font("Manrope", "400", "Manrope-Regular")
download_font("Manrope", "600", "Manrope-SemiBold")
download_font("Manrope", "700", "Manrope-Bold")
download_font("Manrope", "800", "Manrope-ExtraBold")

download_font("Inter", "400", "Inter-Regular")
download_font("Inter", "500", "Inter-Medium")
download_font("Inter", "600", "Inter-SemiBold")

print("All fonts downloaded.")
