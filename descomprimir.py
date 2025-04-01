import os
import zipfile
import argparse

def mostrar_mensaje_rutas_largas():
    mensaje = """
    🚨 Error: La ruta es demasiado larga para Windows.
    Para solucionar este problema, habilita las rutas largas en Windows:

    1. Abre el Editor del Registro (Win + R, escribe 'regedit', presiona Enter).
    2. Ve a la clave:
       HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem
    3. Busca la clave 'LongPathsEnabled' (si no existe, créala como DWORD).
    4. Cámbiala a 1 para habilitar rutas largas.
    5. Reinicia el sistema y vuelve a ejecutar el script.
    """
    print(mensaje)

def descomprimir_zip(directorio_base):
    if not os.path.isdir(directorio_base):
        print(f"Error: La ruta '{directorio_base}' no existe.")
        return

    for foldername in os.listdir(directorio_base):
        folder_path = os.path.join(directorio_base, foldername)
        
        if os.path.isdir(folder_path):
            for file in os.listdir(folder_path):
                if file.endswith(".zip"):
                    zip_path = os.path.join(folder_path, file)
                    print(f"Descomprimiendo: {zip_path}")

                    try:
                        with zipfile.ZipFile(zip_path, 'r') as zip_ref:
                            extract_path = os.path.join(folder_path, "extracted")
                            os.makedirs(extract_path, exist_ok=True)
                            zip_ref.extractall(extract_path)  # Extrae en una carpeta más corta
                        print(f"Extraído en: {extract_path}")
                    except FileNotFoundError:
                        mostrar_mensaje_rutas_largas()
                        return

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Descomprime archivos ZIP dentro de subcarpetas.")
    parser.add_argument("ruta", help="Ruta de la carpeta principal donde están las subcarpetas con los archivos ZIP.")
    args = parser.parse_args()

    descomprimir_zip(args.ruta)
