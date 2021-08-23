import os

if __name__ == "__main__":
    os.system("cmake -S . -B build")
    os.system("cmake --build build")