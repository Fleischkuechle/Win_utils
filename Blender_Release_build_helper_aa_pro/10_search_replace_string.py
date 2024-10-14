import sys

#python replace_string.py file_to_modify.py old_string new_string



def replace_string_in_file(file_path:str, search_string:str, replace_string:str):
    with open(file_path, 'r') as file:
        file_data = file.read()

    new_file_data = file_data.replace(search_string, replace_string)

    with open(file_path, 'w') as file:
        file.write(new_file_data)

if __name__ == "__main__":
    if len(sys.argv) < 4:
        print("Usage: python script.py <file_path> <search_string> <replace_string>")
        sys.exit(1)

    file_path:str = sys.argv[1]
    search_string:str = sys.argv[2]
    replace_string:str = sys.argv[3]

    replace_string_in_file(file_path, search_string, replace_string)
    print(f"Successfully replaced '{search_string}' with '{replace_string}' in '{file_path}'.")
