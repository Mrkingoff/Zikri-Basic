import os
import sys
import subprocess
import socket
import requests
from pytube import YouTube
from colorama import init, Fore, Style

# Initialize colorama
init(autoreset=True)

def clear_cmd():
    os.system('cls' if os.name == 'nt' else 'clear')

def print_welcome():
    print(Fore.GREEN + "WELCOME TO ZKR4 PYTHON\n" + Style.RESET_ALL)

def downloader_youtube_mp4():
    clear_cmd()
    print_welcome()
    link = input("1. MASUKAN LINK YOUTUBE: ").strip()
    if not link:
        print("Link tidak boleh kosong!")
        return
    try:
        yt = YouTube(link)
        stream = yt.streams.get_highest_resolution()
        output_path = os.path.join(os.getcwd(), "YTVI")
        os.makedirs(output_path, exist_ok=True)
        stream.download(output_path=output_path)
        print(Fore.GREEN + f"SUKSES SAVE TO PATH {output_path}")
    except Exception as e:
        print(f"Error: {e}")

def downloader_youtube_mp3():
    clear_cmd()
    print_welcome()
    link = input("2. MASUKAN LINK YOUTUBE: ").strip()
    if not link:
        print("Link tidak boleh kosong!")
        return
    try:
        yt = YouTube(link)
        stream = yt.streams.filter(only_audio=True).first()
        output_path = os.path.join(os.getcwd(), "YTAUDI")
        os.makedirs(output_path, exist_ok=True)
        out_file = stream.download(output_path=output_path)
        # Rename to mp3
        base, ext = os.path.splitext(out_file)
        new_file = base + ".mp3"
        os.rename(out_file, new_file)
        print(Fore.GREEN + f"SUKSES SAVE TO PATH {output_path}")
    except Exception as e:
        print(f"Error: {e}")

def get_ip_info(ip):
    # Use ip-api.com free json API
    url = f"http://ip-api.com/json/{ip}"
    try:
        resp = requests.get(url, timeout=5)
        data = resp.json()
        if data['status'] == 'success':
            print(f"INFO NEGARA   : {data.get('country', '-')} ({data.get('countryCode', '-')})")
            print(f"INFO ALAMAT   : {data.get('regionName', '-')}, {data.get('city', '-')}")
            print(f"INFO ISP      : {data.get('isp', '-')}")
            print(f"INFO DOMAIN   : {data.get('org', '-')}")
            print(f"INFO ZIP      : {data.get('zip', '-')}")
            print(f"INFO LATITUDE : {data.get('lat', '-')}")
            print(f"INFO LONGITUDE: {data.get('lon', '-')}")
            # Ports info not available in this free API, skip or mention not available
            print(f"INFO PORT     : Info port tidak tersedia")
        else:
            print(f"Error: {data.get('message','Gagal mengambil data IP')}")
    except Exception as e:
        print(f"Error: {e}")

def checker_ip():
    clear_cmd()
    print_welcome()
    ip = input("3. MASUKAN IP: ").strip()
    if not ip:
        print("IP tidak boleh kosong!")
        return
    get_ip_info(ip)

def get_domain_info(domain):
    clear_cmd()
    print_welcome()
    try:
        ip = socket.gethostbyname(domain)
        print(f"INFO DOMAIN  : {domain}")
        print(f"INFO IP      : {ip}")
    except Exception as e:
        print(f"Error mendapatkan IP untuk domain: {e}")
        return
    # Get IP info
    url = f"http://ip-api.com/json/{ip}"
    try:
        resp = requests.get(url, timeout=5)
        data = resp.json()
        if data['status'] == 'success':
            print(f"INFO NEGARA  : {data.get('country', '-')}")
            print(f"INFO ISP     : {data.get('isp', '-')}")
            print(f"INFO ALAMAT  : {data.get('regionName', '-')}, {data.get('city', '-')}")
            print(f"INFO SERVER  : {data.get('org', '-')}")
        else:
            print(f"Error: {data.get('message','Gagal mengambil data domain')}")
    except Exception as e:
        print(f"Error: {e}")

def checker_domain():
    print("\n4. MASUKAN DOMAIN: ", end="")
    domain = input().strip()
    if not domain:
        print("Domain tidak boleh kosong!")
        return
    get_domain_info(domain)

def installer_youtube_downloader():
    clear_cmd()
    print_welcome()
    print("5. INSTALLER YOUTUBE DOWNLOADER")
    print("Mencoba menginstall dependencies yang dibutuhkan...")
    try:
        subprocess.check_call([sys.executable, "-m", "pip", "install", "--upgrade", "pytube", "colorama", "requests"])
        print(Fore.GREEN + "Instalasi berhasil!")
    except subprocess.CalledProcessError as e:
        print(f"Instalasi gagal: {e}")

def info_creator():
    clear_cmd()
    print_welcome()
    print("6. MY CREATOR")
    print(Fore.GREEN + "WA  : 6287740030436")
    print(Fore.GREEN + "TTK : @mexicoll1")
    print(Style.RESET_ALL)

def menu():
    while True:
        clear_cmd()
        print_welcome()
        print("PILIH SALAH SATU CMD | DENGAN NOMOR")
        print("1. DOWNLOADER YOUTUBE MP4")
        print("2. DOWNLOADER YOUTUBE MP3")
        print("3. CEK INFO IP")
        print("4. CEK DOMAIN TO IP")
        print("5. INSTALLEE DOWNLOADER YTB")
        print("6. INFO CREATOR")
        print("0. Exit")
        choice = input("\nPilih menu (0-6): ").strip()
        if choice == "1":
            downloader_youtube_mp4()
            input("\nTekan Enter untuk kembali ke menu...")
        elif choice == "2":
            downloader_youtube_mp3()
            input("\nTekan Enter untuk kembali ke menu...")
        elif choice == "3":
            checker_ip()
            input("\nTekan Enter untuk kembali ke menu...")
        elif choice == "4":
            checker_domain()
            input("\nTekan Enter untuk kembali ke menu...")
        elif choice == "5":
            installer_youtube_downloader()
            input("\nTekan Enter untuk kembali ke menu...")
        elif choice == "6":
            info_creator()
            input("\nTekan Enter untuk kembali ke menu...")
        elif choice == "0":
            print("Keluar... Terima kasih!")
            break
        else:
            print("Pilihan tidak valid!")
            input("\nTekan Enter untuk kembali ke menu...")

if __name__ == "__main__":
    try:
        menu()
    except KeyboardInterrupt:
        print("\nKeluar... Terima kasih!")
        sys.exit()
