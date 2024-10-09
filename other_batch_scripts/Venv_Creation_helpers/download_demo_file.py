import os
import sys
from urllib.parse import unquote
import requests

fileURL:str = "https://drive.usercontent.google.com/download?id=1GijsBB7ImGuyXm2QEcegVeG9bNBHt664&export=download&authuser=0&confirm=t&uuid=4abf52a3-f8fe-4c70-b624-a9e1f2a69031&at=APZUnTW5dJsY3cnP_xDoaiHfdCal%3A1715439634835"
filename:str = "Demo_With_Astra_From_Mixamo.blend"
script_dir:str = os.getcwd()
parent_folder_path:str = os.path.dirname(script_dir)
output_folder_path = os.path.join(parent_folder_path, "BackendCoreClassLib", "BlendFile")
full_file_path:str=""
def download_file(file_url, output_folder)->str:
    # file_name = file_url.split('/')[-2] + ".blend"  # Extract the filename from the URL and add the file extension
    file_name = filename
    response = requests.get(file_url, stream=True)
    
    total_size = int(response.headers.get('content-length', 0))
    block_size = 1024  # 1 KB
    full_file_path=os.path.join(output_folder, file_name)
    with open(full_file_path, 'wb') as file:
        downloaded = 0
        for data in response.iter_content(block_size):
            downloaded += len(data)
            file.write(data)
            progress = downloaded / total_size * 100
            sys.stdout.write(f"\rDownloading... {progress:.2f}%")
            sys.stdout.flush()
    return full_file_path
full_file_path=download_file(fileURL, output_folder_path)
print("")
print( "You should find the file here: "+full_file_path)
print("download completed you can close this window now, you ")
